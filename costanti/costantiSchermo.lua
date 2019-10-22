local composer = require( "composer" )
local costantiSchermo = {}

local isStopped = false

function costantiSchermo.pauseLoop()
    isStopped = true
end

function costantiSchermo.resumeLoop()
    isStopped = false
end
 
local function finishTime(secondsLeft)
    if secondsLeft == 0 then
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
    return true
    end
end


local function updateTime( event )

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
    costantiSchermo.clockText.text = timeDisplay
    if(finishTime(costantiSchermo.secondsLeft)) then
        transition.fadeOut(costantiSchermo.clockText,{ time=800 })
        timer.cancel(costantiSchermo.timer)

    end
end

function costantiSchermo.clockTextInit(time, seconds)
    costantiSchermo.clockText = display.newText( time, 600, 80, native.systemFont, 36 )
    -- sceneGroup:insert(costantiSchermo.clockText)
    costantiSchermo.secondsLeft = seconds
    costantiSchermo.timer = timer.performWithDelay(1000, updateTime, 0)
    
end

return costantiSchermo


    