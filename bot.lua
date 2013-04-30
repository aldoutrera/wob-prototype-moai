module ("Bot", package.seeall)

function Bot:new()
  obj = {tasks={}}
  setmetatable(obj,self)
  self.__index = self
  return obj
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
