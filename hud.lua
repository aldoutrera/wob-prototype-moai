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
  
  MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX)
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