-- actions.lua — Super-layer key dispatch + workspace / display helpers
--
-- superAction(key, modifiers) is the single entry point from space_super.
-- Modifiers are the real Ctrl/Alt/Shift flags; Space itself is conceptual Super.

local M = {}

local grid = nil
local log = hs.logger.new("actions", "info")

function M.init(g)
	grid = g
	return M
end

---------------------------------------------------------------------------
-- Workspace management (Mission Control Spaces)
---------------------------------------------------------------------------

--- Ordered list of space IDs for the focused window's screen (or main screen).
local function space_list()
	local win = hs.window.focusedWindow()
	local screen = (win and win:screen()) or hs.screen.mainScreen()
	local spaces = hs.spaces.spacesForScreen(screen)
	return spaces or {}, screen
end

local function space_at(index)
	local spaces = space_list()
	return spaces[index]
end

function M.switch_space(index)
	local sid = space_at(index)
	if not sid then
		log.w("no space at index " .. tostring(index))
		return
	end
	hs.spaces.gotoSpace(sid)
end

function M.move_window_to_space(index)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local sid = space_at(index)
	if not sid then
		log.w("no space at index " .. tostring(index))
		return
	end
	hs.spaces.moveWindowToSpace(win, sid)
	hs.spaces.gotoSpace(sid)
	hs.timer.doAfter(0.15, function()
		win:focus()
		if grid then
			grid.refresh()
		end
	end)
end

---------------------------------------------------------------------------
-- Display management
---------------------------------------------------------------------------

local SCREEN_DIRS = {
	h = "West",
	j = "South",
	k = "North",
	l = "East",
	left = "West",
	down = "South",
	up = "North",
	right = "East",
}

function M.move_window_to_screen(dir_key)
	local win = hs.window.focusedWindow()
	if not win then
		return
	end
	local method = SCREEN_DIRS[dir_key]
	if not method then
		return
	end
	-- e.g. moveOneScreenWest(false, true) — keep relative position in space
	local fn = win["moveOneScreen" .. method]
	if fn then
		fn(win, true, true)
		hs.timer.doAfter(0.1, function()
			if grid then
				grid.refresh()
			end
		end)
	end
end

---------------------------------------------------------------------------
-- Window helpers
---------------------------------------------------------------------------

function M.close_window()
	local win = hs.window.focusedWindow()
	if win then
		win:close()
	end
end

function M.toggle_fullscreen()
	local win = hs.window.focusedWindow()
	if win then
		win:toggleFullScreen()
	end
end

function M.toggle_float()
	-- hcolumns2d doesn't float yet; zoom as a stand-in maximize/restore feel
	local win = hs.window.focusedWindow()
	if win then
		win:toggleZoom()
	end
end

---------------------------------------------------------------------------
-- Dispatcher
---------------------------------------------------------------------------

local DIRS = {
	h = "left",
	j = "down",
	k = "up",
	l = "right",
	left = "left",
	down = "down",
	up = "up",
	right = "right",
}

--- Single Super-layer dispatcher.
--- key: lowercase key name ("h", "1", "left", …)
--- modifiers: { ctrl=, alt=, shift=, cmd= }
function M.superAction(key, modifiers)
	modifiers = modifiers or {}
	local ctrl = modifiers.ctrl
	local alt = modifiers.alt
	local shift = modifiers.shift

	-- ignore if cmd sneaks in (shouldn't for layer keys we own)
	if modifiers.cmd then
		return
	end

	local dir = DIRS[key]
	local digit = tonumber(key)

	-- Super + Ctrl + Q → reload Hammerspoon
	if key == "q" and ctrl and not shift and not alt then
		hs.reload()
		return
	end

	-- Super + Q → close
	if key == "q" and not ctrl and not shift and not alt then
		M.close_window()
		return
	end

	-- Super + F → fullscreen
	if key == "f" and not ctrl and not alt then
		M.toggle_fullscreen()
		return
	end

	-- Super + T → float/zoom toggle
	if key == "t" and not ctrl and not alt and not shift then
		M.toggle_float()
		return
	end

	-- Super + R → retile
	if key == "r" and not ctrl and not alt and not shift then
		if grid then
			grid.refresh()
		end
		return
	end

	-- Super + Shift + N → new column
	if key == "n" and shift and not ctrl and not alt then
		if grid then
			grid.new_column()
		end
		return
	end

	-- Super + 1..9 / Super + Shift + 1..9 → spaces
	if digit and digit >= 1 and digit <= 9 and not ctrl and not alt then
		if shift then
			M.move_window_to_space(digit)
		else
			M.switch_space(digit)
		end
		return
	end

	-- Directional: focus / move / resize / display
	if dir and grid then
		if ctrl and not shift and not alt then
			-- Super + Ctrl + H/L → column width; J/K → row height
			if dir == "left" then
				grid.resize(-50)
			elseif dir == "right" then
				grid.resize(50)
			elseif dir == "up" then
				grid.vresize(-50)
			elseif dir == "down" then
				grid.vresize(50)
			end
			return
		end

		if alt and not ctrl then
			-- Super + Alt + H/J/K/L → move window to adjacent display
			M.move_window_to_screen(key)
			return
		end

		if shift and not ctrl and not alt then
			grid.move(dir)
			return
		end

		if not ctrl and not alt and not shift then
			grid.focus(dir)
			return
		end
	end

	-- Remaining layer keys (w/e/a/s/d/z/x/c/v, …) reserved — no-op for now
	log.d(string.format("unbound Super+%s ctrl=%s alt=%s shift=%s", key, tostring(ctrl), tostring(alt), tostring(shift)))
end

return M
