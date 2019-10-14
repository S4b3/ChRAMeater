local costantiOggetti = require("costanti.costantiOggetti")
local functionLivOne = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

-------------------------------------------------------FUNZIONI NECESSARIE PER I VARI LIVELLI-----------------------------------------------------
function functionLivOne.createObjects(mainGroup,objectSheet,objTable)
    local selector = math.random ( 100 )
    local objIndicator
    local objName

    if(selector <= 50) then
        objIndicator = 4
        objName="ram2GB"
    elseif (selector > 50 and selector <= 60) then
        objIndicator = 3
        objName="ram8GB"
    elseif (selector >= 60) then
        objIndicator = 1
        objName="cacheCleaner"
    end
    if(mainGroup==nil or objectSheet==nil) then
        return end
    local newObject = display.newImage( mainGroup, objectSheet, objIndicator)
    newObject:scale(0.2, 0.2)
    table.insert( objTable, newObject )

    --{ radius=(newObject.contentWidth/2, newObject.contentHeight/2), bounce=0.8 }
    if(objName=="ram2GB") then
        physics.addBody( newObject, "dynamic", { shape = smallRamShape } )
    elseif(objName=="ram8GB") then
        physics.addBody( newObject, "dynamic", { shape = bigRamShape } )
    elseif(objName=="cacheCleaner") then
        physics.addBody( newObject, "dynamic", { radius = (newObject.contentHeight/2)} )
    end
    newObject.myName = objName

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- From the left
        newObject.x = -60
        newObject.y = math.random( 500 )
        --newObject:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
        newObject:setLinearVelocity( math.random( 80,160 ), math.random( 40,70 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newObject.x = math.random( display.contentWidth )
        newObject.y = -60
        --newObject:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
        newObject:setLinearVelocity( math.random( -70,70 ), math.random( 80,160 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newObject.x = display.contentWidth + 60
        newObject.y = math.random( 500 )
        --newObject:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
        newObject:setLinearVelocity( math.random( -160,-80 ), math.random( 40,70 ) )
    end

    newObject:applyTorque( math.random( -6,6 ) )
end

function functionLivOne.gameLoop(mainGroup,objectSheet,objTable)
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

return functionLivOne