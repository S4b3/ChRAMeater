-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local playBtn
local highScoresBtn

local function onHighscoresTap()
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
	return true
end

local function onPlayTap()
	-- go to level1.lua scene
	composer.gotoScene( "game", { time=800, effect="crossFade" } )
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY

	local sheetChramOptions =
	{
		width = 512,
		height = 512,
		numFrames = 25
	}

	local sheetChram = graphics.newImageSheet( "ChramSprite.png", sheetChramOptions )

	local sequences_chram = {
		-- consecutive frames sequence
		{
			name = "eatingCram",
			start = 1,
			count = 25,
			time = 860,
			loopCount = 0,
			loopDirection = "forward"
		}
	}

	local chramEating = display.newSprite( sheetChram, sequences_chram )
	chramEating.x = display.contentCenterX + 20
	chramEating.y = display.contentHeight - 700
	chramEating:play()
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "Game Title.png", 500, 240 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = 200

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentHeight - 300, native.systemFont, 44 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton:addEventListener("tap", onPlayTap)

	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, display.contentHeight - 220, native.systemFont, 44 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
    highScoresButton:addEventListener( "tap", onHighscoresTap )
	

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playButton )
	sceneGroup:insert( highScoresButton )
	sceneGroup:insert( chramEating )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene