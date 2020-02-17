local composer = require( "composer" )
local costanti = require "costanti.costantiOggetti"
local gameFunctions = require "utility.gameFunctions"
local sounds = require("costanti.sounds")
local levelsFunctions = require "utility.levelsFunctions"
local costantiSchermo = require "costanti.costantiSchermo"
local themeSong -- variabile per la musica di background
local selectionSound -- variabile per il suono della selezione
local player = require "costanti.player"

themeSong = sounds.levelThemeSong
selectionSound = sounds.selectionSound

local scene = composer.newScene()

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )
local objectSheet = costanti.objectSheet()

local clockText
local timeText -- variabile che mostra il tmepo rimanente
local objTable = {}
local backGroup
local mainGroup
local uiGroup

--Passiamo riferimento al livello corrente,
--questo ci permetterà di accedere alla funzione di creazione oggetti corretta
local function gameLoop() --porkaround mi serve poter passare gameloop senza parametri
    levelsFunctions.gameLoop(mainGroup,objectSheet,objTable, 1)
end

local function onCollision(event)
    gameFunctions.onCollision(event, objTable, uiGroup)
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

    player.playerInit(mainGroup)
    costanti.playerStateInit(3)

    costantiSchermo.allTextInit(uiGroup, "01:00", 60, costanti.playerState)
    timeText = costantiSchermo.clockText
    clockText = display.newText( uiGroup, timeText, 800, 130, native.systemFont, 50 )
    timer.performWithDelay(1, function () clockText.text = costantiSchermo.clockText end, 0)
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        costantiSchermo.backgroundInit(backGroup,1)
        gameFunctions.versus("images/versus/RAMzillaVs.png")
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        physics.start()
        Runtime:addEventListener( "collision", onCollision )
        audio.play( themeSong, { channel=1, loops=-1 } )
        gameLoopTimer = timer.performWithDelay( 400, gameLoop, 0 )
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
        costantiSchermo.backgroundRemove()
        composer.removeScene( "levels.liv1.liv1" )
        audio.stop( 1 )
    end
end

-- destroy()
function scene:destroy( event )
    local sceneGroup = self.view
    audio.rewind()
    --audio.dispose( themeSong )
	--audio.dispose( selectionSound )
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
