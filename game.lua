<<<<<<< HEAD
module("Game", package.seeall)

displayed = false

local gameDefinitions = {
	terrain = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "Terrain.png",
		tileMapSize = {2, 1}
	}
}

function Game:display()
	self:initialize()
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
  team:setName("Cowboys")
  self:addTeam(team)
  
  local player = Player:new()
  player:setName("Bill")
  team:addPlayer(player)
  
  self.currentPlayer = player
  
  local bot = Bot:new()
  bot:setName("Romo")
  bot:setLoc(100,100,0)
  bot:setMaxHitPoints(100)
  bot:setCurrentHitPoints(100)
  bot:setMaxSpeed(10)
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
  team:setName("Red Skins")
  self:addTeam(team)
  
  player = Player:new()
  player:setName("Mike")
  team:addPlayer(player)
  
  local bot = Bot:new()
  bot:setName("Griffin")
  bot:setLoc(300,300,0)
  bot:setMaxHitPoints(200)
  bot:setCurrentHitPoints(200)
  bot:setMaxSpeed(20)  
  player:addBot(bot)
end

function Game:dumpTeams()
end

function Game:addTeam(team)
  table.insert(self.teams,team)
end

function Game:initializeInterface()
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	self.layer:setCamera(self.camera)
	
	displayed = true
	MOAIRenderMgr.setRenderTable({self.layer})
	
	ResourceDefinitions:setDefinitions(gameDefinitions)
	
	self:initializeTileMap()
  Hud:initialize();
  Hud:update();
end

function Game:initializeTileMap()
	local grid = MOAIGrid.new()
	
	-- the size of each tile is actually 128x128 if you look at the actual image,
	-- however, the image is intended to be a high enough resolution to be used
	-- with an iPad3 which has a 2048x1536 resolution, when scaled down to be used
	-- in world dimensions which is 1280x720, each tile is going to have a world size
	-- 80x80, so in world dimensions, the viewport will be 1280x720, which can show
	-- 16 tiles by 9 tiles at one time, the full map will be 40 tiles by 30 tiles
	grid:setSize(40, 30, 80, 80)
	
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
	self.tiles.prop:setLoc(-1600, -1200)
	self.layer:insertProp(self.tiles.prop)
end

function Game:getSelectedBot() 
  return self.selectedBox
end
=======
module("Game", package.seeall)

displayed = false

local gameDefinitions = {
	terrain = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "Terrain.png",
		tileMapSize = {2, 1}
	}
}

function Game:display()
	self:initialize()
end

function Game:initialize()
	self.camera = MOAICamera2D.new()
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	self.layer:setCamera(self.camera)
	
	displayed = true
	MOAIRenderMgr.setRenderTable({self.layer})
	
	ResourceDefinitions:setDefinitions(gameDefinitions)
	
	self:initializeTileMap()
end

function Game:initializeTileMap()
	local grid = MOAIGrid.new()
	
	-- the size of each tile is actually 128x128 if you look at the actual image,
	-- however, the image is intended to be a high enough resolution to be used
	-- with an iPad3 which has a 2048x1536 resolution, when scaled down to be used
	-- in world dimensions which is 1280x720, each tile is going to have a world size
	-- 80x80, so in world dimensions, the viewport will be 1280x720, which can show
	-- 16 tiles by 9 tiles at one time, the full map will be 40 tiles by 30 tiles
	grid:setSize(40, 30, 80, 80)
	
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
	self.tiles.prop:setLoc(-1600, -1200)
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
>>>>>>> a25f769aa94ae3a3a19aefe5cc93f50f58410d43
