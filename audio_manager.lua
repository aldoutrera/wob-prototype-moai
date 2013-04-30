module("AudioManager", package.seeall)

local ENABLE_AUDIO = false

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
  if (ENABLE_AUDIO) then
    ResourceDefinitions:setDefinitions(audioDefinitions)
    MOAIUntzSystem:initialize()
  end
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
  if (ENABLE_AUDIO) then
    local audio = AudioManager:get(name)
    
    if loop ~= nil then
      audio:setLooping(loop)
    end
    
    audio:play()
  end
end

function AudioManager:stop(name)
  if (ENABLE_AUDIO) then
    local audio = AudioManager:get(name)
    audio:stop()
  end
end
