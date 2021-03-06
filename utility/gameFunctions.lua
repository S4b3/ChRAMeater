local composer = require( "composer" )
local costantiOggetti = require("costanti.costantiOggetti")
local objectsFunctions = require "utility.objectsFunctions"
local levelsFunctions = require("utility.levelsFunctions")
local sounds = require("costanti.sounds")
local costantiSchermo = require("costanti.costantiSchermo")
local bossFunctions = require "levels.boss.bossFunctions"
local player = require("costanti.player")
local ramzilla = require("levels.boss.ramzilla")
local safaram = require("levels.boss.safaram")
local edGram = require("levels.boss.edgram")
local tor = require("levels.boss.tor")
local gameFunctions = {}
local pause = false

ramSound = sounds.ramSound
powerupSound =sounds.powerupSound
audio.setVolume( 0.15, { channel=2 } )
local physics = require( "physics" )
local isMenuStopped = false

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
    physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor = true } )
end

function gameFunctions.endGame(score)
    --composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    if(costantiSchermo.timer ~= nil) then
        timer.cancel(costantiSchermo.timer)
        objectsFunctions.removeAllPwups()
    end
    levelsFunctions.removeBoss()
    composer.setVariable( "finalScore", score )
    composer.setVariable( "died", costantiOggetti.playerState.died )
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
			timer.performWithDelay( 2000, gameFunctions.endGame(playerState.score))
        else
            playerChram.alpha = 0
            playerChram.isBodyActive = false
            objectsFunctions.restorePlayerCharm(playerChram, playerState)
            playerChram.isBodyActive = true
        end
    end
end


function gameFunctions.updateLivesCattiva(playerChram, playerState,livesText)
    if ( playerState.died == false ) then
        playerState.setDied(true)
        -- Update lives
        playerState.decrementLives()
        livesText.text = "Lives: " .. playerState.lives
        playerState.decrementScore(20)
        costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
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

function gameFunctions.isMenuStopped()
    return isMenuStopped
end


function gameFunctions.pauseGame()
    physics.pause()
    bossFunctions.pauseBoss()
    levelsFunctions.pauseLoop()
    player.pauseDrag()
    player.stopProjectiles()
    costantiSchermo.pauseLoop()
    pause=true
end

function gameFunctions.resumeGame()
    physics.start()
    bossFunctions.resumeBoss()
    levelsFunctions.resumeLoop()
    player.resumeDrag()
    player.resumeProjectiles()
    costantiSchermo.resumeLoop()
    pause = false
end

function gameFunctions.getPause()
    return pause
end


function gameFunctions.versus(enemy)
    isMenuStopped = true
    gameFunctions.pauseGame()
    local chram = display.newImageRect("images/versus/ChRAMvs.png", 1111*1.30, 1795*1.30)
    chram.x = 2*display.contentCenterX
    chram.y = display.contentCenterY
    local opponent = display.newImageRect(enemy, 1111*1.30, 1795*1.30)
    opponent.x = -display.contentCenterX
    opponent.y = display.contentCenterY
    function fadeout()
        transition.fadeOut(chram, {time = 1500, delay = 500})
        transition.fadeOut(opponent, {time = 1500, delay = 500, onComplete = function()
            gameFunctions.resumeGame()
            isMenuStopped = false
        end
        })
    end
    transition.to(chram, {time = 300, x = display.contentCenterX})
    transition.to(opponent, {time = 300, x = display.contentCenterX, onComplete = fadeout})

end

local function resizeChram() --mi serve poter passare la funzione senza parametri
    gameFunctions.resizeChram(player.playerChram)
end

local function increaseLives()
    costantiOggetti.playerState.lives = costantiOggetti.playerState.lives +1
    costantiSchermo.livesText.text = "Lives: " .. costantiOggetti.playerState.lives
end

local function updateLives()
    system.vibrate()
    gameFunctions.updateLives(player.playerChram, costantiOggetti.playerState, costantiSchermo.livesText)
end

local function updateLivesCattiva()
    gameFunctions.updateLivesCattiva(player.playerChram, costantiOggetti.playerState, costantiSchermo.livesText)
end

local function setPlayerVelocityZero()
    timer.performWithDelay(1,function () player.playerChram:setLinearVelocity(0,0) end)
end

