local costanti = require("costanti.costantiOggetti")
local costantiSchermo = require "costanti.costantiSchermo"

local player = {}
local activeTransitions = {}
local scene
local isStopped
local isCappellino
local movementEventId

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
        movementEventId = event.id
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
    player.playerChram = display.newImageRect(sceneGroup, costanti.objectSheet(), 2, 180, 180)
	player.playerChram.x = display.contentCenterX
	player.playerChram.y = display.contentHeight - 150
	physics.addBody( player.playerChram, { radius=player.playerChram.contentHeight/2, isSensor=true } )
    player.playerChram.myName = "Chram"
    player.playerChram.gravityScale = 0.0
    player.playerChram:addEventListener( "touch", dragPlayerChram )
   -- player.playerChram:addEventListener( "tap" , player.shoot)

end

function player.cappellinoSwap()
    local selector
    if(isCappellino == true) then
        selector = 2
        isCappellino = false
    else 
        selector = 7
        isCappellino = true
    end
    local chram = player.playerChram
    player.playerChram = display.newImageRect(scene, costanti.objectSheet(), selector, 180, 180)
    player.playerChram.x = chram.x
    player.playerChram.y = chram.y
	player.playerChram.myName = "Chram"
    player.playerChram.gravityScale = 0.0
    chram:removeSelf()
    player.playerChram:toBack()

    local event = {}
    event.phase = "began"
    event.target = player.playerChram
    event.x = player.playerChram.x
    event.y = player.playerChram.y
    event.id = movementEventId
    timer.performWithDelay(1, function ()
        physics.addBody( player.playerChram, { radius=player.playerChram.contentHeight/2, isSensor=true } )
        player.playerChram:addEventListener( "touch", dragPlayerChram )
    end)
    --display.currentStage:setFocus(player.playerChram, event.id)
    --timer.performWithDelay(1, function ()
    if(movementEventId ~= nil) then
        dragPlayerChram(event)
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