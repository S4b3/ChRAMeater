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

return costanti