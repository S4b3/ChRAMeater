local costantiOggetti = require("costanti.costantiOggetti")
local ramzilla = require("levels.boss.ramzilla")
local player = require("costanti.player")
local functionLivOne = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

local isStopped = false
-------------------------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI-----------------------------------------------------
function functionLivOne.stopCreating()
    isStopped = true
end

function functionLivOne.startCreating()
    isStopped = false
end

function functionLivOne.spawnBoss(sceneGroup)
    ramzilla.ramzillaInit(player.playerChram, sceneGroup)
    isStopped = true
end

function functionLivOne.removeBoss()
    ramzilla.ramzillaRemove()
    isStopped = false
end

function functionLivOne.createObjects(mainGroup,objectSheet,objTable)
    if(isStopped) then
        return
    end

    local selector = math.random ( 100 )
    local objIndicator
    local objName

    if(selector <= 50) then
        objIndicator = 4
        objName="ram2GB"
    elseif (selector > 50 and selector <= 60) then
        objIndicator = 3
        objName="ram8GB"
    elseif (selector >= 60 and selector <= 98) then
        objIndicator = 1
        objName="cacheCleaner"
    elseif ( selector > 98 ) then
        objIndicator =  5
        objName = "powerUpOnda"
    end
    if(mainGroup==nil or objectSheet==nil) then
        return end
    local newObject = display.newImage( mainGroup, objectSheet, objIndicator)
    newObject:toBack()
    newObject:scale(0.25, 0.25)
    table.insert( objTable, newObject )

    --{ radius=(newObject.contentWidth/2, newObject.contentHeight/2), bounce=0.8 }
    if(objName=="ram2GB") then
        physics.addBody( newObject, "dynamic", { shape = smallRamShape } )
    elseif(objName=="ram8GB") then
        physics.addBody( newObject, "dynamic", { shape = bigRamShape } )
    elseif(objName == "powerUpOnda") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    elseif(objName=="cacheCleaner") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    elseif(objName=="life") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    end
    newObject.myName = objName

    local whereFrom = math.random( 4 )

    if ( whereFrom == 1 ) then
        -- From the left
        newObject.x = -60
        newObject.y = math.random( 500 )
        --newObject:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
        newObject:setLinearVelocity( math.random( 80,160 ), math.random( 40,70 ) )
    elseif ( whereFrom == 2 or whereFrom == 4) then
        -- From the top
        newObject.x = math.random( display.contentWidth )
        newObject.y = 0
        --newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
        newObject:setLinearVelocity( math.random( -110,110 ), math.random( 120,360 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newObject.x = display.contentWidth + 60
        newObject.y = math.random( 500 )
        --newObject:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
        newObject:setLinearVelocity( math.random( -160,-80 ), math.random( 40,70 ) )
    end

    newObject:applyTorque( math.random( -6,6 ) )
end

return functionLivOne