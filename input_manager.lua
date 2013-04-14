module("InputManager", package.seeall)

local touchedProp = nil
local currentX, currentY = 0, 0
local previousX, previousY = 0, 0

function InputManager:initialize()
	if (MOAIInputMgr.device.pointer) then
		-- app is running on the simulator or other mouse based device
		MOAIInputMgr.device.mouseLeft:setCallback(handleClick)
	else
		-- app is running on mobile device
		MOAIInputMgr.device.touch:setCallback(handleTouch)
	end
end

function updatePosition(x, y)
	previousX, previousY = currentX, currentY
	
	if (MainMenu.mainMenuLayer) then
		currentX, currentY = MainMenu.mainMenuLayer:wndToWorld(x, y)
	end
end

function handleClick(down)
	updatePosition(MOAIInputMgr.device.pointer:getLoc())
	handleClickOrTouch(down)
end

function handleTouch(eventType, idx, x, y, tapCount)
	updatePosition(x, y)
	
	if (eventType == MOAITouchSensor.TOUCH_DOWN) then
		handleClickOrTouch(true)
	elseif (eventType == MOAITouchSensor.TOUCH_UP) then
		handleClickOrTouch(false)
	end
end

function handleClickOrTouch(down)
	if (down) then
		if (MainMenu.mainMenuLayer) then
			touchedProp = MainMenu.mainMenuLayer:getPartition():propForPoint(currentX, currentY)
		end
	else
		if (touchedProp and touchedProp.callback) then
			touchedProp:callback()
			touchedProp = nil
		end
	end
end

function InputManager:currentPosition()
	return currentX, currentY
end

function InputManager:previousPosition()
	return previousX, previousY
end

function InputManager:deltaPosition()
	return currentX - previousX, currentY - previousY
end

function InputManager:down()
	if (MOAIInputMgr.device.touch) then
		return MOAIInputMgr.device.touch:down()
	elseif (MOAIInputMgr.device.pointer) then
		return MOAIInputMgr.device.mouseLeft:down()
	end
end

function InputManager:isDown()
	if (MOAIInputMgr.device.touch) then
		return MOAIInputMgr.device.touch:isDown()
	elseif (MOAIInputMgr.device.pointer) then
		return MOAIInputMgr.device.mouseLeft:isDown()
	end
end

function InputManager:getTouch()
	if (MOAIInputMgr.device.touch) then
		return MOAIInputMgr.device.touch:getTouch()
	elseif (MOAIInputMgr.device.pointer) then
		return currentX, currentY, 1
	end
end
