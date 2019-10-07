local composer = require( "composer" )
local costanti = require "costanti.costantiOggetti"
local funzioniBase = require "funzioni.funzioniBase"
local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local objectSheet = costanti.objectSheet()

local lives = 3
local score = 0
local died = false

local objTable = {}

local cache
local playerChram
local livesText
local scoreText

local backGroup
local mainGroup
local uiGroup

local bigRamShape = {   (512/2)*2/10,(-288/2)*2/10, (512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(-288/2)*2/10    }
local smallRamShape = { (512/2)*2/10,(-192/2)*2/10, (512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(-192/2)*2/10   }
local newShape

local function gameLoop()
    funzioniBase.gameLoop(mainGroup,objectSheet,objTable,smallRamShape,bigRamShape)
end

local function updateLives()
    died = false --porkaround
    if ( died == false ) then
        died = true
        -- Update lives
        lives = lives - 1
        livesText.text = "Lives: " .. lives
        if ( lives == 0 ) then
			display.remove( playerChram )
			timer.performWithDelay( 2000, funzioniBase.endGame(score) )
        else
            playerChram.alpha = 0
            playerChram.isBodyActive = false
            funzioniBase.restorePlayerCharm(playerChram,died)
            playerChram.isBodyActive = true
        end
    end
end

local function resizeChram()
    if(playerChram.contentWidth == nil or playerChram.contentHeight == nil) then
        return end
    playerChram : scale(1.009, 1.009)
    --transition.to(playerChram, {xScale = playerChram.contentWidth/117, yScale = playerChram.contentHeight/117})
    timer.performWithDelay(1)
    physics.removeBody(playerChram)
    physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
end


local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if(obj1.myName == "Chram") then
            if(obj2.myName == "ram2GB" ) then
                display.remove(obj2)
                funzioniBase.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram)
                -- playerChram:scale(1.1, 1.1)
                score = score+2 
                scoreText.text = "Score: " .. score .. "GB"
            elseif(obj2.myName=="ram8GB") then
                display.remove(obj2)
                funzioniBase.removeFromTable(obj2,objTable)
                -- playerChram:scale(1.3, 1.3)
                timer.performWithDelay( 1, resizeChram,4)
                score = score+8
                scoreText.text = "Score: " .. score .. "GB"
            elseif(obj2.myName=="cacheCleaner") then
                funzioniBase.removeFromTable(obj2,objTable)
                timer.performWithDelay(1, updateLives)
            end
        end
        if(obj2.myName == "Chram") then
            if(obj1.myName == "ram2GB" ) then
                display.remove(obj1)
                funzioniBase.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                -- playerChram:scale(1.1, 1.1)
                score = score+2
                scoreText.text = "Score: " .. score .. "GB"
            elseif(obj1.myName=="ram8GB") then
                display.remove(obj1)
                funzioniBase.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                score = score+8
                scoreText.text = "Score: " .. score .. "GB"
            elseif(obj1.myName=="cacheCleaner") then
                funzioniBase.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, updateLives)
            end
        end



    end
end

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------




-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.pause()

	backGroup = display.newGroup()
	sceneGroup:insert(backGroup)

	mainGroup = display.newGroup()
	sceneGroup:insert(mainGroup)

	uiGroup = display.newGroup()
	sceneGroup:insert(uiGroup)

	local background = display.newImageRect( backGroup, "images/background.jpg", display.actualContentWidth, display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	playerChram = display.newImageRect(mainGroup, objectSheet, 2, 120, 120)
	playerChram.x = display.contentCenterX
	playerChram.y = display.contentHeight - 150
	physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
	playerChram.myName = "Chram"

	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score .. "GB", 400, 80, native.systemFont, 36 )

	playerChram:addEventListener( "touch", funzioniBase.dragplayerChram )


end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        gameLoopTimer = timer.performWithDelay( 700, gameLoop, 0 )
    end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
		timer.cancel( gameLoopTimer )
		gameLoopTimer=nil
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		composer.removeScene( "game" )
    end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
