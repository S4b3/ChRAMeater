local levelsFunction = {}
local liv1 = require("levels.liv1.functionLivOne")
local liv2 = require("levels.liv2.functionLivTwo")
local liv3 = require("levels.liv3.functionLivThree")
local liv4 = require("levels.liv4.functionLivFour")
local levels= {liv1,liv2,liv3,liv4}
local costantiSchermo = require("costanti.costantiSchermo")

local ramzillaLF = require("levels.boss.ramzillaLevelFunctions")


local isStopped = false
local isBossSpawned = false
local currentLevel

function levelsFunction.gameLoop(mainGroup,objectSheet,objTable, intLevel)
    currentLevel = intLevel
    if (isStopped == true) then
        return
    end
    if(costantiSchermo.secondsLeft == 0 and not isBossSpawned) then
        levels[intLevel].spawnBoss(mainGroup)
        isBossSpawned = true
    end
    if(intLevel == "ramzilla") then
        ramzillaLF.createObjects(mainGroup, objectSheet, objTable)
    else
        levels[intLevel].createObjects(mainGroup,objectSheet,objTable)
    end
    -- Remove rams which have drifted off screen
    for i = #objTable, 1, -1 do
        local thisRam = objTable[i]
        if ( thisRam.x < -100 or
             thisRam.x > display.contentWidth + 100 or
             thisRam.y < -100 or
             thisRam.y > display.contentHeight + 100 )
        then
            display.remove( thisRam )
            table.remove( objTable, i )
        end
    end
end

function levelsFunction.removeBoss()
    if(isBossSpawned) then
        isBossSpawned = false
        levels[currentLevel].removeBoss()
    end
end

function levelsFunction.pauseLoop()
    isStopped = true
end

function levelsFunction.resumeLoop()
    isStopped = false
end

return levelsFunction