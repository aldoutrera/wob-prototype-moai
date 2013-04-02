-- set screen dimensions dynamically based on device
screenWidth = MOAIEnvironment.screenWidth
screenHeight = MOAIEnvironment.screenHeight

-- if host does not provide screen dimensions, use these defaults
if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end

-- various screen dimensions for quick testing purposes

-- iphone 3 and older, 1.5 aspect ratio
--screenWidth = 480
--screenHeight = 320

-- iphone 4, 1.5 aspect ratio
--screenWidth = 960
--screenHeight = 640

-- iphone 5, 1.775 aspect ratio
--screenWidth = 1136
--screenHeight = 640

-- ipad 1 and 2, 1.333 aspect ratio
--screenWidth = 1024
--screenHeight = 768

-- ipad 3, 1.333 aspect ratio
--screenWidth = 2048
--screenHeight = 1536

-- htc one x, samsung galaxy s3, 1.777 aspect ratio (16:9)
screenWidth = 1280
screenHeight = 720

-- other
--screenWidth = 640
--screenHeight = 480

-- required for non mobile platforms
MOAISim.openWindow("W.O.B. Prototype", screenWidth, screenHeight)

viewport = MOAIViewport.new()

-- for now viewport size will match the device resolution, but may have to letterbox this to ensure consistent aspect ratio
viewport:setSize(screenWidth, screenHeight)

-- viewport will show 1280 x 720 world units regardless of device resolution
viewport:setScale(1280, 720)

mainMenuLayer = MOAILayer2D.new()
mainMenuLayer:setViewport(viewport)

backgroundImage = MOAIGfxQuad2D.new()

-- MainMenuBackground.png is 2048 x 1152 with a perfect circle in the center (for detecting aspect ratio issues)
backgroundImage:setTexture("MainMenuBackground.png")

-- not sure if this is the best way to do this, stretch the image over the entire screen, probably should be using viewport dimensions instead
backgroundImage:setRect(-(screenWidth/2), -(screenHeight/2), (screenWidth/2), (screenHeight/2))

backgroundProp = MOAIProp2D.new()
backgroundProp:setDeck(backgroundImage)
backgroundProp:setLoc(0, 0)

mainMenuLayer:insertProp(backgroundProp)

renderTable = {mainMenuLayer}
MOAIRenderMgr.setRenderTable(renderTable)
