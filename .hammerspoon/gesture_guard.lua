-- gesture_guard.lua — suppress scroll only during real 3-finger swipes
--
-- Swallowing the first moments of every 2-finger touch (to wait for a possible
-- 3rd finger) makes normal scrolling feel broken. We only block when 3+
-- fingers are actually down, plus a short cooldown for inertial scroll after.

local M = {}

local touch_count = 0
local block_until = 0 -- hs.timer.secondsSinceEpoch() deadline
local gesture_tap = nil

local RELEASE_HOLD_S = 0.25

function M.start()
	if gesture_tap then
		gesture_tap:stop()
	end

	gesture_tap = hs.eventtap.new({ hs.eventtap.event.types.gesture }, function(event)
		local touches = event:getTouches()
		local n = touches and #touches or 0
		touch_count = n

		if n >= 3 then
			-- 3-finger swipe in progress: block scroll for the whole gesture
			-- and a bit after lift (inertia).
			block_until = hs.timer.secondsSinceEpoch() + RELEASE_HOLD_S
		end

		return false -- never consume; Swipe.spoon still sees gestures
	end)
	gesture_tap:start()
	return M
end

function M.stop()
	if gesture_tap then
		gesture_tap:stop()
		gesture_tap = nil
	end
	touch_count = 0
	block_until = 0
	return M
end

function M.shouldBlockScroll()
	if touch_count >= 3 then
		return true
	end
	return hs.timer.secondsSinceEpoch() < block_until
end

function M.touchCount()
	return touch_count
end

return M
