local widget = require "widget"
local gameFunctions = require ("utility.gameFunctions")
local sounds = require ("costanti.sounds")
local costantiSchermo = require("costanti.costantiSchermo")
local composer = require "composer"


--dichiaro i vari bottoni implementati nella table.
local buttons = {}
buttons.musicButton = {}
buttons.musicButton.show = {}
buttons.effectsButton = {}
buttons.effectsButton.show = {}
buttons.homeButton = {}
buttons.homeButton.show = {}
buttons.buttonsMenu = {}
buttons.buttonsMenu.show = {}
buttons.buttonsMenu.closeMenuButton = {}
buttons.buttonsMenu.closeMenuButton.show = {}

--Variabile necessaria all'over semitrasparente sullo schermo nel momento in cui premo pausa.
local blackScreen = display.newRect(display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight)
blackScreen:setFillColor("black", 0.5)
blackScreen.isVisible = false

--Funzione di tap sul bottone "musicale":
--rimuove o riaggiunge il volume al canale audio responsabile della musica
function buttons.onMusicTapEffect(button)
    if(not button.pressed) then
        audio.setVolume(0, { channel = 1 } )
    else
        audio.setVolume(0.5, { channel = 1 })
    end
end

--Funzione di tap sul bottone per gli "effetti"
--rimuove o riaggiunge il volume al canale audio responsabile degli effetti
function buttons.onEffectsTapEffect(button)
    if(not button.pressed) then
        audio.setVolume(0, { channel = 2 } )
    else
        audio.setVolume(0.5, { channel = 2 })
    end
end

--Funzione di tap sul bottone "Home"
--TODO: Necessario implementare una funzione di 'abbandono' della partita in corso, vedi composer.scene
--che fermi il timer e non faccia salvare l'highscore della partita corrente.
--Potremmo invece implementare direttamente il bottone di abbandono della partita che la interrompa salvandone lo score?
function buttons.onHomeTapEffect(button)
    local currentScene = composer.getSceneName("current")
    if (currentScene == "menu" or currentScene == "highscores" or currentScene == "selectionLevelPage" or currentScene == "liv2.liv2" or currentScene == "liv4.liv4") then
        composer.gotoScene("menu")
        return
    end
    costantiSchermo.finalizeLoop()
    composer.gotoScene("menu")
end

--Funzione di tap sul bottone "closeMenuButton"
--Se il bottone ha pressed = true, allora parte una transizione di movimento della componente del menubottoni
--verso sinistra con l'apparizione di una rect con alpha 0.5 e pause della partita*.
--In caso contrario la transizione è verso destra, con rimozione del rect e resume della partita*.
--*Se si è in partita
function buttons.onCloseMenuTapEffect(button)
    if(buttons.effectsButton.show.x == nil) then
        buttons.effectsButton.show.x = display.contentWidth - 40
    end
    if(buttons.musicButton.show.x == nil) then
        buttons.musicButton.show.x = display.contentWidth - 40
    end
    if(button.pressed) then
        transition.to(buttons.buttonsMenu.show, {time = 200, x = buttons.buttonsMenu.show.x - 200})
        transition.to(buttons.musicButton.show, {time = 200, x = buttons.musicButton.show.x - 200})
        transition.to(buttons.effectsButton.show, {time = 200, x = buttons.effectsButton.show.x - 200})
        transition.to(buttons.homeButton.show, {time = 200, x = buttons.homeButton.show.x - 200})
        transition.to(button, {rotation=180, time = 200, x = button.x - 153})
        buttons.buttonsMenu.closeMenuButton.pressed = true
        blackScreen.isVisible = true
        gameFunctions.pauseGame()
    else
        transition.to(buttons.buttonsMenu.show, {time = 200, x = buttons.buttonsMenu.show.x + 200})
        transition.to(buttons.musicButton.show, {time = 200, x = buttons.musicButton.show.x + 200})
        transition.to(buttons.effectsButton.show, {time = 200, x = buttons.effectsButton.show.x + 200})
        transition.to(buttons.homeButton.show, {time = 200, x = buttons.homeButton.show.x + 200})
        transition.to(button, {rotation=0, time = 200, x = button.x + 153})
        buttons.buttonsMenu.closeMenuButton.pressed = false
        blackScreen.isVisible = false
        
        gameFunctions.resumeGame()
        end
end

function buttons.buttonSwitcheroo(button, target)
    --creazione del clone dell'immagine che andrà a sostituire la precedente
    button.x = target.x
    button.y = target.y
    button.imageIfTapped = target.imageIfTapped
    button.imageIfNotTapped = target.imageIfNotTapped
    button.onTapEffect = target.onTapEffect
    button.name = target.name
    button:addEventListener("tap", buttons.onSwappableTap)
    --cancellazione dell'immagine precedente
    target:removeSelf()
end

function buttons.onNonSwappableTap(event)
    event.target.pressed = not event.target.pressed
    event.target.onTapEffect(event.target)
end

