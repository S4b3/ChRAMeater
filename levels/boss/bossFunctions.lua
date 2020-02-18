local composer = require("composer")
local ramzilla = require("levels.boss.ramzilla")
local tor = require("levels.boss.tor")
local safaram = require("levels.boss.safaram")
local edgram = require("levels.boss.edgram") 

local bossFunctions = {}
local currentLevel


function bossFunctions.pauseBoss()
    currentLevel = composer.getSceneName("current")
    if( currentLevel == "levels.liv1.liv1") then
        ramzilla.pause()
    elseif (currentLevel == "levels.liv2.liv2") then
        edgram.pause()
    elseif (currentLevel == "levels.liv3.liv3") then
        safaram.pause()
    elseif (currentLevel == "levels.liv4.liv4") then
        tor.pause()
    end
end

function bossFunctions.resumeBoss()
    currentLevel = composer.getSceneName("current")
    if( currentLevel == "levels.liv1.liv1") then
        ramzilla.resume()
    elseif (currentLevel == "levels.liv2.liv2") then
        edgram.resume()
    elseif (currentLevel == "levels.liv3.liv3") then
        safaram.resume()
    elseif (currentLevel == "levels.liv4.liv4") then
        tor.resume()
    end
end


return bossFunctions