
local composer = require( "composer" )
local scene = composer.newScene()

local playBtn -- variabile per il bottone play
local themeSong -- variabile per la musica di background
local selectionSound -- variabile per il suono della selezione
local startY = 200
local levels = {"liv1","liv2"}
themeSong = audio.loadStream("sounds/menu.mp3")
selectionSound = audio.loadSound("sounds/select.mp3")

local function goToLevel(liv)
	-- mi rimanda alla scena "livX.livX" usata come convenzione per indicare la pagina dei livelli
	composer.gotoScene( liv .. "." .. liv, { time=800, effect="crossFade" } )
	audio.play(selectionSound)
	return true	-- indica il tocco successivo
end

local function gotoMenu()
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
	audio.play(selectionSound)
	return true	-- indica il tocco successivo
end

-- viene chiamato quando la scena non esiste
function scene:create( event )
	local sceneGroup = self.view
    local buttons = {}
	-- mostra un'immagine in background
	local background = display.newImageRect( "images/background.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY
    
	-- crea immagine logo nella parte superiore della scena
	local titleLogo = display.newImageRect( "images/Game Title.png", 500, 240 )
	titleLogo.x = display.contentCenterX
    titleLogo.y = startY
    local i = 1 
    -- crea bottone Play.
	-- tutti gli oggetti del display devono essere inseriti nel gruppo
	sceneGroup:insert( background )
    sceneGroup:insert( titleLogo)

	-- creo tanti bottoni in base a quanti livellin sono disponibili
	for a,liv in pairs(levels) do
		-- mi serve una funzione senza paramentri per dopo
        local function goToLiv()
            goToLevel(liv)
		end
		--mi creo un bottone che mi rimanda al livello corrispondente
        playButton = display.newText( sceneGroup,liv, display.contentCenterX, startY+80 , native.systemFont, 44 )
        playButton:setFillColor( 0.82, 0.86, 1 )
        playButton:addEventListener("tap", goToLiv)
        table.insert(buttons,playButton)
        startY = startY +80
	end   
	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 1500, native.systemFont, 44 )
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )
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