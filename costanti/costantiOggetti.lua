local costanti = {}

local bigRamShape = {   (512/2)*2/10,(-288/2)*2/10, (512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(-288/2)*2/10    }
local smallRamShape = { (512/2)*2/10,(-192/2)*2/10, (512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(-192/2)*2/10   }
costanti.levels = {"liv1","liv2","liv3","liv4"}

-- ritorna la forma della ram grande
function costanti.getBigRamShape()
    return bigRamShape
end
-- ritorna la forma della ram piccola
function costanti.getSmallRamShape()
    return smallRamShape
end

-- configurazione foglio immagine 
local sheetOptions = {

    -- specifico dove sono posizionati gli oggetti di gioco all'interno del foglio
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
        {-- ram grande
            x = 0,
            y = 1024,
            width = 512,
            height = 288
        },
        {-- ram piccola
            x = 0,
            y = 1312,
            width = 512,
            height = 192
        },
    },

}
-- ritorna il caricamento del foglio immagine in memoria
function costanti.objectSheet()
    return graphics.newImageSheet("images/GameObjects2.png", sheetOptions)
end

return costanti