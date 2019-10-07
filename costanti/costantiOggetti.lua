local costanti = {}

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local sheetOptions = {

    frames =
    {
        { -- cache cleaner
            x = 0, 
            y = 0,
            width = 512,
            height = 512
        },
        {-- chrome
            x = 0,
            y = 512,
            width = 512,
            height = 512
        },
        {--ram big!
            x = 0,
            y = 1024,
            width = 512,
            height = 288
        },
        {--ram comune
            x = 0,
            y = 1312,
            width = 512,
            height = 192
        },
    },

}

function costanti.objectSheet()
    return graphics.newImageSheet("./images/GameObjects2.png", sheetOptions)
end


function costanti.dragplayerChram( event )
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


return costanti