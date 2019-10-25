local objectsFunctions = require("utility.objectsFunctions")
local costanti = require("costanti.costantiOggetti")

local player = {}


function player.playerInit(sceneGroup)
    player.playerChram = display.newImageRect(sceneGroup, costanti.objectSheet(), 2, 180, 180)
	player.playerChram.x = display.contentCenterX
	player.playerChram.y = display.contentHeight - 150
	physics.addBody( player.playerChram, { radius=player.playerChram.contentHeight/2, isSensor=true } )
    player.playerChram.myName = "Chram"
    player.playerChram.gravityScale = 0.0
    player.playerChram:addEventListener( "touch", objectsFunctions.dragPlayerChram )
end

return player