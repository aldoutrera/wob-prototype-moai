module("MainMenu", package.seeall)

function MainMenu:display()
	mainMenuLayer = MOAILayer2D.new()
	mainMenuLayer:setViewport(viewport)
	
	menuBackgroundImageDef = {
		type = RESOURCE_TYPE_IMAGE,
		fileName = "MainMenuBackground.png",
		width = worldWidth,
		height = worldHeight
	}
	
	ResourceDefinitions:set("menuBackgroundImage", menuBackgroundImageDef)
	menuBackgroundImage = ResourceManager:get("menuBackgroundImage")
	
	backgroundProp = MOAIProp2D.new()
	backgroundProp:setDeck(menuBackgroundImage)
	backgroundProp:setLoc(0, 0)
	
	mainMenuLayer:insertProp(backgroundProp)
	
	titleTextBox = MOAITextBox.new()
	titleTextBox:setFont(ResourceManager:get("titleFont"))
	titleTextBox:setRect(-640, 0, 640, 360)
	titleTextBox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	titleTextBox:setYFlip(true)
	titleTextBox:setString("W.O.B. Prototype")
	
	mainMenuLayer:insertProp(titleTextBox)
	
	self:createMenuItem("Account", {-640, 50, 640, 120}, accountTouched)
	self:createMenuItem("Create Game", {-640, -20, 640, 50}, createGameTouched)
	self:createMenuItem("Continue Game", {-640, -90, 640, -20}, continueGameTouched)
	self:createMenuItem("Garage", {-640, -160, 640, -90}, garageTouched)
	self:createMenuItem("Store", {-640, -230, 640, -160}, storeTouched)
	
	renderTable = {mainMenuLayer}
	MOAIRenderMgr.setRenderTable(renderTable)
	
	AudioManager:play("menuBackgroundMusic")
end

function MainMenu:accountTouched()
	print("Account Touched")
end

function MainMenu:createGameTouched()
	print("Create Game Touched")
end

function MainMenu:continueGameTouched()
	print("Continue Game Touched")
end

function MainMenu:garageTouched()
	print("Garage Touched")
end

function MainMenu:storeTouched()
	print("Store Touched")
end

function MainMenu:createMenuItem(name, rect, callback)
	local menuItemTextBox = MOAITextBox.new()
	menuItemTextBox:setFont(ResourceManager:get("menuFont"))
	menuItemTextBox:setRect(unpack(rect))
	menuItemTextBox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	menuItemTextBox:setYFlip(true)
	menuItemTextBox:setString(name)
	menuItemTextBox.callback = callback
	mainMenuLayer:insertProp(menuItemTextBox)
end
