module ("Bot", package.seeall)

local botDefinitions = {
	blueBot = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "BlueBot.png",
		tileMapSize = {4, 11},
		width = 80, height = 80
	},
	redBot = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "RedBot.png",
		tileMapSize = {4, 11},
		width = 80, height = 80
	}
}

local animationDefinitions = {
	moveUp = {
		startFrame = 13,
		frameCount = 4,
		time = 0.1,
		mode = MOAITimer.LOOP
	},
	moveDown = {
		startFrame = 9,
		frameCount = 4,
		time = 0.1,
		mode = MOAITimer.LOOP
	},
	moveLeft = {
		startFrame = 1,
		frameCount = 4,
		time = 0.1,
		mode = MOAITimer.LOOP
	},
	moveRight = {
		startFrame = 5,
		frameCount = 4,
		time = 0.1,
		mode = MOAITimer.LOOP
	}
}

ResourceDefinitions:setDefinitions(botDefinitions)

function Bot:new()
  obj = {tasks={}}
  setmetatable(obj,self)
  self.__index = self
  return obj
end

function Bot:initialize()
	self.deck = ResourceManager:get(self.model)
	self.prop = MOAIProp2D.new()
	self.prop:setDeck(self.deck)
	self.prop:setLoc(self.x, self.y)
	
	self.remapper = MOAIDeckRemapper.new()
	self.remapper:reserve(1)
	self.prop:setRemapper(self.remapper)
	
	self.animations = {}
	
	for name, def in pairs (animationDefinitions) do
		self:addAnimation(name, def.startFrame, def.frameCount, def.time, def.mode)
	end
	
	self:initializePhysics()
end

function Bot:initializePhysics()
	self.physics = {}
	self.physics.body = PhysicsManager.world:addBody(MOAIBox2DBody.DYNAMIC)
	self.physics.body:setTransform(self.x, self.y)
	
	-- need to refine this shape in the future, for now it is a simple rect the same size as the bot tile
	self.physics.fixture = self.physics.body:addRect(-40, -35, 40, 45)
	
	-- link the prop to the body
	self.prop:setAttrLink(1, self.physics.body)
end

function Bot:setName(name)
  self.name = name
end

function Bot:getName()
  return self.name
end

function Bot:setMaxSpeed(maxSpeed)
  self.maxSpeed = maxSpeed
end

function Bot:getMaxSpeed()
  return self.maxSpeed
end

function Bot:setMaxHitPoints(maxHitPoints)
  self.maxHitPoints = maxHitPoints
end

function Bot:getMaxHitPoints()
  return self.maxHitPoints
end

function Bot:setCurrentHitPoints(currentHitPoints)
  self.currentHitPoints = currentHitPoints
end

function Bot:getCurrentHitPoints()
  return self.currentHitPoints
end

function Bot:setLoc(x,y,facing)
  self.x = x
  self.y = y
  self.facing = facing
end

function Bot:getLoc() 
  return self.x,self.y,self.facing
end

function Bot:addTask(task) 
  table.insert(self.tasks,task)
end

function Bot:getTasks() 
  return self.tasks
end

function Bot:setPlayer(player)
  self.player = player
end 

function Bot:getPlayer()
  return self.player
end 

function Bot:setModel(model)
  self.model = model
end

function Bot:getModel()
  return self.model
end

function Bot:addAnimation(name, startFrame, frameCount, time, mode)
	local curve = MOAIAnimCurve.new()
	curve:reserveKeys(2)
	curve:setKey(1, 0, startFrame, MOAIEaseType.LINEAR)
	curve:setKey(2, time * frameCount, startFrame + frameCount, MOAIEaseType.LINEAR)
	
	local anim = MOAIAnim:new()
	anim:reserveLinks(1)
	anim:setLink(1, curve, self.remapper, 1)
	anim:setMode(mode)
	self.animations[name] = anim
end

function Bot:getAnimation(name)
	return self.animations[name]
end

function Bot:stopCurrentAnimation()
	if self.currentAnimation then
		self.currentAnimation:stop()
	end
end

function Bot:startAnimation(name)
	self:stopCurrentAnimation()
	self.currentAnimation = self:getAnimation(name)
	self.currentAnimation:start()
	return self.currentAnimation
end
