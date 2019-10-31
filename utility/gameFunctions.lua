local composer = require( "composer" )
local costantiOggetti = require("costanti.costantiOggetti")
local objectsFunctions = require "utility.objectsFunctions"
local levelsFunctions = require("utility.levelsFunctions")
local costantiSchermo = require("costanti.costantiSchermo")
local bossFunctions = require "levels.boss.bossFunctions"
local player = require("costanti.player")
local ramzilla = require("levels.boss.ramzilla")
local gameFunctions = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 0 )

-------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI-----------------------------------------
function gameFunctions.resizeChram(playerChram)
    if(playerChram.contentWidth == nil or playerChram.contentHeight == nil) then
        return
    end
    if(playerChram.contentHeight >= 250) then
        return
    end
    playerChram : scale(1.011, 1.011)
    timer.performWithDelay(1)
    physics.removeBody(playerChram)
    physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
end

function gameFunctions.endGame(score)
    --composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    if(costantiSchermo.timer ~= nil) then
        timer.cancel(costantiSchermo.timer)
    end
    levelsFunctions.removeBoss()
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
    bossFunctions.pauseBoss()
    levelsFunctions.pauseLoop()
    objectsFunctions.pauseDrag()
    costantiSchermo.pauseLoop()
end

function gameFunctions.resumeGame()
    physics.start()
    bossFunctions.resumeBoss()
    levelsFunctions.resumeLoop()
    objectsFunctions.resumeDrag()
    costantiSchermo.resumeLoop()
end


function gameFunctions.versus(enemy)
    gameFunctions.pauseGame()
    local chram = display.newImageRect("images/versus/ChRAMvs.png", 1111*1.30, 1795*1.30)
    chram.x = 2*display.contentCenterX
    chram.y = display.contentCenterY
    local opponent = display.newImageRect(enemy, 1111*1.30, 1795*1.30)
    opponent.x = -display.contentCenterX
    opponent.y = display.contentCenterY
    function fadeout()
        transition.fadeOut(chram, {time = 1500, delay = 500})
        transition.fadeOut(opponent, {time = 1500, delay = 500, onComplete = gameFunctions.resumeGame})
    end
    transition.to(chram, {time = 300, x = display.contentCenterX})
    transition.to(opponent, {time = 300, x = display.contentCenterX, onComplete = fadeout})

end

local function resizeChram() --mi serve poter passare la funzione senza parametri
    gameFunctions.resizeChram(player.playerChram)
end

local function updateLives()
    gameFunctions.updateLives(player.playerChram, costantiOggetti.playerState, costantiSchermo.livesText)
end

function gameFunctions.onCollision( event, objTable )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2

        if(obj1.myName == "Chram") then
            if(obj2.myName == "ram2GB" ) then
                display.remove(obj2)
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 2)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj2.myName=="ram8GB") then
                display.remove(obj2)
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram,4)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 8)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj2.myName=="cacheCleaner") then
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay(1, updateLives)
            elseif(obj2.myName=="projectile") then
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, updateLives)
            end
        end
        if(obj2.myName == "Chram") then
            if(obj1.myName == "ram2GB" ) then
                display.remove(obj1)
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 2)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj1.myName=="ram8GB") then--
                display.remove(obj1)
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 8)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj1.myName=="cacheCleaner") then
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, updateLives)
            elseif(obj1.myName=="projectile") then
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, updateLives)
            end
        end
        if (obj1.myName == "ramShooten" and obj2.myName == "Ramzilla" ) then
            if( ramzilla.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score)
            end
        elseif (obj1.myName == "Ramzilla" and obj2.myName == "ramShooten") then
            if( ramzilla.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score)
            end
        end
    end
end

return gameFunctions