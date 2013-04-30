module("InputManager", package.seeall)

local touchedProp = nil

local currentWindowX, currentWindowY = 0, 0
local previousWindowX, previousWindowY = 0, 0

local currentWorldX, currentWorldY = 0, 0
local previousWorldX, previousWorldY = 0, 0

local wasTouching = false
local dragging = false

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
	previousWindowX, previousWindowY = currentWindowX, currentWindowY
	previousWorldX, previousWorldY = currentWorldX, currentWorldY
	
	if (MainMenu.displayed) then
		currentWindowX, currentWindowY = x, y
		currentWorldX, currentWorldY = MainMenu.mainMenuLayer:wndToWorld(x, y)
	end
	
	if (Game.displayed) then
		currentWindowX, currentWindowY = x, y
		currentWorldX, currentWorldY = Game.layer:wndToWorld(x, y)
		Game:processInput()
	end
	
	if (previousWindowX ~= currentWindowX or previousWindowY ~= currentWindowY) and wasTouching then
		dragging = true
	else
		dragging = false
	end
	
	wasTouching = InputManager:isDown()
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
	if (MainMenu.displayed) then
		if (down) then
			touchedProp = MainMenu.mainMenuLayer:getPartition():propForPoint(currentWorldX, currentWorldY)
		else
			if (touchedProp and touchedProp.callback) then
				touchedProp:callback()
				touchedProp = nil
			end
		end
	end
end

function InputManager:currentWindowPosition()
	return currentWindowX, currentWindowY
end

function InputManager:currentWorldPosition()
	return currentWorldX, currentWorldY
end

function InputManager:previousWindowPosition()
	return previousWindowX, previousWindowY
end

function InputManager:previousWorldPosition()
	return previousWorldX, previousWorldY
end

function InputManager:deltaWindowPosition()
	return currentWindowX - previousWindowX, previousWindowY - currentWindowY
end

function InputManager:deltaWorldPosition()
	return currentWorldX - previousWorldX, previousWorldY - currentWorldY
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
		return currentWindowX, currentWindowY, 1
	end
end

function InputManager:isDragging()
	if InputManager:isDown() and InputManager:wasTouching() and dragging then
		return true
	else
		return false
	end
end

function InputManager:wasTouching()
	return wasTouching
end
