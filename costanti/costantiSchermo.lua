
local gameFunctions = require "utility.gameFunctions"

local costantiSchermo = {}

local function updateTime( event )

    -- Decrement the number of seconds
    costantiSchermo.secondsLeft = costantiSchermo.secondsLeft - 1
    
    -- Time is tracked in seconds; convert it to minutes and seconds
    local minutes = math.floor( costantiSchermo.secondsLeft / 60 )
    local seconds = costantiSchermo.secondsLeft % 60
    
    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutes, seconds )
        
    -- Update the text object
    costantiSchermo.clockText.text = timeDisplay
    if(gameFunctions.finishTime(costantiSchermo.secondsLeft)) then
        transition.fadeOut(costantiSchermo.clockText,{ time=800 })
    end
end

function costantiSchermo.clockTextInit(time, seconds)
    costantiSchermo.clockText = display.newText( time, 600, 80, native.systemFont, 36 )
    costantiSchermo.secondsLeft = seconds
    timer.performWithDelay(1000, updateTime, costantiSchermo.secondsLeft)
end



return costantiSchermo


    