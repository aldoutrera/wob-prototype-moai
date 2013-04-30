module ("Task", package.seeall)

 function Task:new()
  obj = {type="---"}
  setmetatable(obj,self)
  self.__index = self
  return obj
end

function Task:setType(type)
  self.type = type
end

function Task:getType()
  return self.type
end