function buttons.onSwappableTap(event)

    if(event.target.name == "musicButton") then
        if(buttons.musicButton.show.pressed) then
            --creazione dell'icona audio se non toccata

            buttons.musicButton.show = display.newImageRect(buttons.musicButton.show.imageIfNotTapped, 100, 100)
            buttons.musicButton.show.pressed = false
        else
            --creazione dell'icona audio sbarrata se toccata
            buttons.musicButton.show = display.newImageRect(buttons.musicButton.show.imageIfTapped, 100, 100)
            buttons.musicButton.show.pressed = true
        end
        buttons.buttonSwitcheroo(buttons.musicButton.show, event.target)
    elseif(event.target.name == "effectsButton") then
        if(buttons.effectsButton.show.pressed) then
            --creazione dell'icona effetti se non toccata
            buttons.effectsButton.show = display.newImageRect(buttons.effectsButton.show.imageIfNotTapped, 100, 100)
            buttons.effectsButton.show.pressed = false
        else
            --creazione dell'icona effetti sbarrata se toccata
            buttons.effectsButton.show = display.newImageRect(buttons.effectsButton.show.imageIfTapped, 100, 100)
            buttons.effectsButton.show.pressed = true
        end
        buttons.buttonSwitcheroo(buttons.effectsButton.show, event.target)
    end
    event.target.onTapEffect(event.target)
end

function buttons.buttonsInit(sceneGroup)
    buttons.buttonsMenu.show = display.newImageRect("images/buttons/buttonsMenu.png", 300, 400)
    buttons.buttonsMenu.show.x = display.contentWidth + 140
    buttons.buttonsMenu.show.y = display.contentCenterY-600

    buttons.buttonsMenu.closeMenuButton.show = display.newImageRect("images/buttons/closeMenuButton.png", 50, 125)
    buttons.buttonsMenu.closeMenuButton.show.x = buttons.buttonsMenu.show.x-160
    buttons.buttonsMenu.closeMenuButton.show.y = buttons.buttonsMenu.show.y --+ 120
    buttons.buttonsMenu.closeMenuButton.show.pressed = false

    buttons.buttonsMenu.closeMenuButton.show:addEventListener("tap", buttons.onNonSwappableTap)
    buttons.buttonsMenu.closeMenuButton.show.onTapEffect = buttons.onCloseMenuTapEffect
    buttons.buttonsMenu.closeMenuButton.show.name = "closeMenuButton"


    --buttons.buttonsMenu.closeMenuButton.show:rotate(180)
    --timer.performWithDelay(10000, transition.to( buttons.buttonsMenu.closeMenuButton.show, { rotation=180, time=200, transition=easing.inOutCubic } ) )

    buttons.musicButton.show = display.newImageRect("images/buttons/musicIcon.png", 100, 100)
    buttons.musicButton.show.x = display.contentWidth + 140
    buttons.musicButton.show.y = display.contentCenterY -700
    buttons.musicButton.show.imageIfTapped = "images/buttons/musicIconDisabled.png"
    buttons.musicButton.show.imageIfNotTapped = "images/buttons/musicIcon.png"
    buttons.musicButton.show.pressed = false
    buttons.musicButton.show:addEventListener("tap", buttons.onSwappableTap)
    buttons.musicButton.show.onTapEffect = buttons.onMusicTapEffect
    buttons.musicButton.show.name = "musicButton"

    buttons.effectsButton.show = display.newImageRect("images/buttons/audioIcon.png", 100, 100)
    buttons.effectsButton.show.x = display.contentWidth + 140
    buttons.effectsButton.show.y = display.contentCenterY -600
    buttons.effectsButton.show.imageIfTapped = "images/buttons/audioIconDisabled.png"
    buttons.effectsButton.show.imageIfNotTapped = "images/buttons/audioIcon.png"
    buttons.effectsButton.show.pressed = false
    buttons.effectsButton.show:addEventListener("tap", buttons.onSwappableTap)
    buttons.effectsButton.show.onTapEffect = buttons.onEffectsTapEffect
    buttons.effectsButton.show.name = "effectsButton"

    buttons.homeButton.show = display.newImageRect("images/buttons/homeButton.png", 100, 100)
    buttons.homeButton.show.x = display.contentWidth + 140
    buttons.homeButton.show.y = display.contentCenterY -500
    buttons.homeButton.show.pressed = false
    buttons.homeButton.show:addEventListener("tap", buttons.onNonSwappableTap)
    buttons.homeButton.show.onTapEffect = buttons.onHomeTapEffect
    buttons.homeButton.show.name = "homeButton"

end


--
-- FUNZIONI PER I BOTTONI DEL MENU
--

-- funzione per aprire la scena di Highscores
local function onHighscoresTap()
	composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
	audio.play(sounds.selectionSound)
	return true
end

local function onPlayTap()
	-- vai alla scena level1.lua
	composer.gotoScene( "selectionLevelPage", { time=800, effect="crossFade" } )
	audio.play(sounds.selectionSound)
	return true	-- indica il tocco successivo
end

--buttons.musicButton:addEventListener("tap", buttons.onTap )
function buttons.menuButtonsInit(sceneGroup)
    -- crea bottone Play
	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, display.contentHeight - 1400, native.systemFont, 70 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	playButton:addEventListener("tap", onPlayTap)
	-- crea bottone Highscores
	local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, display.contentHeight - 1300, native.systemFont, 70 )
	highScoresButton:setFillColor( 0.75, 0.78, 1 )
    highScoresButton:addEventListener( "tap", onHighscoresTap )

    sceneGroup:insert(playButton)
    sceneGroup:insert(highScoresButton)
end

--
--FUNZIONI PER IL MENU BUTTON
--
local function gotoMenu()
    composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    audio.play(sounds.selectionSound)
end

function buttons.goToMenuInit(sceneGroup, yValue)
    local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, yValue, native.systemFont, 70 )
    menuButton:setFillColor( 0.75, 0.78, 1 )
    menuButton:addEventListener( "tap", gotoMenu )
end
return buttons