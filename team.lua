module ("Team", package.seeall)

function Team:new()
  obj = {players={}}
  setmetatable(obj,self)
  self.__index = self
  return obj
end

function Team:setName(name)
  self.name = name
end

function Team:getName()
  return self.name
end

function Team:addPlayer(player) 
  table.insert(self.players,player)
  player.setTeam(self)
end

function Team:getPlayers()
  return self.players
end