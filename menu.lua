-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
local sounds = require("costanti.sounds")
local composer = require( "composer" )
local scene = composer.newScene()
local buttons = require( "costanti.buttons" )

local selectionSound = sounds.selectionSound
local themeSong = sounds.menuThemeSong

local playBtn -- variabile per il bottone play

-- viene chiamato quando la scena non esiste
function scene:create( event )
	local sceneGroup = self.view
	-- mostra un'immagine in background
	local background = display.newImageRect( "images/background7.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	-- variabile per le caratteristiche della gif di Chrome
	local sheetChramOptions =
	{
		width = 512,
		height = 512,
		numFrames = 25
	}
	-- variabile immagine Chrome statica
	local sheetChram = graphics.newImageSheet( "sprites/ChramSprite.png", sheetChramOptions )
	
	-- sequenza di immagini consecutive
	local sequences_chram = {
		{
			name = "eatingCram",
			start = 1,
			count = 25,
			time = 860,
			loopCount = 0,
			loopDirection = "forward"
		}
	}
    -- variabile immagine Chrome animata
	local chramEating = display.newSprite( sheetChram, sequences_chram )
	chramEating.x = display.contentCenterX --+ 30
	chramEating.y = display.contentHeight - 100
	chramEating:scale(4.2,4.2)
	chramEating:rotate(-90)
	chramEating:play()

	-- crea immagine logo nella parte superiore della scena
	local titleLogo = display.newImageRect( "images/Game Title.png", 500, 240 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = 200
	
	-- tutti gli oggetti del display devono essere inseriti nel gruppo
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( chramEating )
	buttons.buttonsInit(sceneGroup)
    buttons.menuButtonsInit(sceneGroup)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- chiamata quando la scena è ancora spenta e sta per essere mostrata
	elseif phase == "did" then
		-- chiamata quando la scena è già sullo schermo
		audio.play( themeSong, { channel=1, loops=-1 } )
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- chiamata quando la scena è già sullo schermo e sta per sparire

	elseif phase == "did" then
		-- chiamata quando la scena non è più sullo schermo
		audio.stop( 1 )
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	-- Called prior to the removal of scene's "view" (sceneGroup)
	--audio.dispose( themeSong )
	--audio.dispose( selectionSound )
	
	if playBtn then
		playBtn:removeSelf()	-- i widgets devono essere rimossi manualmente
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- configurazione Listener 
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene