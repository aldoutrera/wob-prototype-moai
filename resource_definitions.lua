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

titleFontDef = {
	type = RESOURCE_TYPE_FONT,
	fileName = "arialbd.ttf",
	glyphs = chars,
	fontSize = 48,
	dpi = 160
}

menuFontDef = {
	type = RESOURCE_TYPE_FONT,
	fileName = "arialbd.ttf",
	glyphs = chars,
	fontSize = 24,
	dpi = 160
}

ResourceDefinitions:set("titleFont", titleFontDef)
ResourceDefinitions:set("menuFont", menuFontDef)

testMapDef = {
	type = RESOURCE_TYPE_MAP,
	mapName = "TestMap",
	fileName = "TestMap.lua"
}

ResourceDefinitions:set("testMap", testMapDef)