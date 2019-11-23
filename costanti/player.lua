local costanti = require("costanti.costantiOggetti")
local costantiSchermo = require "costanti.costantiSchermo"

local player = {}
local activeTransitions = {}
local scene
local isStopped
local isCappellino

function player.isCappellino()
    return isCappellino
end

local function dragPlayerChram( event )
    if(isStopped ) then
        return
    end
    local playerChram = event.target
    local phase = event.phase
    if ( "began" == phase ) then
        -- Set touch focus on playerChram
        display.currentStage:setFocus( playerChram, event.id )
        playerChram.touchOffsetX = event.x - playerChram.x
        playerChram.touchOffsetY = event.y - playerChram.y
    elseif ( "moved" == phase ) then
        if(playerChram.touchOffsetX== nil or playerChram.touchOffsetY == nil or event.x == nil or event.y == nil) then
            return
        end
        -- Move playerChram to the new touch position
        playerChram.x = event.x - (playerChram.touchOffsetX)
        playerChram.y = event.y - (playerChram.touchOffsetY)
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on playerChram
        display.currentStage:setFocus( playerChram, nil )
        movementEventId = nil
        return true
    end
end

function player.shoot(event)
    if(costanti.playerState.score == 0 or isStopped) then
        return
    end
    costanti.playerState.setScore(costanti.playerState.score - 2)
    local ramShooten = display.newImage(scene, costanti.objectSheet(), 4)
    physics.addBody( ramShooten, "dynamic", { shape = costanti.smallRamShape } )
    ramShooten:rotate(90)
    ramShooten:toBack()
    ramShooten.myName = "ramShooten"
    ramShooten:scale(0.27, 0.27)
    ramShooten.x = player.playerChram.x
    ramShooten.y = player.playerChram.y
    table.insert(activeTransitions, transition.to(ramShooten, {y = -10, time = 500, onComplete = function () ramShooten:removeSelf() end }) )
    costantiSchermo.scoreText.text =  "Score : " .. costanti.playerState.score .. "GB"
    return true
end

function player.playerInit(sceneGroup)
    isCappellino =  false
    scene = sceneGroup

    player.defaultSkin = {
        type = "image",
        sheet = costanti.objectSheet(),
        frame = 2
    }
    player.incognitoSkin = {
        type = "image",
        sheet = costanti.objectSheet(),
        frame = 7
    }
    player.playerChram = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight-150, 180, 180)
    player.playerChram.fill = player.defaultSkin
	player.playerChram.x = display.contentCenterX
	player.playerChram.y = display.contentHeight - 150
	physics.addBody( player.playerChram, "dynamic" ,{ radius=player.playerChram.contentHeight/2} )
    player.playerChram.myName = "Chram"
    player.playerChram.gravityScale = 0.0
    player.playerChram:addEventListener( "touch", dragPlayerChram )
   -- player.playerChram:addEventListener( "tap" , player.shoot)
end

function player.cappellinoSwap()
    if(isCappellino == true) then
        player.playerChram.fill = (player.defaultSkin)
        isCappellino = false
    else 
        player.playerChram.fill = (player.incognitoSkin)
        isCappellino = true
    end
end

function player.pauseDrag()
    isStopped = true
end

function player.resumeDrag()
    isStopped = false
end

--transition.cancel(activeTransitions[i])

function player.emptyTransitions()
    if(#activeTransitions > 0) then
        for i=1, #activeTransitions do
            transition.cancel(activeTransitions[i])
        end
    end
end

function player.stopProjectiles()
    if(#activeTransitions > 0) then
        for i=1, #activeTransitions do
            transition.pause(activeTransitions[i])
        end
    end
end

function player.resumeProjectiles()
    if(#activeTransitions > 0) then
        for i=1, #activeTransitions do
            transition.resume(activeTransitions[i])
        end
    end
end

return player