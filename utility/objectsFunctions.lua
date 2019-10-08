local objectsFunctions = {}

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )


function objectsFunctions.dragPlayerChram( event )
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

function objectsFunctions.restorePlayerCharm(playerChram, playerState)
    playerChram.x = display.contentCenterX
    playerChram.y = display.contentHeight - 100
    -- Fade in the playerChram
    physics.removeBody(playerChram)
    transition.to( playerChram, { alpha=1, time=4000,
        onComplete = function()
            playerChram.isBodyActive = true
            physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
            playerState.setDied(false) --non serve se lo sposto
        end
    } )
end


return objectsFunctions