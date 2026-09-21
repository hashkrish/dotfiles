-- Hammerspoon entry point
--
-- Architecture:
--   1. space_super  — Space tap/hold → Super layer (no Hyper chord)
--   2. actions      — Super + key + Ctrl/Alt/Shift → dispatch
--   3. hcolumns2d   — window tiling
--   4. gestures     — 3-finger swipe focus; Space+scroll pan
--
-- Mental model (matches Hyprland Super):
--   Space           → space
--   Space + H/J/K/L → focus
--   Space + Shift + H/J/K/L → move window
--   Space + Ctrl  + H/L     → resize column
--   Space + Ctrl  + J/K     → resize row
--   Space + Alt   + H/J/K/L → move window to adjacent display
--   Space + 1..9            → switch Space
--   Space + Shift + 1..9    → move window to Space
--   Space + F / Q / R / T / Shift+N → fullscreen / close / retile / float / new column
--   Space + Ctrl + Q        → reload Hammerspoon
--
-- Gestures: System Settings → Trackpad → More Gestures
--   - "Swipe between pages" → Off
--   - Mission Control / full-screen swipe → not 3 fingers

local grid = require("hcolumns2d")
local actions = require("actions")
local space_super = require("space_super")
local gesture_guard = require("gesture_guard")

grid.animation_duration = 0.2
actions.init(grid)

space_super.start({
	onAction = function(key, modifiers)
		actions.superAction(key, modifiers)
	end,
})

gesture_guard.start()

---------------------------------------------------------------------------
-- 3-finger swipe → focus (Swipe.spoon)
---------------------------------------------------------------------------

Swipe = hs.loadSpoon("Swipe")

local swipe_id, swipe_threshold
Swipe:start(3, function(direction, distance, id)
	if id ~= swipe_id then
		swipe_id = id
		swipe_threshold = 0.25 -- slightly firmer so prelude jitter is ignored
		return
	end
	if distance <= swipe_threshold then
		return
	end
	swipe_threshold = math.huge

	if direction == "left" then
		grid.focus("right")
	elseif direction == "right" then
		grid.focus("left")
	elseif direction == "up" then
		grid.focus("down")
	elseif direction == "down" then
		grid.focus("up")
	end
end)

---------------------------------------------------------------------------
-- Scroll: block during 3-finger swipes; Space+scroll pans columns
---------------------------------------------------------------------------

local SCROLL_GAIN = 2.0

-- must be global so the eventtap isn't garbage-collected
scroll_pan_tap = hs.eventtap.new({ hs.eventtap.event.types.scrollWheel }, function(event)
	-- 2-finger prelude / 3-finger swipe / post-swipe inertia
	if gesture_guard.shouldBlockScroll() then
		return true
	end

	if not space_super.isDown() then
		return false
	end

	local dx = event:getProperty(hs.eventtap.event.properties.scrollWheelEventPointDeltaAxis2) or 0
	local dy = event:getProperty(hs.eventtap.event.properties.scrollWheelEventPointDeltaAxis1) or 0
	if dx == 0 and dy == 0 then
		dx = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis2) or 0
		dy = event:getProperty(hs.eventtap.event.properties.scrollWheelEventDeltaAxis1) or 0
		dx, dy = dx * 10, dy * 10
	end

	if dx == 0 and dy == 0 then
		return false
	end

	space_super.markUsed()
	grid.pan(-dx * SCROLL_GAIN, -dy * SCROLL_GAIN)
	return true
end)
scroll_pan_tap:start()

grid.start()
hs.alert.show("Space-as-Super + hcolumns2d", 0.8)
