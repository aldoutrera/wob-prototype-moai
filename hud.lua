module ("Hud", package.seeall)

local TASKBOX_LEFT_PAD = 10
local TASKBOX_START_Y = 10
local TASKBOX_WIDTH = 50
local TASKBOX_HEIGHT = 25
local TASKBOX_PADDING = 5
local TASKBOX_FONT_SIZE = 15
local NUMBER_OF_TASKBOXES = 5
local TURNBOX_HEIGHT = 25
local TURNBOX_WIDTH = 75
local TURNBOX_START_Y = TASKBOX_START_Y
local TURNBOX_FONT_SIZE = 20
local BOTINFO_START_X = 0 -- CALCULATE AT RUNTIME
local BOTINFO_RIGHT_PAD = TASKBOX_LEFT_PAD
local BOTINFO_START_Y = TASKBOX_START_Y
local BOTINFO_HEIGHT = 25
local BOTINFO_WIDTH = 150
local BOTINFO_FONT_SIZE = 15
local BOTINFO_PADDING = 5
local MINIMAP_SCALE = .05
local MINIMAP_PADDING = 10

local hudDefinitions = {}

ResourceDefinitions:setDefinitions(hudDefinitions)

function Hud:initialize()
  self.hudViewport = MOAIViewport.new ()
  self.hudViewport:setSize(screenWidth, screenHeight)
  self.hudViewport:setScale(screenWidth, screenHeight)
  self.hudViewport:setOffset(-1,1)
  self.hudLayer = MOAILayer2D.new ()
  self.hudLayer:setViewport(self.hudViewport)
   
  BOTINFO_START_X = screenWidth - BOTINFO_WIDTH - BOTINFO_RIGHT_PAD
      
  self:initializeElements()
    
  local renderTable = MOAIRenderMgr.getRenderTable()
  table.insert(renderTable,self.hudLayer)
  MOAIRenderMgr.setRenderTable(renderTable)
end

function Hud:initializeElements() 
  self.font = MOAIFont.new ()
  self.font = ResourceManager:get("titleFont")
  
  self.taskBoxes = {}
  local x = TASKBOX_LEFT_PAD
  local y = TASKBOX_START_Y
  for i=1,NUMBER_OF_TASKBOXES do
    local textBox = self:newTextBox("---",15,{x,-(y + TASKBOX_HEIGHT),x + TASKBOX_WIDTH,-y})
    table.insert(self.taskBoxes,textBox)
    y = y + TASKBOX_HEIGHT + TASKBOX_PADDING
  end
  
  x = (screenWidth - TURNBOX_WIDTH)/2
  local label = "Turn " .. Game.currentTurn
  self.turnBox = self:newTextBox(label,20,{x,-(TURNBOX_START_Y + TURNBOX_HEIGHT),x + TURNBOX_WIDTH,-TURNBOX_START_Y})
  
  x = BOTINFO_START_X
  y = BOTINFO_START_Y
  self.botNameBox = self:newTextBox("name",20,{x,-(y + BOTINFO_HEIGHT),x + BOTINFO_WIDTH,-y})
  y = y + BOTINFO_HEIGHT + BOTINFO_PADDING
  self.botHitPointBox = self:newTextBox("hps",20,{x,-(y + BOTINFO_HEIGHT),x + BOTINFO_WIDTH,-y})
  y = y + BOTINFO_HEIGHT + BOTINFO_PADDING
  self.botSpeedBox = self:newTextBox("speed",20,{x,-(y + BOTINFO_HEIGHT),x + BOTINFO_WIDTH,-y}) 

  x = (screenWidth - MINIMAP_PADDING) - (GameMap.mapWidth*MINIMAP_SCALE)
  y = -(GameMap.mapHeight*.25*MINIMAP_SCALE) - (screenHeight - (4*MINIMAP_PADDING))
  
  print('map scaled width ' .. GameMap.mapWidth*MINIMAP_SCALE)
  print('map scaled height ' .. GameMap.mapHeight*MINIMAP_SCALE)
  print('world scaled width ' .. worldWidth * MINIMAP_SCALE)
  print('world scaled height ' .. worldHeight * MINIMAP_SCALE)
  
  local worldWidthScaled = worldWidth * MINIMAP_SCALE
  local worldHeightScaled = worldHeight * MINIMAP_SCALE
  
  self.miniMap = MOAIProp2D.new()
  self.miniMap:setDeck(GameMap.tileSet)
	self.miniMap:setGrid(GameMap.mapGrids["Ground"])
  self.miniMap:setScl(MINIMAP_SCALE,MINIMAP_SCALE)
	self.miniMap:setLoc(x, y)
  self.miniMap.width = GameMap.mapWidth * MINIMAP_SCALE
  self.miniMap.height = GameMap.mapHeight * MINIMAP_SCALE
	self.hudLayer:insertProp(self.miniMap)
  
  local i = x + (self.miniMap.width / 2) - (worldWidthScaled / 2)
  local j = y + (self.miniMap.height / 2) + (worldHeightScaled / 2)
  self.miniMap.viewPortWindowX = i
  self.miniMap.viewPortWindowY = j
  
  print('viewPortX,Y: ' .. i .. ',' .. j)
  
  local scriptDeck = MOAIScriptDeck.new()
  scriptDeck:setRect(0,0,GameMap.mapWidth*MINIMAP_SCALE,GameMap.mapHeight*MINIMAP_SCALE)
  scriptDeck:setDrawCallback(onDraw)
  local prop = MOAIProp2D.new()
  prop:setDeck(scriptDeck)
  self.hudLayer:insertProp(prop)
  
  x,y = Game.camera:getLoc()
  print('camera: ' .. x .. ',' .. y)
  print(self.miniMap:getLoc())
  
  MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX)
