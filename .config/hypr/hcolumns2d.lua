-- hcolumns2d: a 2D scrolling layout. Columns run left-to-right (horizontal
-- scroll, same idea as hcolumns.lua), and each column stacks its windows
-- top-to-bottom (vertical scroll within that column). Every window
-- defaults to 80% of the monitor height, so the window above/below peeks
-- in as a preview -- same idea as hcolumns' 65%-width columns -- but can be
-- resized individually (see vresize() below).
--
--   [A][B][D][F]
--      [C][E]
--      [G]
--
-- New windows stack directly below the focused window in its column by
-- default; call `new_column()` once beforehand to start a fresh column
-- instead. Hyprland's built-in movewindow dispatcher only understands a
-- single flat left/right ordering (no independent up/down axis), so
-- move/resize here go through layout_msg instead of the generic
-- window.move / window.resize dispatchers -- see hcolumns.lua's docs for
-- why resizeTarget can't be used directly either.
--
-- All layout state (columns, widths, heights, ...) is kept per-workspace
-- (see `get_state` below) -- Hyprland creates one algorithm instance per
-- workspace, but this Lua module is a single shared VM-wide table, so
-- without partitioning by workspace id a recalculate() for one workspace
-- would prune/clobber every other workspace's columns out from under it
-- (this is exactly what an exclusive-focus layer-shell surface like tofi
-- can trigger, by forcing a relayout across workspaces while it holds
-- focus).
--
-- Usage, from hyprland.lua:
--   local grid = require("hcolumns2d")
--   grid.setup()
--   hl.config({ general = { layout = "lua:hcolumns2d" } })
--   hl.bind(mainMod .. " + SHIFT + N", grid.new_column())
--   hl.bind(mainMod .. " + SHIFT + CONTROL + H", grid.move("left"))
--   hl.bind(mainMod .. " + SHIFT + CONTROL + L", grid.move("right"))
--   hl.bind(mainMod .. " + SHIFT + CONTROL + J", grid.move("down"))
--   hl.bind(mainMod .. " + SHIFT + CONTROL + K", grid.move("up"))
--   hl.bind(mainMod .. " + CONTROL + H", grid.resize(-50)) -- resizes the focused column's width
--   hl.bind(mainMod .. " + CONTROL + L", grid.resize(50))
--   hl.bind(mainMod .. " + CONTROL + K", grid.vresize(-50)) -- resizes the focused window's height
--   hl.bind(mainMod .. " + CONTROL + J", grid.vresize(50))

local M = {}

local DEFAULT_COL_WIDTH_RATIO = 0.8 -- new column width, as a fraction of monitor width
local MIN_COL_WIDTH = 200
local DEFAULT_ROW_HEIGHT_RATIO = 0.8 -- new window height, as a fraction of monitor height
local MIN_ROW_HEIGHT = 150

-- per-workspace state, persists for the lifetime of the lua VM (i.e. until
-- the next full config reload). workspace id -> {
--   columns       = array of columns; each column is an array of window addresses, top to bottom
--   col_width     = parallel to `columns`: width (px) of each column
--   col_last_row  = parallel to `columns`: row last brought into view while that column was focused
--   row_height    = window address -> committed height (px)
--   focused_addr  = address of the truly-focused window on this workspace
--   pending_new_column = one-shot flag set by new_column()
-- }
local workspaces = {}

local function get_state(wsid)
	local s = workspaces[wsid]
	if not s then
		s = {
			columns = {},
			col_width = {},
			col_last_row = {},
			row_height = {},
			focused_addr = nil,
			pending_new_column = false,
		}
		workspaces[wsid] = s
	end
	return s
end

--- the workspace id a recalculate()/layout_msg() ctx belongs to, derived
--- from its first target (every target in one call belongs to the same
--- workspace). Falls back to a shared bucket if there are no targets to
--- ask (e.g. an empty workspace).
local function workspace_of(ctx)
	local target = ctx.targets[1]
	local ws = target and target.window and target.window.workspace
	return (ws and ws.id) or 0
