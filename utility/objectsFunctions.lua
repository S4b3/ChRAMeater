local objectsFunctions = {}
local costanti = require("costanti.costantiOggetti")
local player = require("costanti.player")

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local isStopped = false

function objectsFunctions.removeFromTable(obj,objTable)
    for i = #objTable, 1, -1 do
        if ( objTable[i] == obj ) then
            table.remove( objTable, i )
            break
        end
    end
end

function objectsFunctions.addPowerUp(obj, sceneGroup)
    costanti.addPowerUp(obj)
    objectsFunctions.printPowerUps(sceneGroup)
end

function objectsFunctions.removePowerUp(objname)
    costanti.removePowerUp(objname)
end

function objectsFunctions.restorePlayerCharm(playerChram, playerState)
    playerChram.x = display.contentCenterX
    playerChram.y = display.contentHeight - 100
    -- Fade in the playerChram
    physics.removeBody(playerChram)
    transition.to( playerChram, { alpha=1, time=2000,
        onComplete = function()
            playerChram.isBodyActive = true
            if(playerChram.contentHeight ~= nil) then
                physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
            end
            playerState.setDied(false) --non serve se lo sposto
        end
    } )
end

local lastItem
local items = {}

local function ondaTap(event)
    if(isStopped) then
        return
    end
    local function remove()
        display.remove(lastItem)
        table.remove(items,#items)
        lastItem = items[#items]
    end

    local shockWave = display.newCircle(player.playerChram.x,player.playerChram.y, 600)
    shockWave:setFillColor(0.5000,0.0588,1.0000)
    local function shockFunc()
        shockWave: scale(1.015, 1.015)
        timer.performWithDelay(1, function ()
            physics.addBody( shockWave, "dynamic" ,{bounce=1000000, radius=shockWave.contentHeight/2 } )
            physics.removeBody(shockWave)
        end
        )
    end
    shockWave.alpha=0.2
    timer.performWithDelay(1, shockFunc , 20)
    timer.performWithDelay(1, remove)
    costanti.removePowerUp(event.target.myName)
    timer.performWithDelay(800, function() shockWave:removeSelf() end)
    return
end

function objectsFunctions.printPowerUps(sceneGroup)
    local currentY = display.contentHeight *3 / 4
    for i = 1, #costanti.playerState.powerUps do
        if( i == #items+1 ) then
            items[i] = display.newImage(sceneGroup, costanti.objectSheet(), 5, display.contentWidth - 100, currentY)
            items[i].myName = "powerUpOnda"
            items[i]:scale(0.25,0.25)
            items[i]:addEventListener("tap", ondaTap)
            lastItem = items[i]
        end
        currentY = currentY - 160
    end
end

function objectsFunctions.removeAllPwups()
    if(#costanti.playerState.powerUps ==0) then
        return
    end
    for i = 1, #costanti.playerState.powerUps do
        --print(items[i].myName)
        items[i] = nil
        costanti.playerState.powerUps[i] = nil
    end
end


return objectsFunctions