end

function onDraw(index, xoff, yoff, xflip, yflip) 

  local x,y = Hud.miniMap:getLoc() --lower lefthand corner of minimap
  
  MOAIDraw.drawBoxOutline(x,y+Hud.miniMap.height,0,x+Hud.miniMap.width,y,0)
  
  x,y = Game.camera:getLoc()
  x = x*MINIMAP_SCALE
  y = y*MINIMAP_SCALE
  
  MOAIGfxDevice.setPenColor ( 0, 0.5, 0.5, 0.5 ) 
  local xOffset = worldWidth * MINIMAP_SCALE
  local yOffset = worldHeight * MINIMAP_SCALE
  
  MOAIDraw.drawBoxOutline(x+Hud.miniMap.viewPortWindowX,y+Hud.miniMap.viewPortWindowY,0,
    x+Hud.miniMap.viewPortWindowX+xOffset,y+Hud.miniMap.viewPortWindowY-yOffset,0)    
end

function Hud:newTextBox(text, size, rectangle)
  local textBox = MOAITextBox.new ()
  textBox:setFont(self.font)
  textBox:setTextSize(size)
  textBox:setRect(unpack(rectangle))
  textBox:setString(text)
  textBox:setYFlip ( true )
  textBox:setAlignment(MOAITextBox.LEFT_JUSTIFY,MOAITextBox.RIGHT_JUSTIFY)
  self.hudLayer:insertProp(textBox)
  return textBox
end

function Hud:update()
  local bot = Game.selectedBot
  if (bot) then
    self.botNameBox:setString("name: " .. bot:getName())
    self.botHitPointBox:setString("hp: " .. bot:getCurrentHitPoints() .. "/" .. bot:getMaxHitPoints())
    self.botSpeedBox:setString("speed: " .. bot:getMaxSpeed() .. " km/h")
    
    local tasks = bot:getTasks();
        
    local numberOfTasks = #tasks
    
    for i,v in ipairs(tasks) do
      self.taskBoxes[i]:setString(v:getType())
    end
    
    for i=numberOfTasks+1,#self.taskBoxes do
      self.taskBoxes[i]:setString("")
    end
    
  else
    self.botNameBox:setString("")
    self.botHitPointBox:setString("")
    self.botSpeedBox:setString("")
    for i,v in ipairs(self.taskBoxes) do
      v:setString("")
    end
  end
end