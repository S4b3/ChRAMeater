local costantiOggetti = require("costanti.costantiOggetti")
local safaram = require("levels.boss.safaram")
local player = require("costanti.player")
local functionLivThree = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local isStopped = false
-------------------------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI-----------------------------------------------------
function functionLivThree.stopCreating()
    isStopped = true
end

function functionLivThree.startCreating()
    isStopped = false
end

function functionLivThree.spawnBoss(sceneGroup)
    safaram.safariInit(player.playerChram, sceneGroup)
    isStopped = true
end

function functionLivThree.removeBoss()
    safaram.safariRemove()
    isStopped = false
end

function functionLivThree.createObjects(mainGroup,objectSheet,objTable)
    if(isStopped) then
        return
    end

    local selector = math.random ( 100 )
    local objIndicator
    local objName

    if(selector <= 48) then
        objIndicator = 4
        objName="ram2GB"
    elseif (selector > 48 and selector <= 58) then
        objIndicator = 3
        objName="ram8GB"
    elseif (selector > 58 and selector <= 92) then
        objIndicator = 1
        objName="cacheCleaner"
    elseif (selector >92 and selector <= 95 ) then
        objIndicator = 7
        objName="life"
    elseif (selector > 95 and selector <= 98 ) then
        objIndicator = 9
        objName="freeze"
    elseif (selector > 98) then
        objIndicator = 5
        objName="powerUpOnda"
    end
    if(mainGroup==nil or objectSheet==nil) then
        return end
    local newObject = display.newImage( mainGroup, objectSheet, objIndicator)
    newObject:scale(0.25, 0.25)
    table.insert( objTable, newObject )

    if(objName=="ram2GB") then
        physics.addBody( newObject, "dynamic", { shape = smallRamShape } )
    elseif(objName=="ram8GB") then
        physics.addBody( newObject, "dynamic", { shape = bigRamShape } )
    elseif(objName=="cacheCleaner") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    elseif(objName=="life") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    elseif(objName == "freeze") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    elseif(objName == "powerUpOnda") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    end
    newObject.myName = objName

    local whereFrom = math.random( 4 )

    if ( whereFrom == 1 ) then
        -- From the left
        newObject.x = -60
        newObject.y = math.random( 500 )
        newObject:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newObject.x = display.contentWidth + 60
        newObject.y = math.random( 500 )
        newObject:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    elseif  ( whereFrom == 4 and newObject.myName == "cacheCleaner" )then
        newObject.x = player.playerChram.x
        newObject.y = -60
        newObject:setLinearVelocity( 0, 10200)
        newObject.isBullet = true
    elseif (whereFrom == 4) then
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    end

    newObject:applyTorque( math.random( -6,6 ) )
end

function functionLivThree.gameLoop(mainGroup,objectSheet,objTable)
    createObjects(mainGroup,objectSheet,objTable)
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

return functionLivThree