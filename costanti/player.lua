local costanti = require("costanti.costantiOggetti")
local costantiSchermo = require "costanti.costantiSchermo"

local player = {}
local scene
local isStopped

local function dragPlayerChram( event )
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

function player.shoot(event)
    if(costanti.playerState.score == 0) then
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
    transition.to(ramShooten, {y = -10, time = 500, onComplete = function () ramShooten:removeSelf() end })
    costantiSchermo.scoreText.text =  "Score : " .. costanti.playerState.score .. "GB"

end

function player.playerInit(sceneGroup)
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

function player.pauseDrag()
    isStopped = true
end

function player.resumeDrag()
    isStopped = false
end

return player