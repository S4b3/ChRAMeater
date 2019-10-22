local composer = require( "composer" )
local costanti = require "costanti.costantiOggetti"
local gameFunctions = require "utility.gameFunctions"
local objectsFunctions = require "utility.objectsFunctions"
local levelsFunctions = require "utility.levelsFunctions"
local costantiSchermo = require "costanti.costantiSchermo"

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )
local objectSheet = costanti.objectSheet()
local playerState = {lives, score, died}

playerState.lives = 3
playerState.score = 0
playerState.died = false


function playerState.setScore(value)
    playerState.score = value
end

function playerState.decrementLives()
    playerState.lives = playerState.lives-1
end

function playerState.setDied(bool)
    playerState.died = bool
end

local livesText
local scoreText
local objTable = {}
local playerChram
local backGroup
local mainGroup
local uiGroup

--Passiamo riferimento al livello corrente,
--questo ci permetterà di accedere alla funzione di creazione oggetti corretta
local function gameLoop() --porkaround mi serve poter passare gameloop senza parametri
    levelsFunctions.gameLoop(mainGroup,objectSheet,objTable, 1)
end

local function resizeChram() --mi serve poter passare la funzione senza parametri
    gameFunctions.resizeChram(playerChram)
end

local function updateLives()
    gameFunctions.updateLives(playerChram, playerState,livesText)
end

local function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if(obj1.myName == "Chram") then
            if(obj2.myName == "ram2GB" ) then
                display.remove(obj2)
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram)
                playerState.setScore(playerState.score + 2)
                scoreText.text = "Score: " .. playerState.score .. "GB"
            elseif(obj2.myName=="ram8GB") then
                display.remove(obj2)
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram,4)
                playerState.setScore(playerState.score + 8)
                scoreText.text = "Score: " .. playerState.score .. "GB"
            elseif(obj2.myName=="cacheCleaner") then
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay(1, updateLives)
            end
        end
        if(obj2.myName == "Chram") then
            if(obj1.myName == "ram2GB" ) then
                display.remove(obj1)
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                playerState.setScore(playerState.score + 2)
                scoreText.text = "Score: " .. playerState.score .. "GB"
            elseif(obj1.myName=="ram8GB") then--
                display.remove(obj1)
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                playerState.setScore(playerState.score + 8)
                scoreText.text = "Score: " .. playerState.score .. "GB"
            elseif(obj1.myName=="cacheCleaner") then
                objectsFunctions.removeFromTable(obj1,objTable)
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

	local background = display.newImageRect( backGroup, "images/background7.jpg", display.actualContentWidth, display.actualContentHeight)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

    playerChram = display.newImageRect(mainGroup, objectSheet, 2, 120, 120)
	playerChram.x = display.contentCenterX
	playerChram.y = display.contentHeight - 150
	physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
	playerChram.myName = "Chram"

	livesText = display.newText( uiGroup, "Lives : " .. playerState.lives , 200, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score : " .. playerState.score .. "GB", 400, 80, native.systemFont, 36 )
    --clockText = display.newText( uiGroup, "02:00", 600, 80, native.systemFont, 36 )
    costantiSchermo.clockTextInit("03:30", 40)
    playerChram:addEventListener( "touch", objectsFunctions.dragPlayerChram )
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
		composer.removeScene( "liv1.liv1" )
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
