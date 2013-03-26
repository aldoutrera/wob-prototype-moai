screenWidth = MOAIEnvironment.screenWidth
screenHeight = MOAIEnvironment.screenHeight

-- if host does not provide screen dimensions, default to iphone retina display
if screenWidth == nil then screenWidth = 960 end
if screenHeight == nil then screenHeight = 640 end

-- required for non mobile platforms
MOAISim.openWindow("W.O.B. Prototype", screenWidth, screenHeight)

viewport = MOAIViewport.new()
-- viewport size will match the device resolution
viewport:setSize(screenWidth, screenHeight)
-- viewport will show 960 x 640 world units regardless of device resolution
viewport:setScale(960, 640)

mainMenuLayer = MOAILayer2D.new()
mainMenuLayer:setViewport(viewport)
MOAISim.pushRenderPass(mainMenuLayer)

backgroundQuad = MOAIGfxQuad2D.new()
backgroundQuad:setTexture("EmptyBackground.png")
backgroundQuad:setRect(-160, -240, 160, 240)

backgroundProp = MOAIProp2D.new()
backgroundProp:setDeck(backgroundQuad)

mainMenuLayer:insertProp(backgroundProp)