end

local function default_width(ctx)
	return ctx.area.w * DEFAULT_COL_WIDTH_RATIO
end

local function default_height(ctx)
	return ctx.area.h * DEFAULT_ROW_HEIGHT_RATIO
end

--- this window's committed height, falling back to (and persisting) the default.
local function height_for(ctx, s, addr)
	local h = s.row_height[addr] or default_height(ctx)
	if h < MIN_ROW_HEIGHT then
		h = default_height(ctx)
	end
	s.row_height[addr] = h
	return h
end

--- column index and row index of `addr` within state `s`, or nil if it
--- isn't placed yet.
local function locate(s, addr)
	if not addr then
		return nil, nil
	end
	for ci, col in ipairs(s.columns) do
		for ri, a in ipairs(col) do
			if a == addr then
				return ci, ri
			end
		end
	end
	return nil, nil
end

--- drop addresses that no longer have a live target, removing any column
--- that becomes empty (keeping col_width/col_last_row in lockstep).
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

	for addr in pairs(s.row_height) do
		if not seen[addr] then
			s.row_height[addr] = nil
		end
	end
end

--- place a newly-seen window: stack it directly below the focused window in
--- its column, or start a new column if requested / there's nothing yet.
local function place_new(ctx, s, addr)
	if s.pending_new_column or #s.columns == 0 then
		table.insert(s.columns, { addr })
		table.insert(s.col_width, default_width(ctx))
		table.insert(s.col_last_row, 1)
		s.pending_new_column = false
		return
	end

	local ci, ri = locate(s, s.focused_addr)
	if not ci then
		ci, ri = #s.columns, #s.columns[#s.columns]
	end
	table.insert(s.columns[ci], ri + 1, addr)
end

--- discover new windows (in ctx.targets but not yet in `s.columns`) and drop
--- closed ones, returning an address -> target lookup for placement.
local function sync(ctx, s)
	local by_addr, seen = {}, {}

	for _, target in ipairs(ctx.targets) do
		local addr = target.window and target.window.address or nil
		if addr then
			by_addr[addr] = target
			seen[addr] = true
			if not locate(s, addr) then
				place_new(ctx, s, addr)
			end
		end
	end

	prune(s, seen)
	return by_addr
end

--- horizontal shift that centers the focused column in the visible area.
local function h_scroll(ctx, s, xs, ci)
	local view_center = ctx.area.x + ctx.area.w / 2
	local focus_center = xs[ci] + s.col_width[ci] / 2
	return focus_center - view_center
end

--- vertical shift that centers the row at [row_top, row_top + row_h) in the
--- visible area.
local function v_scroll(ctx, row_top, row_h)
	local view_center = ctx.area.y + ctx.area.h / 2
	local row_center = row_top + row_h / 2
	return row_center - view_center
end

