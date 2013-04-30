module ("Player", package.seeall)

function Player:new()
  obj = {bots={}}
  setmetatable(obj,self)
  self.__index = self
  return obj
end

function Player:setName(name)
  self.name = name
end

function Player:getName()
  return self.new
end

function Player:addBot(bot)
  table.insert(self.bots,bot)
  bot.setPlayer(self)
end

function Player:getBots()
  return self.bots
end

function Player:setTeam(team)
  self.team = team
end

function Player:getTeam()
  return self.team 
end