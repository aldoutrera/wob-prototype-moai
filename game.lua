module("Game", package.seeall)

displayed = false

	-- the size of each tile is actually 128x128 if you look at the actual image,
	-- however, the image is intended to be a high enough resolution to be used
	-- with an iPad3 which has a 2048x1536 resolution, when scaled down to be used
	-- in world dimensions which is 1280x720, each tile is going to have a world size
	-- 80x80, so in world dimensions, the viewport will be 1280x720, which can show
	-- 16 tiles by 9 tiles at one time, the full map will be 40 tiles by 30 tiles
local tileSize = 80
local numberOfRows = 30
local numberOfColumns = 40

local gameDefinitions = {
	terrain = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "Terrain.png",
		tileMapSize = {2, 1}
	}
}

function Game:display()
	PhysicsManager:initialize()
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
  bot:setLoc(0,80,0)
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
  bot:setLoc(0,-80,0)
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
	
	ResourceDefinitions:setDefinitions(gameDefinitions)
	
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
	local grid = MOAIGrid.new()
	
  self.mapHeight = numberOfRows * tileSize
  self.mapWidth = numberOfColumns * tileSize
  
  grid:setSize(numberOfColumns, numberOfRows, tileSize, tileSize)
	
	-- the map definition will eventually be created by a tile map editor and saved
	-- as a lua file, or xml file, for the time being we will hard code the definition
	-- tile 1 is open terrain, tile 2 has a big boulder on it
	grid:setRow(30, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(29, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(28, 1,1,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(27, 1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(26, 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(25, 1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(24, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(23, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(22, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(21, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(20, 1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(19, 1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(18, 1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(17, 1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(16, 1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(15, 1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(14, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(13, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(12, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(11, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow(10, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 9, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 8, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 7, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 6, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 5, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 4, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 3, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 2, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	grid:setRow( 1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1)
	
	self.tiles = {}
	self.tiles.grid = grid
	self.tiles.tileset = ResourceManager:get("terrain")
	
	self.tiles.prop = MOAIProp2D.new()
	self.tiles.prop:setDeck(self.tiles.tileset)
	self.tiles.prop:setGrid(self.tiles.grid)
	self.tiles.prop:setLoc(-(self.mapWidth/2), -(self.mapHeight/2))
	self.layer:insertProp(self.tiles.prop)
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