local costanti = {}

local objectsFunctions = require("utility.objectsFunctions")

local bigRamShape = {   (512/2)*2/10,(-288/2)*2/10, (512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(-288/2)*2/10    }
local smallRamShape = { (512/2)*2/10,(-192/2)*2/10, (512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(-192/2)*2/10   }
costanti.levels = {"liv1","liv2","liv3","liv4"}

costanti.playerState = {}

function costanti.playerStateInit(lives)
    costanti.playerState.lives = lives
    costanti.playerState.score = 0
    costanti.playerState.died = false
end

function costanti.playerState.setScore(value)
    costanti.playerState.score = value
end

function costanti.playerState.decrementLives()
    costanti.playerState.lives = costanti.playerState.lives-1
end

function costanti.playerState.setDied(bool)
    costanti.playerState.died = bool
end

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
        {-- life
        x = 0,
        y = 1505,
        width = 512,
        height = 512
    },
    },
}
-- ritorna il caricamento del foglio immagine in memoria
function costanti.objectSheet()
    return graphics.newImageSheet("images/GameObjects3.png", sheetOptions)
end

return costanti