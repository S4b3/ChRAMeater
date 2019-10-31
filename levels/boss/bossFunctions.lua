local composer = require("composer")
local ramzilla = require("levels.boss.ramzilla")
local safaram = require("levels.boss.safaram")

local bossFunctions = {}
local currentLevel


function bossFunctions.pauseBoss()
    currentLevel = composer.getSceneName("current")
    if( currentLevel == "levels.liv1.liv1"  or currentLevel == "levels.liv2.liv2") then
        ramzilla.pause()
    elseif (currentLevel == "levels.liv3.liv3") then
        safaram.pause()
    end
end

function bossFunctions.resumeBoss()
    currentLevel = composer.getSceneName("current")
    if( currentLevel == "levels.liv1.liv1"  or currentLevel == "levels.liv2.liv2") then
        ramzilla.resume()
    elseif (currentLevel == "levels.liv3.liv3") then
        safaram.resume()
    end
end
return bossFunctions