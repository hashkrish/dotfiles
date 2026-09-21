-- hcolumns2d: a 2D scrolling layout for Hammerspoon, ported from the Hyprland
-- layout of the same name. Columns run left-to-right (horizontal scroll), and
-- each column stacks its windows top-to-bottom (vertical scroll within that
-- column). Every window defaults to 80% of the screen height / column width,
-- so the neighbour peeks in as a preview.
--
--   [A][B][D][F]
--      [C][E]
--      [G]
--
-- New windows stack directly below the focused window in its column by
-- default; call `new_column()` once beforehand to start a fresh column
-- instead.
--
-- macOS cannot place windows fully off-screen, so columns/rows that would
-- scroll away are parked in a thin peek margin on the screen edge (same
-- compromise PaperWM.spoon makes).
--
-- Usage, from init.lua:
--   local grid = require("hcolumns2d")
--   grid.start()
--   grid.bindHotkeys({
--     focus_left  = {{"alt", "cmd"}, "h"},
--     focus_right = {{"alt", "cmd"}, "l"},
--     focus_up    = {{"alt", "cmd"}, "k"},
--     focus_down  = {{"alt", "cmd"}, "j"},
--     move_left   = {{"alt", "cmd", "shift"}, "h"},
--     move_right  = {{"alt", "cmd", "shift"}, "l"},
--     move_up     = {{"alt", "cmd", "shift"}, "k"},
--     move_down   = {{"alt", "cmd", "shift"}, "j"},
--     resize_narrower = {{"alt", "cmd", "ctrl"}, "h"},
--     resize_wider    = {{"alt", "cmd", "ctrl"}, "l"},
--     vresize_shorter = {{"alt", "cmd", "ctrl"}, "k"},
--     vresize_taller  = {{"alt", "cmd", "ctrl"}, "j"},
--     new_column      = {{"alt", "cmd", "shift"}, "n"},
--   })

local M = {}

--- seconds for focus / move / resize / retile animations. Set to 0 to disable.
--- mod+scroll pan always uses 0 so it stays responsive.
M.animation_duration = 0.2

local DEFAULT_COL_WIDTH_RATIO = 0.8
local MIN_COL_WIDTH = 200
local DEFAULT_ROW_HEIGHT_RATIO = 0.8
local MIN_ROW_HEIGHT = 150
local RESIZE_STEP = 50
local PEEK_MARGIN = 40 -- px of off-screen windows left visible at the edge
local WINDOW_GAP = 8

-- space id -> {
--   columns       = array of columns; each column is an array of window ids, top to bottom
--   col_width     = parallel to `columns`: width (px) of each column
--   col_last_row  = parallel to `columns`: row last brought into view while that column was focused
--   row_height    = window id -> committed height (px)
--   focused_id    = id of the truly-focused window on this space
--   pending_new_column = one-shot flag set by new_column()
-- }
local spaces = {}
local win_filter = nil
local hotkeys = {}
local started = false

local log = hs.logger.new("hcolumns2d", "info")

local function get_state(space_id)
	local s = spaces[space_id]
	if not s then
		s = {
			columns = {},
			col_width = {},
			col_last_row = {},
			row_height = {},
			focused_id = nil,
			pending_new_column = false,
			pan_x = 0, -- extra horizontal scroll from mod+scroll / gestures
			pan_y = 0,
		}
		spaces[space_id] = s
	end
	return s
end

local function space_of_window(win)
	if not win then
		return nil
	end
	local ok, space_id = pcall(hs.spaces.windowSpaces, win)
	if ok and space_id and space_id[1] then
		return space_id[1]
	end
	-- fall back to the focused space on the window's screen
	local screen = win:screen()
	if not screen then
		return nil
	end
	local ok2, focused = pcall(hs.spaces.activeSpaceOnScreen, screen)
	if ok2 then
		return focused
	end
	return nil
end

local function screen_area(win)
	local screen = win and win:screen() or hs.screen.mainScreen()
	local frame = screen:frame() -- respects menu bar / dock
	return {
		x = frame.x + WINDOW_GAP,
		y = frame.y + WINDOW_GAP,
		w = frame.w - 2 * WINDOW_GAP,
		h = frame.h - 2 * WINDOW_GAP,
		screen = screen,
	}
end

local function default_width(area)
	return area.w * DEFAULT_COL_WIDTH_RATIO
