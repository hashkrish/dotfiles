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

-- state, persists for the lifetime of the lua VM (i.e. until the next full
-- config reload)
local columns = {} -- array of columns; each column is an array of window addresses, top to bottom
local col_width = {} -- parallel to `columns`: width (px) of each column
local col_last_row = {} -- parallel to `columns`: row last brought into view while that column was focused
local row_height = {} -- window address -> committed height (px)
local focused_addr = nil -- address of the truly-focused window
local pending_new_column = false -- one-shot flag set by new_column()

local function default_width(ctx)
	return ctx.area.w * DEFAULT_COL_WIDTH_RATIO
end

local function default_height(ctx)
	return ctx.area.h * DEFAULT_ROW_HEIGHT_RATIO
end

--- this window's committed height, falling back to (and persisting) the default.
local function height_for(ctx, addr)
	local h = row_height[addr] or default_height(ctx)
	if h < MIN_ROW_HEIGHT then
		h = default_height(ctx)
	end
	row_height[addr] = h
	return h
end

--- column index and row index of `addr`, or nil if it isn't placed yet.
local function locate(addr)
	if not addr then
		return nil, nil
	end
	for ci, col in ipairs(columns) do
		for ri, a in ipairs(col) do
			if a == addr then
				return ci, ri
			end
		end
	end
	return nil, nil
end

--- drop addresses that no longer have a live target, removing any column
--- that becomes empty (keeping col_width in lockstep).
local function prune(seen)
	local ci = 1
	while ci <= #columns do
		local col = columns[ci]
		local ri = 1
		while ri <= #col do
			if seen[col[ri]] then
				ri = ri + 1
			else
				table.remove(col, ri)
			end
		end
		if #col == 0 then
			table.remove(columns, ci)
			table.remove(col_width, ci)
			table.remove(col_last_row, ci)
		else
			ci = ci + 1
		end
	end

	for addr in pairs(row_height) do
		if not seen[addr] then
			row_height[addr] = nil
		end
	end
end

--- place a newly-seen window: stack it directly below the focused window in
--- its column, or start a new column if requested / there's nothing yet.
local function place_new(ctx, addr)
	if pending_new_column or #columns == 0 then
		table.insert(columns, { addr })
		table.insert(col_width, default_width(ctx))
		table.insert(col_last_row, 1)
		pending_new_column = false
		return
	end

	local ci, ri = locate(focused_addr)
	if not ci then
		ci, ri = #columns, #columns[#columns]
	end
	table.insert(columns[ci], ri + 1, addr)
end

--- discover new windows (in ctx.targets but not yet in `columns`) and drop
--- closed ones, returning an address -> target lookup for placement.
local function sync(ctx)
	local by_addr, seen = {}, {}

	for _, target in ipairs(ctx.targets) do
		local addr = target.window and target.window.address or nil
		if addr then
			by_addr[addr] = target
			seen[addr] = true
			if not locate(addr) then
				place_new(ctx, addr)
			end
		end
	end

	prune(seen)
	return by_addr
end

--- horizontal shift that centers the focused column in the visible area.
local function h_scroll(ctx, xs, ci)
	local view_center = ctx.area.x + ctx.area.w / 2
	local focus_center = xs[ci] + col_width[ci] / 2
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

	local by_addr = sync(ctx)
	local focus_ci, focus_ri = locate(focused_addr)

	local xs = {}
	local x = ctx.area.x
	for ci = 1, #columns do
		xs[ci] = x
		x = x + col_width[ci]
	end

	local hscroll = focus_ci and h_scroll(ctx, xs, focus_ci) or 0

	for ci, col in ipairs(columns) do
		-- each row can have its own committed height, so accumulate
		-- per-column instead of assuming a uniform row height
		local ys, hs = {}, {}
		local y = ctx.area.y
		for ri, addr in ipairs(col) do
			hs[ri] = height_for(ctx, addr)
			ys[ri] = y
			y = y + hs[ri]
		end

		-- the focused column scrolls to its truly-focused row; every other
		-- column keeps whatever row it was last showing, instead of
		-- resetting to the top when focus moves away from it
		local anchor_ri = ci == focus_ci and focus_ri or math.min(col_last_row[ci] or 1, #col)
		if ci == focus_ci then
			col_last_row[ci] = anchor_ri
		end
		local vscroll = v_scroll(ctx, ys[anchor_ri], hs[anchor_ri])

		for ri, addr in ipairs(col) do
			local target = by_addr[addr]
			if target then
				target:place({
					x = xs[ci] - hscroll,
					y = ys[ri] - vscroll,
					w = col_width[ci],
					h = hs[ri],
				})
			end
		end
	end
end

--- grow/shrink the focused window's column (shared by every window in it).
local function do_resize_width(delta)
	local ci = locate(focused_addr)
	if not ci then
		return
	end
	col_width[ci] = math.max(MIN_COL_WIDTH, col_width[ci] + delta)
end

--- grow/shrink the focused window's own height.
local function do_resize_height(ctx, delta)
	if not focused_addr then
		return
	end
	row_height[focused_addr] = math.max(MIN_ROW_HEIGHT, height_for(ctx, focused_addr) + delta)
end

--- reorder within a column (up/down), or move the focused window into the
--- adjacent column (left/right), creating that column if it doesn't exist
--- yet and dropping the source column if it's left empty.
local function do_move(ctx, dir)
	local ci, ri = locate(focused_addr)
	if not ci then
		return
	end

	if dir == "up" or dir == "down" then
		local col = columns[ci]
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

	local addr = focused_addr
	local col = columns[ci]
	table.remove(col, ri)

	local source_removed = false
	if #col == 0 then
		table.remove(columns, ci)
		table.remove(col_width, ci)
		table.remove(col_last_row, ci)
		source_removed = true
	end

	local target_ci = ci + (dir == "left" and -1 or 1)
	if source_removed and dir == "right" then
		target_ci = target_ci - 1
	end

	if target_ci < 1 then
		table.insert(columns, 1, { addr })
		table.insert(col_width, 1, default_width(ctx))
		table.insert(col_last_row, 1, 1)
	elseif target_ci > #columns then
		table.insert(columns, { addr })
		table.insert(col_width, default_width(ctx))
		table.insert(col_last_row, 1)
	else
		local insert_ri = (dir == "left") and (#columns[target_ci] + 1) or 1
		col_last_row[target_ci] = insert_ri
		table.insert(columns[target_ci], insert_ri, addr)
	end
end

--- driven by `hl.dsp.layout(msg)`: a bare number resizes the focused
--- column's width, "vresize <delta>" resizes the focused window's own
--- height, "move <dir>" reorders/moves the focused window, and "newcol"
--- arms the one-shot new-column flag. Hyprland calls recalculate() again
--- right after this returns, so there's nothing else to do here.
local function layout_msg(ctx, msg)
	local delta = tonumber(msg)
	if delta then
		do_resize_width(delta)
		return
	end

	local cmd, arg = msg:match("^(%S+)%s*(.-)$")
	if cmd == "move" then
		do_move(ctx, arg)
	elseif cmd == "vresize" then
		do_resize_height(ctx, tonumber(arg))
	elseif cmd == "newcol" then
		pending_new_column = true
	end
end

--- a pure focus change doesn't trigger layout recalculate() on its own, so
--- track the real focus via the window.active event (more reliable than
--- reading target.window.active back out of a stale target list) and nudge
--- the layout with a zero-delta resize to force the scroll-into-view.
local function on_window_active(win)
	focused_addr = win and win.address or nil
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
