local costantiOggetti = require("costanti.costantiOggetti")
--require del futuro boss
local boss = require("levels.boss.ramzilla")
local player = require("costanti.player")
local functionLivTwo = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local isStopped = false
-------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI------------------------------------------
function functionLivTwo.stopCreating()
    isStopped = true
end

function functionLivTwo.startCreating()
    isStopped = false
end

function functionLivTwo.spawnBoss(sceneGroup)
    boss.ramzillaInit(player.playerChram, sceneGroup)
    isStopped = true
end

function functionLivTwo.removeBoss()
    boss.ramzillaRemove()
    isStopped = false
end


function functionLivTwo.createObjects(mainGroup,objectSheet,objTable)
    if(isStopped) then
        return
    end
    
    local selector = math.random ( 100 )
    local objIndicator
    local objName

    if(selector <= 60) then
        objIndicator = 4
        objName="ram2GB"
    elseif (selector > 60 and selector <= 70) then
        objIndicator = 3
        objName="ram8GB"
    elseif (selector > 70 and selector <= 99) then
        objIndicator = 1
        objName="cacheCleaner"
    elseif (selector > 99) then
        objIndicator = 9
        objName="freeze"
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
    elseif(objName == "freeze") then
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
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
        newObject.isBullet = true
        newObject:applyLinearImpulse(-60,200)
    elseif (whereFrom == 4) then
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    end

    newObject:applyTorque( math.random( -6,6 ) )
end

return functionLivTwo