end

local function default_height(area)
	return area.h * DEFAULT_ROW_HEIGHT_RATIO
end

local function height_for(area, s, id)
	local h = s.row_height[id] or default_height(area)
	if h < MIN_ROW_HEIGHT then
		h = default_height(area)
	end
	s.row_height[id] = h
	return h
end

local function locate(s, id)
	if not id then
		return nil, nil
	end
	for ci, col in ipairs(s.columns) do
		for ri, wid in ipairs(col) do
			if wid == id then
				return ci, ri
			end
		end
	end
	return nil, nil
end

local function prune(s, seen)
	local ci = 1
	while ci <= #s.columns do
		local col = s.columns[ci]
		local ri = 1
		while ri <= #col do
			if seen[col[ri]] then
				ri = ri + 1
			else
				table.remove(col, ri)
			end
		end
		if #col == 0 then
			table.remove(s.columns, ci)
			table.remove(s.col_width, ci)
			table.remove(s.col_last_row, ci)
		else
			ci = ci + 1
		end
	end

	for id in pairs(s.row_height) do
		if not seen[id] then
			s.row_height[id] = nil
		end
	end
end

local function place_new(area, s, id)
	if s.pending_new_column or #s.columns == 0 then
		table.insert(s.columns, { id })
		table.insert(s.col_width, default_width(area))
		table.insert(s.col_last_row, 1)
		s.pending_new_column = false
		return
	end

	local ci, ri = locate(s, s.focused_id)
	if not ci then
		ci, ri = #s.columns, #s.columns[#s.columns]
	end
	table.insert(s.columns[ci], ri + 1, id)
end

--- windows currently on `space_id` that we manage.
local function managed_windows(space_id)
	local result, seen = {}, {}

	local function consider(win)
		if not win then
			return
		end
		local id = win:id()
		if not id or seen[id] then
			return
		end
		local ok, standard = pcall(function()
			return win:isStandard() and not win:isFullScreen() and win:isVisible()
		end)
		if not ok or not standard then
			return
		end
		if space_of_window(win) ~= space_id then
			return
		end
		seen[id] = true
		table.insert(result, win)
	end

	-- filter list (may lag behind brand-new windows)
	if win_filter then
		for _, win in ipairs(win_filter:getWindows()) do
			consider(win)
		end
	end
	-- fall back to visible windows so creates aren't missed
	for _, win in ipairs(hs.window.visibleWindows()) do
		consider(win)
	end
	-- always include the focused window on this space
	consider(hs.window.focusedWindow())

	return result
end

-- Forward declaration: adopt_window calls recalculate before its definition.
local recalculate

--- place `win` into layout state if we don't already track it, then retile.
local function adopt_window(win)
	if not win then
		return false
	end
	local ok, eligible = pcall(function()
		return win:isStandard() and not win:isFullScreen()
	end)
	if not ok or not eligible then
		return false
	end
	local id = win:id()
	if not id then
		return false
	end
	local space_id = space_of_window(win)
	if not space_id then
		return false
	end

	local s = get_state(space_id)
	local area = screen_area(win)
	if not locate(s, id) then
		-- prefer stacking under whatever currently has focus
		local focused = hs.window.focusedWindow()
		if focused and focused:id() ~= id then
			s.focused_id = focused:id()
		end
		place_new(area, s, id)
	end
	s.focused_id = id
	recalculate(space_id)
	return true
end

local function sync(area, s, wins)
	local by_id, seen = {}, {}

	for _, win in ipairs(wins) do
		local id = win:id()
		if id then
			by_id[id] = win
			seen[id] = true
			if not locate(s, id) then
				place_new(area, s, id)
			end
		end
	end

	prune(s, seen)
	return by_id
end

local function h_scroll(area, s, xs, ci)
	local view_center = area.x + area.w / 2
	local focus_center = xs[ci] + s.col_width[ci] / 2
	return focus_center - view_center
end

local function v_scroll(area, row_top, row_h)
	local view_center = area.y + area.h / 2
	local row_center = row_top + row_h / 2
	return row_center - view_center
end

