-- space_super.lua — Space-as-Super input layer
--
-- Tap Space  → emit a normal space
-- Hold Space + key → call onAction(key, {ctrl,alt,shift}) with Space as Super
--
-- Does NOT synthesize Hyper (ctrl+alt+cmd+shift). Real Ctrl/Alt/Shift from
-- the event are passed through so Super+Ctrl, Super+Alt, etc. stay independent.
--
-- Space is left alone when Cmd/Alt/Ctrl are already held (Spotlight, input
-- source switching, etc.).

local M = {}

local SPACE_KEYCODE = 49

-- Minimum Super-layer keys from the spec, plus a few hcolumns2d extras.
local DEFAULT_KEYS = {
	h = true,
	j = true,
	k = true,
	l = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
	f = true,
	q = true,
	w = true,
	e = true,
	r = true,
	t = true,
	a = true,
	s = true,
	d = true,
	z = true,
	x = true,
	c = true,
	v = true,
	-- hcolumns2d extras
	n = true,
	left = true,
	right = true,
	up = true,
	down = true,
}

local space_down = false
local space_used = false
local pressed_keys = {} -- keycode → true, swallowed while Super held
local layer_keys = DEFAULT_KEYS
local on_action = nil
local tap = nil

local log = hs.logger.new("space_super", "info")

local function keycode_name(code)
	-- hs.keycodes.map is bidirectional; prefer string names
	local name = hs.keycodes.map[code]
	if type(name) == "string" then
		return name:lower()
	end
	return nil
end

--- Emit a real Space after the current event finishes. The tap is stopped
--- while posting so the synthetic down/up cannot be re-intercepted (a sync
--- boolean flag clears before those events are delivered).
local function emit_space()
	hs.timer.doAfter(0, function()
		if tap then
			tap:stop()
		end
		-- keyStroke posts down+up; 0 = no delay between them
		hs.eventtap.keyStroke({}, "space", 0)
		if tap then
			tap:start()
		end
	end)
end

local function modifiers_from(event)
	local flags = event:getFlags()
	return {
		ctrl = flags.ctrl or false,
		alt = flags.alt or false,
		shift = flags.shift or false,
		-- cmd is intentionally NOT part of the Super layer; Space is Super
		cmd = flags.cmd or false,
	}
end

local function handle(event)
	local etype = event:getType()
	local keyDown = hs.eventtap.event.types.keyDown
	local keyUp = hs.eventtap.event.types.keyUp
	local code = event:getKeyCode()
	local is_down = etype == keyDown
	local is_up = etype == keyUp

	-- Space itself
	if code == SPACE_KEYCODE then
		if is_down then
			-- autorepeat while held: keep swallowing, don't reset state
			if space_down then
				return true
			end
			local flags = event:getFlags()
			-- let system combos through (Spotlight, input source, …)
			if flags.cmd or flags.alt or flags.ctrl then
				return false
			end
			space_down = true
			space_used = false
			pressed_keys = {}
			return true -- consume; tap will emit on release if unused
		end

		if is_up then
			if not space_down then
				return false
			end
			space_down = false
			local used = space_used
			space_used = false
			pressed_keys = {}
			if not used then
				emit_space()
			end
			return true
		end
	end

	-- Other keys while Space is held → Super layer
	if space_down then
		local name = keycode_name(code)
		if is_down then
			if name and layer_keys[name] then
				space_used = true
				pressed_keys[code] = true
				if on_action then
					on_action(name, modifiers_from(event))
				end
				return true
			end
			-- Unmapped key under Space: pass it through, but don't type a
			-- trailing space on Space release.
			space_used = true
			return false
		end

		if is_up and pressed_keys[code] then
			pressed_keys[code] = nil
			return true -- swallow matching keyUp
		end
	end

	return false
end

--- Start the Space-as-Super eventtap.
--- opts.onAction = function(key, modifiers) end
--- opts.keys     = optional set of key-name → true overrides
function M.start(opts)
	opts = opts or {}
	on_action = opts.onAction
	if opts.keys then
		layer_keys = opts.keys
	end

	if tap then
		tap:stop()
	end

	-- must stay referenced (module table) so it isn't GC'd
	tap = hs.eventtap.new({
		hs.eventtap.event.types.keyDown,
		hs.eventtap.event.types.keyUp,
	}, handle)
	tap:start()
	log.i("Space-as-Super started")
	return M
end

function M.stop()
	if tap then
		tap:stop()
		tap = nil
	end
	space_down = false
	space_used = false
	pressed_keys = {}
	return M
end

--- Whether Space is currently held as Super (for scroll-pan, etc.).
function M.isDown()
	return space_down
end

--- Mark the Super layer as used without dispatching (e.g. Space+scroll).
function M.markUsed()
	if space_down then
		space_used = true
	end
end

return M
