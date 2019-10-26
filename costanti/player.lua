local objectsFunctions = require("utility.objectsFunctions")
local costanti = require("costanti.costantiOggetti")
local costantiSchermo = require "costanti.costantiSchermo"

local player = {}
local scene

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
    player.playerChram:addEventListener( "touch", objectsFunctions.dragPlayerChram )
   -- player.playerChram:addEventListener( "tap" , player.shoot)

end

return player