local obj1 
local obj2 
function gameFunctions.onCollision( event, objTable, sceneGroup )
    if ( event.phase == "began" ) then
        obj1 = event.object1
        obj2 = event.object2

        if(obj1.myName == "Chram") then
            if(obj2.myName == "ram2GB" ) then
                display.remove(obj2)
                audio.play(sounds.ramSound,{ channel=3})
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 2)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj2.myName=="ram8GB") then
                display.remove(obj2)
                audio.play(sounds.ramSound,{ channel=3 })
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay( 1, resizeChram,4)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 8)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj2.myName=="cacheCleaner" ) then
                if objectsFunctions.ISinvincible==true then
                    return
                end
                timer.performWithDelay(1, updateLives)
            elseif(obj2.myName=="life") then
                display.remove(obj2)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay(1, increaseLives)
            elseif(obj2.myName=="projectile") then
                objectsFunctions.removeFromTable(obj2,objTable)
                timer.performWithDelay(1, updateLives)
            elseif(obj2.myName=="powerUpOnda") then
                display.remove(obj2)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj2, objTable)
                objectsFunctions.addPowerUp(obj2, sceneGroup)
            elseif(obj2.myName=="freeze") then
                display.remove(obj2)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj2, objTable)
                --objectsFunctions.addPowerUp(obj2, objTable)
                if levelsFunctions.isFreezed == false then
                    objectsFunctions.freeze(objTable,levelsFunctions)
                elseif levelsFunctions.isFreezed == true then
                    objectsFunctions.freezeGap = objectsFunctions.freezeGap + 5
                end
            elseif(obj2.myName=="invincibility") then
                display.remove(obj2)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj2, objTable)
                if(costantiSchermo.secondsLeft == 0 ) then return end
                if(not player.isCappellino()) then
                    player.cappellinoSwap()
                end
                if objectsFunctions.ISinvincible==false then
                    objectsFunctions.setInvincibility()
                    objectsFunctions.invincibility()
                elseif objectsFunctions.ISinvincible==true then
                    objectsFunctions.InvincibleTime = objectsFunctions.InvincibleTime + 5
                end
            end
        end
        if(obj2.myName == "Chram") then
            if(obj1.myName == "ram2GB" ) then
                display.remove(obj1)
                audio.play(sounds.ramSound,{ channel=3 })
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 2)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj1.myName=="ram8GB") then--
                display.remove(obj1)
                audio.play(sounds.ramSound,{ channel=3})
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay( 1, resizeChram)
                costantiOggetti.playerState.setScore(costantiOggetti.playerState.score + 8)
                costantiSchermo.scoreText.text = "Score: " .. costantiOggetti.playerState.score .. "GB"
            elseif(obj1.myName=="cacheCleaner" ) then
                if objectsFunctions.ISinvincible==true then
                    return
                end
                timer.performWithDelay(1, updateLives)
            elseif(obj1.myName=="life") then
                display.remove(obj1)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, increaseLives)
            elseif(obj1.myName=="projectile") then
                objectsFunctions.removeFromTable(obj1,objTable)
                timer.performWithDelay(1, updateLives)
            elseif(obj1.myName=="powerUpOnda") then
                display.remove(obj1)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj1, objTable)
                objectsFunctions.addPowerUp(obj1, sceneGroup)
            elseif(obj1.myName=="freeze") then
                display.remove(obj1)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj1, objTable)
                --objectsFunctions.addPowerUp(obj2, objTable)
                if levelsFunctions.isFreezed == false then
                    objectsFunctions.freeze(objTable,levelsFunctions)
                elseif levelsFunctions.isFreezed == true then
                    objectsFunctions.freezeGap = objectsFunctions.freezeGap + 3
                end
            elseif(obj1.myName=="invincibility") then
                display.remove(obj1)
                audio.play(sounds.powerupSound,{ channel=2})
                objectsFunctions.removeFromTable(obj1, objTable)
                if(costantiSchermo.secondsLeft == 0 ) then return end
                if(not player.isCappellino()) then
                    player.cappellinoSwap()
                end
                if objectsFunctions.ISinvincible==false then
                    objectsFunctions.setInvincibility()
                    objectsFunctions.invincibility()
                else if objectsFunctions.ISinvincible==true then
                    objectsFunctions.InvincibleTime = objectsFunctions.InvincibleTime + 5
                end
            end
            end
        end
        if (obj1.myName == "ramShooten" and obj2.myName == "Edgram" ) then
            obj1.isVisible = false
            if( edGram.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        elseif (obj1.myName == "Edgram" and obj2.myName == "ramShooten") then
            obj2.isVisible = false
            if( edGram.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        end
        if (obj1.myName == "ramShooten" and obj2.myName == "Ramzilla" ) then
            obj1.isVisible = false
            if( ramzilla.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        elseif (obj1.myName == "Ramzilla" and obj2.myName == "ramShooten") then
            obj2.isVisible = false
            if( ramzilla.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        end
        if (obj1.myName == "ramShooten" and obj2.myName == "Tor" ) then
            obj1.isVisible = false
            if( tor.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        elseif (obj1.myName == "Tor" and obj2.myName == "ramShooten") then
            obj2.isVisible = false
            if( tor.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        end
        if (obj1.myName == "ramShooten" and obj2.myName == "Safari" ) then
            obj1.isVisible = false
            if( safaram.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        elseif (obj1.myName == "Safari" and obj2.myName == "ramShooten") then
            obj2.isVisible = false
            if( safaram.onHit() ) then
                gameFunctions.endGame(costantiOggetti.playerState.score, 0)
            end
        end
    end
    if(event.phase=="ended" and (obj1.myName == "Chram" or obj2.myName == "Chram" ) ) then
        if(objectsFunctions.ISinvincible == false 
             and( obj1.myName=="cacheCleaner" or obj1.myName == "projectile" 
            or obj2.myName=="cacheCleaner" or obj2.myName=="projectile") ) then 
            return
        end
        setPlayerVelocityZero()
    end
end

return gameFunctions