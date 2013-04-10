module("ResourceDefinitions", package.seeall)

local definitions = {}

function ResourceDefinitions:set(name, definition)
	definitions[name] = definition
end

function ResourceDefinitions:setDefinitions(definitions)
	for name, definition in pairs (definitions) do
		self:set(name, definition)
	end
end


function ResourceDefinitions:get(name)
	return definitions[name]
end

function ResourceDefinitions:remove(name)
	definitions[name] = nil
end
