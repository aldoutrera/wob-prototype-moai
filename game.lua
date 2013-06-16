module("Game", package.seeall)

displayed = false

function Game:display()
	PhysicsManager:initialize()
	GameMap:initialize("testMap")
	self:initialize()
	self.debugLayer:setBox2DWorld(PhysicsManager.world)
end

function Game:initialize()
    self.currentTurn = 1
    self.currentPlayer = nil
    self.selectedBot = nil
		self:initializeTeams()
    self:initializeInterface()
end

function Game:initializeTeams()
  self.teams = {}
  local team = Team:new()
  team:setName("Cowboys")
  self:addTeam(team)
  
  local player = Player:new()
  player:setName("Bill")
  team:addPlayer(player)
  
  self.currentPlayer = player
  
  local bot = Bot:new()
  bot:setName("Romo")
  bot:setLoc(0,1900,0)
  bot:setMaxHitPoints(100)
  bot:setCurrentHitPoints(100)
  bot:setMaxSpeed(10)
	bot:setModel("blueBot")
	bot:initialize(self.layer)
	bot:startAnimation("moveDown")
  player:addBot(bot)
	
  local task = Task:new()
  task:setType("mov")
  bot:addTask(task)
  task = Task:new()
  task:setType("rot")
  bot:addTask(task)
  task = Task:new()
  task:setType("mov")
  bot:addTask(task)  
  
  self.selectedBot = bot
  
  team = Team:new()
  team:setName("Redskins")
  self:addTeam(team)
  
  player = Player:new()
  player:setName("Mike")
  team:addPlayer(player)
  
  local bot = Bot:new()
  bot:setName("Griffin")
  bot:setLoc(0,-1900,0)
  bot:setMaxHitPoints(200)
  bot:setCurrentHitPoints(200)
  bot:setMaxSpeed(20)
	bot:setModel("redBot")
	bot:initialize(self.layer)
	bot:startAnimation("moveUp")
  player:addBot(bot)
end

function Game:dumpTeams()
end

function Game:addTeam(team)
  table.insert(self.teams,team)
end

function Game:initializeInterface()
  self.camera = MOAICamera2D.new()
	
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	self.layer:setCamera(self.camera)
	
	self.debugLayer = MOAILayer2D.new()
	self.debugLayer:setViewport(viewport)
	self.debugLayer:setCamera(self.camera)
	
	local renderTable = {
		self.layer,
		self.debugLayer
	}
	
	displayed = true
	MOAIRenderMgr.setRenderTable(renderTable)
	
	self:initializeTileMap()
  Hud:initialize();
  Hud:update();
	
	-- iterate through all the team's player's bots and add them to the map
	for pos, team in pairs (self.teams) do
		for pos, player in pairs (team.players) do
			for pos, bot in pairs (player.bots) do
				self.layer:insertProp(bot.prop)
			end
		end
	end
end

function Game:initializeTileMap()
	local mapProps = GameMap:getProps()
	
	for pos, mapProp in pairs (mapProps) do
		self.layer:insertProp(mapProp)
	end
end

function Game:processInput()
	if InputManager:isDragging() then
		local deltaWindowX, deltaWindowY = InputManager:deltaWindowPosition()
		local deltaWorldX = deltaWindowX * worldToViewportScale
		local deltaWorldY = deltaWindowY * worldToViewportScale
		local cameraX, cameraY = camera:getLoc()
		
		self.camera:setLoc(cameraX - deltaWorldX, cameraY - deltaWorldY)
	end
	
	if InputManager:isDown() and not InputManager:wasTouching() then
		local currentWorldX, currentWorldY = InputManager:currentWorldPosition()
		print("touched world coordinate: " .. currentWorldX .. " " .. currentWorldY)
	end
end

function sleepCoroutine(time)
	local timer = MOAITimer.new()
	timer:setSpan(time)
	timer:start()
	MOAICoroutine.blockOnAction(timer)
end