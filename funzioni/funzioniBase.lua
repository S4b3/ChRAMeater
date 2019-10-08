local composer = require( "composer" )
local costantiOggetti = require("costanti.costantiOggetti")
local funzioniBase = {}

local bigRamShape = costantiOggetti.getBigRamShape();
local smallRamShape = costantiOggetti.getSmallRamShape();

local died = costantiOggetti.isDead();
local lives = costantiOggetti.getLives();

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )








local function updateLives()
    if ( died == false ) then
        died = true
        -- Update lives
        costanti.setLives(lives - 1)
        livesText.text = "Lives: " .. costanti.getLives()
        if ( lives == 0 ) then
			display.remove( playerChram )
			timer.performWithDelay( 2000, funzioniBase.endGame(score) )
        else
            playerChram.alpha = 0
            playerChram.isBodyActive = false
            funzioniBase.restorePlayerCharm(playerChram)
            playerChram.isBodyActive = true
        end
    end
end




function funzioniBase.dragplayerChram( event )
    local playerChram = event.target
    local phase = event.phase
    if ( "began" == phase ) then
        -- Set touch focus on playerChram
        display.currentStage:setFocus( playerChram )
        playerChram.touchOffsetX = event.x - playerChram.x
        playerChram.touchOffsetY = event.y - playerChram.y
    elseif ( "moved" == phase ) then
        -- Move playerChram to the new touch position
        playerChram.x = event.x - playerChram.touchOffsetX
        playerChram.y = event.y - playerChram.touchOffsetY
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on playerChram
        display.currentStage:setFocus( nil )
    end
    return true 
end

--per liv 1
function funzioniBase.createObjectsLiv1(mainGroup,objectSheet,objTable)
    
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

function funzioniBase.removeFromTable(obj,objTable)
    for i = #objTable, 1, -1 do
        if ( objTable[i] == obj ) then
            table.remove( objTable, i )
            break
        end
    end
end

function funzioniBase.restorePlayerCharm(playerChram)
    playerChram.x = display.contentCenterX
    playerChram.y = display.contentHeight - 100
 
    -- Fade in the playerChram
    physics.removeBody(playerChram)
    transition.to( playerChram, { alpha=1, time=4000,
        onComplete = function()
            playerChram.isBodyActive = true
            physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
            died = false --non serve se lo sposto
        end
    } )
end

function funzioniBase.resizeChram(playerChram)
    if(playerChram.contentWidth == nil or playerChram.contentHeight == nil) then
        return end
    playerChram : scale(1.009, 1.009)
    --transition.to(playerChram, {xScale = playerChram.contentWidth/117, yScale = playerChram.contentHeight/117})
    timer.performWithDelay(1)
    physics.removeBody(playerChram)
    physics.addBody( playerChram, { radius=playerChram.contentHeight/2, isSensor=true } )
end

function funzioniBase.gameLoop(mainGroup,objectSheet,objTable)
    funzioniBase.createObjectsLiv1(mainGroup,objectSheet,objTable)
 
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

function funzioniBase.endGame(score)
    --composer.gotoScene( "menu", { time=800, effect="crossFade" } )
    composer.setVariable( "finalScore", score )
    composer.gotoScene( "highscores", { time=800, effect="crossFade" } )
end

return funzioniBase