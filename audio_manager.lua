module("AudioManager", package.seeall)

sounds = {}

local audioDefinitions = {
	menuBackgroundMusic = {
		type = RESOURCE_TYPE_SOUND,
		fileName = "MenuBackgroundMusic.caf",
		loop = true,
		volume = 1
	}
}

function AudioManager:initialize()
	ResourceDefinitions:setDefinitions(audioDefinitions)
	MOAIUntzSystem.initialize()
end

function AudioManager:get(name)
	local audio = self.sounds[name]
	
	if not audio then
		audio = ResourceManager:get(name)
		self.sounds[name] = audio
	end
	
	return audio
end

function AudioManager:play(name, loop)
	local audio = AudioManager:get(name)
	
	if loop ~= nil then
		audio:setLooping(loop)
	end
	
	audio:play()
end

function AudioManager:stop(name)
	local audio = AudioManager:get(name)
	audio:stop()
end
