local costanti = {}

local lives = 3;
local died = false;
local score = 0;

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local bigRamShape = {   (512/2)*2/10,(-288/2)*2/10, (512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(288/2)*2/10, (-512/2)*2/10,(-288/2)*2/10    }
local smallRamShape = { (512/2)*2/10,(-192/2)*2/10, (512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(192/2)*2/10, (-512/2)*2/10,(-192/2)*2/10   }
local newShape

local livesText = "Lives : ".. lives;
local scoreText = "Score : " .. score;

function costanti.getLives()
    return lives
end

function costanti.setLives(livesNew)
    lives = livesNew
end

function costanti.isDead()
    return died
end

function costanti.setDied(boolean)
    died = boolean
end

function costanti.getScore()
    return score
end

function costanti.setScore(newScore)
    score = newScore
end

function costanti.getBigRamShape()
    return bigRamShape
end

function costanti.getSmallRamShape()
    return smallRamShape
end

function costanti.getLivesText()
    return livesText
end

function costanti.setLivesText(text)
    livesText = text
end

function costanti.getScoreText()
    return scoreText
end

function costanti.setSoreText(text)
    scoreText = text
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