--- clamp a frame so macOS will accept it.
---
--- macOS will not place a window above the screen top: asking for y < area.y
--- pulls the window fully on-screen, so the neighbour above never scrolls away
--- when focusing down. Park those as a top peek.
---
--- The bottom is allowed to hang off-screen, so we only peek-clamp there when
--- the window would be almost fully gone — otherwise neighbours sit just below
--- the focused window with WINDOW_GAP (no giant empty band).
local function clamp_frame(frame, area)
	local x, y, w, h = frame.x, frame.y, frame.w, frame.h

	-- horizontal: keep a peek strip visible
	if x + w < area.x + PEEK_MARGIN then
		x = area.x + PEEK_MARGIN - w
	elseif x > area.x + area.w - PEEK_MARGIN then
		x = area.x + area.w - PEEK_MARGIN
	end

	-- vertical
	if h >= area.h then
		y = area.y + (area.h - h) / 2
	elseif y < area.y then
		-- would stick out the top → top-edge peek (macOS can't hang above)
		y = area.y + PEEK_MARGIN - h
	elseif y > area.y + area.h - PEEK_MARGIN then
		-- almost fully below → bottom-edge peek
		y = area.y + area.h - PEEK_MARGIN
	end

	return { x = x, y = y, w = w, h = h }
end

local function place_window(win, frame, area, duration)
	local clamped = clamp_frame(frame, area)
	local dur = duration or 0
	local prev = hs.window.animationDuration
	hs.window.animationDuration = dur
	win:setFrame(clamped, dur)
	hs.window.animationDuration = prev
end

--- retile `space_id`. `duration` overrides M.animation_duration; pass 0 for
--- instant (used by pan).
recalculate = function(space_id, duration)
	if not space_id then
		return
	end

	local wins = managed_windows(space_id)
	if #wins == 0 then
		return
	end

	local dur = duration
	if dur == nil then
		dur = M.animation_duration or 0
	end

	local area = screen_area(wins[1])
	local s = get_state(space_id)
	local by_id = sync(area, s, wins)
	local focus_ci, focus_ri = locate(s, s.focused_id)

	local xs = {}
	local x = area.x
	for ci = 1, #s.columns do
		xs[ci] = x
		x = x + s.col_width[ci] + WINDOW_GAP
	end

	local hscroll = (focus_ci and h_scroll(area, s, xs, focus_ci) or 0) + (s.pan_x or 0)

	for ci, col in ipairs(s.columns) do
		local ys, hs = {}, {}
		local y = area.y
		for ri, id in ipairs(col) do
			hs[ri] = height_for(area, s, id)
			ys[ri] = y
			y = y + hs[ri] + WINDOW_GAP
		end

		local anchor_ri = ci == focus_ci and focus_ri or math.min(s.col_last_row[ci] or 1, #col)
		if ci == focus_ci then
			s.col_last_row[ci] = anchor_ri
		end
		local vscroll = v_scroll(area, ys[anchor_ri], hs[anchor_ri]) + (s.pan_y or 0)

		for ri, id in ipairs(col) do
			local win = by_id[id]
			if win then
				place_window(win, {
					x = xs[ci] - hscroll,
					y = ys[ri] - vscroll,
					w = s.col_width[ci],
					h = hs[ri],
				}, area, dur)
			end
		end
	end
end

local function do_resize_width(s, delta)
	local ci = locate(s, s.focused_id)
	if not ci then
		return
	end
	s.col_width[ci] = math.max(MIN_COL_WIDTH, s.col_width[ci] + delta)
end

local function do_resize_height(area, s, delta)
	if not s.focused_id then
		return
	end
	s.row_height[s.focused_id] = math.max(MIN_ROW_HEIGHT, height_for(area, s, s.focused_id) + delta)
end

local function do_move(area, s, dir)
	local ci, ri = locate(s, s.focused_id)
	if not ci then
		return
	end

	if dir == "up" or dir == "down" then
		local col = s.columns[ci]
		local nri = ri + (dir == "up" and -1 or 1)
		if nri < 1 or nri > #col then
			return
		end
		col[ri], col[nri] = col[nri], col[ri]
		return
	end

	if dir ~= "left" and dir ~= "right" then
		return
	end

	local id = s.focused_id
	local col = s.columns[ci]
	table.remove(col, ri)

	local source_removed = false
	if #col == 0 then
		table.remove(s.columns, ci)
		table.remove(s.col_width, ci)
		table.remove(s.col_last_row, ci)
		source_removed = true
	end

	local target_ci = ci + (dir == "left" and -1 or 1)
	if source_removed and dir == "right" then
		target_ci = target_ci - 1
	end

	if target_ci < 1 then
		table.insert(s.columns, 1, { id })
		table.insert(s.col_width, 1, default_width(area))
		table.insert(s.col_last_row, 1, 1)
	elseif target_ci > #s.columns then
		table.insert(s.columns, { id })
		table.insert(s.col_width, default_width(area))
		table.insert(s.col_last_row, 1)
	else
		local insert_ri = (dir == "left") and (#s.columns[target_ci] + 1) or 1
		s.col_last_row[target_ci] = insert_ri
		table.insert(s.columns[target_ci], insert_ri, id)
	end
end

local function focused_context()
	local win = hs.window.focusedWindow()
	if not win then
		return nil
	end
	local space_id = space_of_window(win)
	if not space_id then
		return nil
	end
	local s = get_state(space_id)
	s.focused_id = win:id()
	return {
		win = win,
		space_id = space_id,
		s = s,
		area = screen_area(win),
	}
end

local function retile_focused()
	local ctx = focused_context()
	if ctx then
		recalculate(ctx.space_id)
	end
end

--- focus the neighbour in `dir` ("left"/"right"/"up"/"down") and scroll it
--- into view. Clears any temporary pan offset so the focused window centers.
function M.focus(dir)
	local ctx = focused_context()
	if not ctx then
		return
	end
	local s = ctx.s
	local ci, ri = locate(s, s.focused_id)
	if not ci then
		return
	end

	local nci, nri = ci, ri
	if dir == "left" then
		nci = ci - 1
		if nci < 1 then
			return
		end
		nri = math.min(s.col_last_row[nci] or 1, #s.columns[nci])
	elseif dir == "right" then
		nci = ci + 1
		if nci > #s.columns then
			return
		end
		nri = math.min(s.col_last_row[nci] or 1, #s.columns[nci])
	elseif dir == "up" then
		nri = ri - 1
		if nri < 1 then
			return
		end
	elseif dir == "down" then
		nri = ri + 1
		if nri > #s.columns[ci] then
			return
		end
	else
		return
	end

	local target_id = s.columns[nci][nri]
	local wins = managed_windows(ctx.space_id)
	for _, win in ipairs(wins) do
		if win:id() == target_id then
			s.focused_id = target_id
			s.pan_x, s.pan_y = 0, 0
			win:focus()
			recalculate(ctx.space_id)
			return
		end
	end
end

--- shift the viewport by (dx, dy) pixels without changing focus. Used by
--- mod+scroll panning. Always instant so scrolling stays responsive.
function M.pan(dx, dy)
	local ctx = focused_context()
	if not ctx then
		return
	end
	ctx.s.pan_x = (ctx.s.pan_x or 0) + (dx or 0)
	ctx.s.pan_y = (ctx.s.pan_y or 0) + (dy or 0)
	recalculate(ctx.space_id, 0)
end

function M.reset_pan()
	local ctx = focused_context()
	if not ctx then
		return
	end
	ctx.s.pan_x, ctx.s.pan_y = 0, 0
	recalculate(ctx.space_id)
end

function M.move(dir)
	local ctx = focused_context()
	if not ctx then
		return
	end
	do_move(ctx.area, ctx.s, dir)
	recalculate(ctx.space_id)
end

function M.resize(delta)
	local ctx = focused_context()
	if not ctx then
		return
	end
	do_resize_width(ctx.s, delta)
	recalculate(ctx.space_id)
end

function M.vresize(delta)
	local ctx = focused_context()
	if not ctx then
		return
	end
	do_resize_height(ctx.area, ctx.s, delta)
	recalculate(ctx.space_id)
end

function M.new_column()
	local ctx = focused_context()
	if not ctx then
		return
	end
	ctx.s.pending_new_column = true
	hs.alert.show("next window → new column", 0.8)
end

function M.refresh()
	retile_focused()
end

local function on_window_created(win)
	-- New windows often lack a space / standard role for a beat; retry.
	local attempts = 0
	local function try()
		attempts = attempts + 1
		if not win or not win:id() then
			return
		end
		if adopt_window(win) then
			return
		end
		if attempts < 12 then
			hs.timer.doAfter(0.1, try)
		end
	end
	hs.timer.doAfter(0.05, try)
end

local function on_window_destroyed(win, _app_name, event)
	-- event carries the id after the window is gone; win may be nil
	local id = win and win:id()
	if not id and type(event) == "number" then
		id = event
	end
	-- retile every space that might have held it
	for space_id, s in pairs(spaces) do
		if id and locate(s, id) then
			if s.focused_id == id then
				s.focused_id = nil
			end
			recalculate(space_id)
		end
	end
	-- also retile the focused space in case we missed the id
	retile_focused()
end

local function on_window_focused(win)
	-- Always try to adopt: focus is how we catch windows the filter missed
	-- on create (and how we scroll an already-managed window into view).
	adopt_window(win)
end

local function on_window_moved_or_resized(win)
	-- ignore user drags for now; layout owns geometry. Retile on screen change.
	if not win then
		return
	end
	local space_id = space_of_window(win)
	if space_id and locate(get_state(space_id), win:id()) then
		-- no-op: we don't adopt manual resizes into committed sizes via mouse
	end
end

local function on_screen_changed()
	retile_focused()
end

local screen_watcher = nil

function M.start()
	if started then
		return M
	end

	win_filter = hs.window.filter.new()
	-- Do not filter to currentSpace here: brand-new windows can miss events.
	-- We scope by space ourselves in managed_windows / adopt_window.
	win_filter:setDefaultFilter({
		visible = true,
		fullscreen = false,
		allowRoles = "AXStandardWindow",
	})
	win_filter:subscribe(hs.window.filter.windowCreated, on_window_created)
	win_filter:subscribe(hs.window.filter.windowDestroyed, on_window_destroyed)
	win_filter:subscribe(hs.window.filter.windowFocused, on_window_focused)
	win_filter:subscribe(hs.window.filter.windowMoved, on_window_moved_or_resized)
	win_filter:subscribe({
		hs.window.filter.windowFullscreened,
		hs.window.filter.windowUnfullscreened,
		hs.window.filter.windowHidden,
		hs.window.filter.windowUnhidden,
		hs.window.filter.windowVisible,
		hs.window.filter.windowOnScreen,
		hs.window.filter.windowUnminimized,
	}, function(win)
		if win then
			adopt_window(win)
		else
			retile_focused()
		end
	end)

	screen_watcher = hs.screen.watcher.new(on_screen_changed)
	screen_watcher:start()

	-- initial tile of every visible window on the focused space
	local focused = hs.window.focusedWindow()
	if focused then
		adopt_window(focused)
	else
		retile_focused()
	end

	started = true
	log.i("started")
	return M
end

function M.stop()
	if win_filter then
		win_filter:unsubscribeAll()
		win_filter = nil
	end
	if screen_watcher then
		screen_watcher:stop()
		screen_watcher = nil
	end
	for _, hk in ipairs(hotkeys) do
		hk:delete()
	end
	hotkeys = {}
	spaces = {}
	started = false
	log.i("stopped")
	return M
end

--- bind the usual hcolumns2d actions. Missing keys are simply skipped.
--- See module header for the expected mapping names.
function M.bindHotkeys(mapping)
	local actions = {
		focus_left = function()
			M.focus("left")
		end,
		focus_right = function()
			M.focus("right")
		end,
		focus_up = function()
			M.focus("up")
		end,
		focus_down = function()
			M.focus("down")
		end,
		move_left = function()
			M.move("left")
		end,
		move_right = function()
			M.move("right")
		end,
		move_up = function()
			M.move("up")
		end,
		move_down = function()
			M.move("down")
		end,
		resize_narrower = function()
			M.resize(-RESIZE_STEP)
		end,
		resize_wider = function()
			M.resize(RESIZE_STEP)
		end,
		vresize_shorter = function()
			M.vresize(-RESIZE_STEP)
		end,
		vresize_taller = function()
			M.vresize(RESIZE_STEP)
		end,
		new_column = function()
			M.new_column()
		end,
		refresh = function()
			M.refresh()
		end,
	}

	for name, mods_key in pairs(mapping or {}) do
		local fn = actions[name]
		if fn and type(mods_key) == "table" then
			local mods, key = mods_key[1], mods_key[2]
			-- pressed + repeat for continuous resize/move
			local hk = hs.hotkey.bind(mods, key, fn, nil, fn)
			table.insert(hotkeys, hk)
		end
	end
	return M
end

return M
