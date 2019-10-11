
local composer = require( "composer" )
local scene = composer.newScene()

-- riservo il canale 1 per la musica di background del menù
audio.reserveChannels( 1 )
-- riduco il volume complessivo del canale
audio.setVolume( 0.5, { channel=1 } )

local playBtn -- variabile per il bottone play
local themeSong -- variabile per la musica di background
local selectionSound -- variabile per il suono della selezione

themeSong = audio.loadStream("sounds/menu.mp3")
selectionSound = audio.loadSound("sounds/select.mp3")


-- funzione per aprire la scena di Highscores
local function onHighscoresTap()
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
	audio.play(selectionSound)
	return true
end

local function onPlayTap()
	-- vai alla scena level1.lua
	composer.gotoScene( "liv1.liv1", { time=800, effect="crossFade" } )
	audio.play(selectionSound)
	return true	-- indica il tocco successivo
end

-- viene chiamato quando la scena non esiste
function scene:create( event )
	local sceneGroup = self.view

	-- mostra un'immagine in background
	local background = display.newImageRect( "images/background.jpg", display.actualContentWidth, display.actualContentHeight )
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
	chramEating.x = display.contentCenterX + 30
	chramEating.y = display.contentHeight - 900
	chramEating:scale(2,2)
	-- variabile chramEating: rotazione(-90)
	chramEating:play()

	-- crea immagine logo nella parte superiore della scena
	local titleLogo = display.newImageRect( "images/Game Title.png", 500, 240 )
	titleLogo.x = display.contentCenterX
	titleLogo.y = 200
    -- crea bottone Play
	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentHeight - 300, native.systemFont, 44 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton:addEventListener("tap", onPlayTap)
	-- crea bottone Highscores
	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, display.contentHeight - 220, native.systemFont, 44 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
    highScoresButton:addEventListener( "tap", onHighscoresTap )
	
	-- tutti gli oggetti del display devono essere inseriti nel gruppo
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
	audio.dispose( themeSong )
	audio.dispose( selectionSound )
	
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