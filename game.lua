
local composer = require( "composer" )

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local sheetOptions = {

    frames =
    {
        { -- cache cleaner
            x = 0, 
            y = 0,
            width = 512,
            height = 512
        },
        {-- chrome
            x = 0,
            y = 512,
            width = 512,
            height = 512
        },
        {--ram big!
            x = 0,
            y = 1024,
            width = 512,
            height = 512
        },
        {--ram comune
            x = 0,
            y = 1536,
            width = 512,
            height = 512
        },
    },

}

local objectSheet = graphics.newImageSheet("GameObjects.png", sheetOptions)

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

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

local function createObjects()
    
    local selector = math.random ( 20 )
    local objIndicator
    local objName

    if(selector <= 15) then
        objIndicator = 4
        objName="ram2GB"
    elseif (selector >= 16 and selector <= 17) then
        objIndicator = 3
        objName="ram8GB"
    elseif (selector >= 18) then
        objIndicator = 1
        objName="cacheCleaner"
    end
    if(mainGroup==nil or objectSheet==nil) then
        return end
	local newObject = display.newImageRect( mainGroup, objectSheet, objIndicator, 102, 102 )
    table.insert( objTable, newObject )
    physics.addBody( newObject, "dynamic", { radius=40, bounce=0.8 } )
    newObject.myName = objName

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- From the left
        newObject.x = -60
        newObject.y = math.random( 500 )
        newObject:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newObject.x = display.contentWidth + 60
        newObject.y = math.random( 500 )
        newObject:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

    newObject:applyTorque( math.random( -6,6 ) )
end

local function dragplayerChram( event )
    local playerChram = event.target
    local phase = event.phase
    if ( "began" == phase ) then
        -- Set touch focus on playerChram
        display.currentStage:setFocus( playerChram )
        playerChram.touchOffsetX = event.x - playerChram.x
        playerChram.touchOffsetY = event.y - playerChram.y
    elseif ( "moved" == phase ) then
        -- Move playerChram to the new touch position
        playerChram.x = event.x - playerChram.touchOffsetX
        playerChram.y = event.y - playerChram.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on playerChram
        display.currentStage:setFocus( nil )
    end
    return true 
end

local function gameLoop()
    createObjects()
 
    -- Remove rams which have drifted off screen
    for i = #objTable, 1, -1 do
        local thisRam = objTable[i]
 
        if ( thisRam.x < -100 or
             thisRam.x > display.contentWidth + 100 or
             thisRam.y < -100 or
             thisRam.y > display.contentHeight + 100 )
        then
            display.remove( thisRam )
            table.remove( objTable, i )
        end
 
    end
 
end

local function restoreChram()
 
    playerChram.isBodyActive = false
    playerChram.x = display.contentCenterX
    playerChram.y = display.contentHeight - 100
 
    -- Fade in the playerChram
    transition.to( playerChram, { alpha=1, time=4000,
        onComplete = function()
            playerChram.isBodyActive = true
            died = false
        end
    } )
end

local function removeFromTable(obj)
    for i = #objTable, 1, -1 do
        if ( objTable[i] == obj ) then
            table.remove( objTable, i )
            break
        end
    end
end

local function restorePlayerCharm()
 
    playerChram.isBodyActive = false
    playerChram.x = display.contentCenterX
    playerChram.y = display.contentHeight - 100
 
    -- Fade in the playerChram
    transition.to( playerChram, { alpha=1, time=4000,
        onComplete = function()
            playerChram.isBodyActive = true
            died = false
        end
    } )
end

local function endGame()
    --composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

local function updateLives()
    if ( died == false ) then
        died = true
        -- Update lives
        lives = lives - 1
        livesText.text = "Lives: " .. lives
        if ( lives == 0 ) then
			display.remove( playerChram )
			timer.performWithDelay( 2000, endGame )
        else
            playerChram.alpha = 0
            timer.performWithDelay( 1000, restorePlayerCharm )
        end
    end
end

local function resizeChram()
    if(playerChram.contentWidth == nil or playerChram.contentHeight == nil) then
        return end
    transition.to(playerChram, {xScale = playerChram.contentWidth/117, yScale = playerChram.contentHeight/117})
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
                removeFromTable(obj2)
                timer.performWithDelay( 1, resizeChram)
                -- playerChram:scale(1.1, 1.1)
                score = score+2 
                scoreText.text = "Score: " .. score
            elseif(obj2.myName=="ram8GB") then
                display.remove(obj2)
                removeFromTable(obj2)
                -- playerChram:scale(1.3, 1.3)
                timer.performWithDelay( 1, resizeChram)
                score = score+8
                scoreText.text = "Score: " .. score
            elseif(obj2.myName=="cacheCleaner") then
                removeFromTable(obj2)
                updateLives()
            end
        end
        if(obj2.myName == "Chram") then
            if(obj1.myName == "ram2GB" ) then
                display.remove(obj1)
                removeFromTable(obj1)
                timer.performWithDelay( 1, resizeChram)
                -- playerChram:scale(1.1, 1.1)
                score = score+2
                scoreText.text = "Score: " .. score
            elseif(obj1.myName=="ram8GB") then
                display.remove(obj1)
                removeFromTable(obj1)
                timer.performWithDelay( 1, resizeChram)
                score = score+8
                scoreText.text = "Score: " .. score
            elseif(obj1.myName=="cacheCleaner") then
                removeFromTable(obj1)
                updateLives()
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

	local background = display.newImageRect( backGroup, "background.jpg", display.actualContentWidth, display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	playerChram = display.newImageRect(mainGroup, objectSheet, 2, 120, 120)
	playerChram.x = display.contentCenterX
	playerChram.y = display.contentHeight - 150
	physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
	playerChram.myName = "Chram"

	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score .. "GB", 400, 80, native.systemFont, 36 )

	playerChram:addEventListener( "touch", dragplayerChram )


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
        gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
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
