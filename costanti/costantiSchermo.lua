local composer = require( "composer" )
local costanti = require("costanti.costantiOggetti")
local costantiSchermo = {}

local isStopped = false
local noBoss = true
local printedPowerUps = {}
function costantiSchermo.pauseLoop()
    isStopped = true
end

function costantiSchermo.resumeLoop()
    isStopped = false
end
 
local function finishTime(secondsLeft,playerState)
    if secondsLeft == 0 then
        if(noBoss == true) then
            composer.setVariable( "finalScore", playerState.score )
            composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
        end
    return true
    end
end

local function updateTime( event,playerState )

    if (isStopped == true) then
        return
    end
    -- Decrement the number of seconds
    costantiSchermo.secondsLeft = costantiSchermo.secondsLeft - 1
    
    -- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( costantiSchermo.secondsLeft / 60 )
    local seconds = costantiSchermo.secondsLeft % 60
    
    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
        
    -- Update the text object
    costantiSchermo.clockText = timeDisplay
    if(finishTime(costantiSchermo.secondsLeft,playerState)) then
        timer.cancel(costantiSchermo.timer)
    end
end

function costantiSchermo.clockTextInit(time, seconds,playerState)
    costantiSchermo.clockText = time
    -- sceneGroup:insert(costantiSchermo.clockText)
    costantiSchermo.secondsLeft = seconds
    function updateNoParam()
        updateTime(event,playerState)
    end
    costantiSchermo.timer = timer.performWithDelay(1000, updateNoParam, 0)    
end

function costantiSchermo.livesScoreTextInit(sceneGroup, playerState)
    costantiSchermo.livesText = display.newText( sceneGroup, "Lives : " .. playerState.lives , 200, 130, native.systemFont, 50 )
	costantiSchermo.scoreText = display.newText( sceneGroup, "Score : " .. playerState.score .. "GB", 500, 130, native.systemFont, 50 )
end

function costantiSchermo.allTextInit(sceneGroup, time, seconds, playerState, flag)
    --DA RIMUOVERE
    noBoss = flag
    --
    costantiSchermo.clockTextInit(time, seconds, playerState)
    costantiSchermo.livesScoreTextInit(sceneGroup, playerState)
end

function costantiSchermo.finalizeLoop()
    transition.fadeOut(costantiSchermo.clockText,  { time = 1 })
    timer.cancel(costantiSchermo.timer)
    if(#costanti.playerState.powerUps > 0) then
        costantiSchermo.removeAllPwups()
    end
end


return costantiSchermo


    