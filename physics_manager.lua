module("PhysicsManager", package.seeall)

function PhysicsManager:initialize()
	self.world = MOAIBox2DWorld.new()
	
	-- as of this writing each bot tile is 80x80 in world scale, lets say for the
	-- time being that each bot will be 3 meters (approximately 9 ft 10 in)
	self.world:setUnitsToMeters(3/80)
	
	-- no gravity in the x or y dimension
	self.world:setGravity(0, 0)
	
	self.world:start()
end