local function recalculate(ctx)
	if #ctx.targets == 0 then
		return
	end

	local s = get_state(workspace_of(ctx))
	local by_addr = sync(ctx, s)
	local focus_ci, focus_ri = locate(s, s.focused_addr)

	local xs = {}
	local x = ctx.area.x
	for ci = 1, #s.columns do
		xs[ci] = x
		x = x + s.col_width[ci]
	end

	local hscroll = focus_ci and h_scroll(ctx, s, xs, focus_ci) or 0

	for ci, col in ipairs(s.columns) do
		-- each row can have its own committed height, so accumulate
		-- per-column instead of assuming a uniform row height
		local ys, hs = {}, {}
		local y = ctx.area.y
		for ri, addr in ipairs(col) do
			hs[ri] = height_for(ctx, s, addr)
			ys[ri] = y
			y = y + hs[ri]
		end

		-- the focused column scrolls to its truly-focused row; every other
		-- column keeps whatever row it was last showing, instead of
		-- resetting to the top when focus moves away from it
		local anchor_ri = ci == focus_ci and focus_ri or math.min(s.col_last_row[ci] or 1, #col)
		if ci == focus_ci then
			s.col_last_row[ci] = anchor_ri
		end
		local vscroll = v_scroll(ctx, ys[anchor_ri], hs[anchor_ri])

		for ri, addr in ipairs(col) do
			local target = by_addr[addr]
			if target then
				target:place({
					x = xs[ci] - hscroll,
					y = ys[ri] - vscroll,
					w = s.col_width[ci],
					h = hs[ri],
				})
			end
		end
	end
end

--- grow/shrink the focused window's column (shared by every window in it).
local function do_resize_width(s, delta)
	local ci = locate(s, s.focused_addr)
	if not ci then
		return
	end
	s.col_width[ci] = math.max(MIN_COL_WIDTH, s.col_width[ci] + delta)
end

--- grow/shrink the focused window's own height.
local function do_resize_height(ctx, s, delta)
	if not s.focused_addr then
		return
	end
	s.row_height[s.focused_addr] = math.max(MIN_ROW_HEIGHT, height_for(ctx, s, s.focused_addr) + delta)
end

--- reorder within a column (up/down), or move the focused window into the
--- adjacent column (left/right), creating that column if it doesn't exist
--- yet and dropping the source column if it's left empty.
local function do_move(ctx, s, dir)
	local ci, ri = locate(s, s.focused_addr)
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

	local addr = s.focused_addr
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
		table.insert(s.columns, 1, { addr })
		table.insert(s.col_width, 1, default_width(ctx))
		table.insert(s.col_last_row, 1, 1)
	elseif target_ci > #s.columns then
		table.insert(s.columns, { addr })
		table.insert(s.col_width, default_width(ctx))
		table.insert(s.col_last_row, 1)
	else
		local insert_ri = (dir == "left") and (#s.columns[target_ci] + 1) or 1
		s.col_last_row[target_ci] = insert_ri
		table.insert(s.columns[target_ci], insert_ri, addr)
	end
end

--- driven by `hl.dsp.layout(msg)`: a bare number resizes the focused
--- column's width, "vresize <delta>" resizes the focused window's own
--- height, "move <dir>" reorders/moves the focused window, and "newcol"
--- arms the one-shot new-column flag. Hyprland calls recalculate() again
--- right after this returns, so there's nothing else to do here.
local function layout_msg(ctx, msg)
	local s = get_state(workspace_of(ctx))

	local delta = tonumber(msg)
	if delta then
		do_resize_width(s, delta)
		return
	end

	local cmd, arg = msg:match("^(%S+)%s*(.-)$")
	if cmd == "move" then
		do_move(ctx, s, arg)
	elseif cmd == "vresize" then
		do_resize_height(ctx, s, tonumber(arg))
	elseif cmd == "newcol" then
		s.pending_new_column = true
	end
end

--- a pure focus change doesn't trigger layout recalculate() on its own, so
--- track the real focus via the window.active event (more reliable than
--- reading target.window.active back out of a stale target list) and nudge
--- the layout with a zero-delta resize to force the scroll-into-view.
local function on_window_active(win)
	if win and win.workspace then
		get_state(win.workspace.id).focused_addr = win.address
	end
	hl.dispatch(hl.dsp.window.resize({ x = 0, y = 0, relative = true }))
end

function M.setup()
	hl.on("window.active", on_window_active)
	hl.layout.register("hcolumns2d", {
		recalculate = recalculate,
		layout_msg = layout_msg,
	})
end

--- resize the focused window's column width.
function M.resize(delta)
	return hl.dsp.layout(tostring(delta))
end

--- resize the focused window's own height.
function M.vresize(delta)
	return hl.dsp.layout("vresize " .. delta)
end

function M.move(dir)
	return hl.dsp.layout("move " .. dir)
end

function M.new_column()
	return hl.dsp.layout("newcol")
end

return M
