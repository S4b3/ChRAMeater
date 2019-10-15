local costanti = {}

local bigRamShape = {   (512/2)*2/10,(-288/2)*2/10, (512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(-288/2)*2/10    }
local smallRamShape = { (512/2)*2/10,(-192/2)*2/10, (512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(-192/2)*2/10   }
costanti.levels = {"liv1","liv2","liv3","liv4"}

function costanti.getBigRamShape()
    return bigRamShape
end

function costanti.getSmallRamShape()
    return smallRamShape
end

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
    return graphics.newImageSheet("images/GameObjects2.png", sheetOptions)
end

return costanti