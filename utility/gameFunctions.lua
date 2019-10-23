local composer = require( "composer" )
local costantiOggetti = require("costanti.costantiOggetti")
local objectsFunctions = require "utility.objectsFunctions"
local levelsFunctions = require("utility.levelsFunctions")
local costantiSchermo = require("costanti.costantiSchermo")
local gameFunctions = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 0 )

-------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI-----------------------------------------
function gameFunctions.resizeChram(playerChram)
    if(playerChram.contentWidth == nil or playerChram.contentHeight == nil) then
        return end
    playerChram : scale(1.011, 1.011)
    timer.performWithDelay(1)
    physics.removeBody(playerChram)
    physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
end

function gameFunctions.endGame(score)
    --composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

function gameFunctions.updateLives(playerChram, playerState,livesText)
    if ( playerState.died == false ) then
        playerState.setDied(true)
        -- Update lives
        playerState.decrementLives()
        livesText.text = "Lives: " .. playerState.lives
        if ( playerState.lives == 0 ) then
			display.remove( playerChram )
			timer.performWithDelay( 2000, gameFunctions.endGame(playerState.score) )
        else
            playerChram.alpha = 0
            playerChram.isBodyActive = false
            objectsFunctions.restorePlayerCharm(playerChram, playerState)
            playerChram.isBodyActive = true
        end
    end
end

function gameFunctions.getLives(playerState)
    playerState.lives = playerState.lives+1
end

function gameFunctions.pauseGame()
    physics.pause()
    levelsFunctions.pauseLoop()
    objectsFunctions.pauseDrag()
    costantiSchermo.pauseLoop()
end

function gameFunctions.resumeGame()
    physics.start()
    levelsFunctions.resumeLoop()
    objectsFunctions.resumeDrag()
    costantiSchermo.resumeLoop()
end

return gameFunctions