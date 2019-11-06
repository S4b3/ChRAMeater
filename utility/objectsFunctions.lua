local objectsFunctions = {}
local costanti = require("costanti.costantiOggetti")
local costantiSchermo = require("costanti.costantiSchermo")
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local isStopped = false

function objectsFunctions.pauseDrag()
    isStopped = true
end

function objectsFunctions.resumeDrag()
    isStopped = false
end

function objectsFunctions.dragPlayerChram( event )
    if(isStopped ) then
        return
    end
    local playerChram = event.target
    local phase = event.phase
    if ( "began" == phase ) then
        -- Set touch focus on playerChram
        display.currentStage:setFocus( playerChram )
        playerChram.touchOffsetX = event.x - playerChram.x
        playerChram.touchOffsetY = event.y - playerChram.y
    elseif ( "moved" == phase ) then
        -- Move playerChram to the new touch position
        playerChram.x = event.x - playerChram.touchOffsetX
        playerChram.y = event.y - playerChram.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on playerChram
        display.currentStage:setFocus( nil )
    end
    return true 
end

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
    costantiSchermo.printPowerUps()
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

local linearVelocityXTable = {}
local linearVelocityYTable = {}
local angularVelocityTable = {}

function objectsFunctions.freeze(objTable, levelsFunction) 
    levelsFunction.freezeLoop() -- da problemi
    for i = 1 , #objTable do --funziona
        local vx,vy = objTable[i]:getLinearVelocity()
        linearVelocityXTable[i] = vx
        linearVelocityYTable[i] = vy
        angularVelocityTable[i] = objTable[i].angularVelocity
        objTable[i]:setLinearVelocity(0,0)
        objTable[i].angularVelocity = 0
    end
    local function resumeVelocity() --funziona
        print("ripartito")
        for i = 1 , #objTable do
            objTable[i]:setLinearVelocity(linearVelocityXTable[i] ,linearVelocityYTable[i] )
            objTable[i].angularVelocity = angularVelocityTable[i]
        end
        timer.cancel(uppaTimer)
    end
    local time = costantiSchermo.secondsLeft
    local intialtime = time
    local function uppa() -- mi serve per aggiornare il tempo che passa
        time = costantiSchermo.secondsLeft
    end 
    uppaTimer = timer.performWithDelay(1, uppa, 0)

    local function controlla ()
        if (time == intialtime-5) then --  and currentLevel == "levels.liv1.liv1"
            levelsFunction.resumeFreezeLoop()
            resumeVelocity()
            timer.cancel(controllaTimer)
        end 
    end
    controllaTimer = timer.performWithDelay(1000, controlla, 0)
end

return objectsFunctions