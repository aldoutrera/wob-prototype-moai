module("GameMap", package.seeall)

function GameMap:initialize(mapName)
	self.map = ResourceManager:get(mapName)
	
	self.mapWidth = self.map.width * self.map.tilewidth
	self.mapHeight = self.map.height * self.map.tileheight
	
	self.tileSet = MOAITileDeck2D.new()
	self.tileSet:setTexture(ResourceManager.MAP_PATH .. mapName .. "/" .. self.map.tilesets[1].image)
	self.tileSet:setSize(self.map.tilesets[1].imagewidth / self.map.tilesets[1].tilewidth, self.map.tilesets[1].imageheight / self.map.tilesets[1].tileheight)
	
	self.mapGrids = {}
	self.mapProps = {}
	
	for key, mapLayer in pairs (self.map.layers) do
		self:addGrid(mapLayer)
		self:addProp(mapLayer, key)
	end
end

function GameMap:addGrid(mapLayer)
	if mapLayer.type == "tilelayer" then
		local grid = MOAIGrid.new()
		grid:setSize(self.map.width, self.map.height, self.map.tilewidth, self.map.tileheight)
		
		for i = 1, self.map.height do
			for j = 1, self.map.width do
				local tileData = mapLayer.data[(self.map.height - i) * self.map.width + j]
				grid:setTile(j, i, tileData)
			end
		end
		
		self.mapGrids[mapLayer.name] = grid
	elseif mapLayer.type == "objectgroup" then
		-- to do
	else
		print("Error: unexpected layer type.")
	end
end

function GameMap:addProp(mapLayer,key)
	if mapLayer.type == "tilelayer" then
		local prop = MOAIProp2D.new()
		prop:setDeck(self.tileSet)
		prop:setGrid(self.mapGrids[mapLayer.name])
		prop:setLoc(-(self.mapWidth / 2), -(self.mapHeight / 2))
		self.mapProps[key] = prop
	elseif mapLayer.type == "objectgroup" then
		-- to do
	else
		print("Error: unexpected layer type.")
	end
end

function GameMap:getProps()
	return mapProps
end
