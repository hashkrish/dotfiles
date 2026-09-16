-- hcolumns: a PaperWM-style horizontal scrolling layout.
--
-- One fixed-width column per window, laid out left-to-right. Columns are
-- allowed to run off both edges of the monitor instead of shrinking to fit,
-- and the whole strip scrolls so the focused column is always fully
-- visible. Column width is adjustable per-window via layout_msg (see
-- `resize()` below), since Hyprland's resizeTarget() never touches a lua
-- layout's target box -- mouse-drag / resizeactive genuinely cannot resize
-- a column here, layout_msg is the only mechanism that works.
--
-- Usage, from hyprland.lua:
--   require("hcolumns").setup()
--   hl.config({ general = { layout = "lua:hcolumns" } })

local M = {}

local DEFAULT_WIDTH_RATIO = 0.65 -- new column width, as a fraction of the monitor width
local MIN_WIDTH = 200 -- floor for both defaults and layout_msg resizes

-- state, persists across recalculate()/layout_msg() calls for the lifetime
-- of the lua VM (i.e. until the next full config reload)
local widths = {} -- window address -> committed column width (px)
local focused_addr = nil -- address of the truly-focused window

--- default column width for a monitor area of the given size.
local function default_width(ctx)
	return ctx.area.w * DEFAULT_WIDTH_RATIO
end

--- this window's committed width, falling back to (and persisting) the default.
local function width_for(ctx, addr)
	local w = (addr and widths[addr]) or default_width(ctx)
	if w < MIN_WIDTH then
		w = default_width(ctx)
	end
	if addr then
		widths[addr] = w
	end
	return w
end

--- drop cached widths for windows that no longer have a target (closed,
--- moved to another workspace/layout, etc).
local function prune_widths(seen)
	for addr in pairs(widths) do
		if not seen[addr] then
			widths[addr] = nil
		end
	end
end

--- lay out every target left-to-right at its committed width, returning
--- per-column x positions/widths plus the index of the focused column.
local function compute_columns(ctx)
	local xs, ws = {}, {}
	local x = ctx.area.x
	local focus_i = nil
	local seen = {}

	for i, target in ipairs(ctx.targets) do
		local addr = target.window and target.window.address or nil
		if addr then
			seen[addr] = true
		end

		local w = width_for(ctx, addr)
		xs[i], ws[i] = x, w
		x = x + w

		if addr and addr == focused_addr then
			focus_i = i
		elseif not focus_i and target.window and target.window.active then
			focus_i = i
		end
	end

	prune_widths(seen)
	return xs, ws, (focus_i or 1)
end

--- the horizontal shift that centers the focused column in the monitor's
--- visible area.
local function compute_scroll(ctx, xs, ws, focus_i)
	local view_center = ctx.area.x + ctx.area.w / 2
	local focus_center = xs[focus_i] + ws[focus_i] / 2
	return focus_center - view_center
end

local function recalculate(ctx)
	if #ctx.targets == 0 then
		return
	end

	local xs, ws, focus_i = compute_columns(ctx)
	local scroll = compute_scroll(ctx, xs, ws, focus_i)

	for i, target in ipairs(ctx.targets) do
		target:place({
			x = xs[i] - scroll,
			y = ctx.area.y,
			w = ws[i],
			h = ctx.area.h,
		})
	end
end

--- driven by `hl.dsp.layout("<delta>")`: grows/shrinks the focused column's
--- width by <delta> px. Hyprland calls recalculate() again right after this
--- returns, so there's nothing else to do here.
local function layout_msg(ctx, msg)
	local delta = tonumber(msg)
	if not delta or not focused_addr then
		return
	end
	widths[focused_addr] = math.max(MIN_WIDTH, width_for(ctx, focused_addr) + delta)
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
	hl.layout.register("hcolumns", {
		recalculate = recalculate,
		layout_msg = layout_msg,
	})
end

--- grow/shrink the focused column; bind these to your resize keys, e.g.
--- hl.bind(mainMod .. " + CONTROL + H", M.resize(-50), { repeating = true })
function M.resize(delta)
	return hl.dsp.layout(tostring(delta))
end

return M
