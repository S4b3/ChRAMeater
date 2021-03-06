
local composer = require( "composer" )
local scene = composer.newScene()
local costanti = require("costanti.costantiOggetti")
local sounds = require("costanti.sounds")
local buttons = require("costanti.buttons")
local widget = require( "widget" )
local playBtn -- variabile per il bottone play
local themeSong -- variabile per la musica di background
local selectionSound -- variabile per il suono della selezione
local startY = 600 -- variabile che indica la Y iniziale per iniziare a printare i bottoni
local levels = costanti.levels -- variabile che contiene i livelli disponibili

themeSong = sounds.menuThemeSong
selectionSound = sounds.selectionSound

local function goToLevel(liv)
	-- mi rimanda alla scena "livX.livX" usata come convenzione per indicare la pagina dei livelli
	composer.gotoScene( "levels." .. liv .. "." .. liv, { time=800, effect="crossFade" } )
	audio.play(selectionSound)
	return true	-- indica il tocco successivo
end


-- viene chiamato quando la scena non esiste
function scene:create( event )
	local sceneGroup = self.view
	-- mostra un'immagine in background
	local background = display.newImageRect( "images/highscores.jpg", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
    background.y = 0 + display.screenOriginY
    
	-- crea immagine logo nella parte superiore della scena
	local titleLogo = display.newImageRect( "images/Game Title.png", 685,100 )
	titleLogo.x = display.contentCenterX
    titleLogo.y = 300
    local i = 1 
    -- crea bottone Play.
	-- tutti gli oggetti del display devono essere inseriti nel gruppo
	sceneGroup:insert( background )
    sceneGroup:insert( titleLogo)

	-- creo tanti bottoni in base a quanti livelli sono disponibili
	for a,liv in pairs(levels) do
		local sceneGroup = self.view
		-- mi serve una funzione senza paramentri per dopo
        local function goToLiv()
            goToLevel(liv)
		end

		local playButton = widget.newButton(
    {
        font = "SourceCodePro-Semibold.ttf",
        labelColor = { default={ 0, 0, 0 }},
        fontSize = 60,
        id = "Button" .. tostring(i),
        label = "Level " .. tostring(i),
        shape = "RoundedRect",
        cornerRadius =50,
        strokeWidth = 5,
        fillColor =  { default={1,0.9,0,0.6}, over ={1,0.9,0,0.6}},
        strokeColor = { default={1,0.9,0,1}, over ={1,0.9,0,1}},
        width = 320,
        height = 110,
        --onEvent = goToLiv
    }
	)
		playButton.x = display.contentCenterX
		playButton.y = startY + 150
		--mi creo un bottone che mi rimanda al livello corrispondente
        --local playButton = display.newText( sceneGroup,liv, display.contentCenterX, startY+100 , native.systemFont, 70 )
        --playButton:setFillColor( 0.82, 0.86, 1 )
        playButton:addEventListener("tap", goToLiv)
        table.insert(buttons,playButton)
		startY = startY +175
		i = i + 1
		sceneGroup:insert(playButton)
	end
	buttons.goToMenuInit(sceneGroup, 1700)
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