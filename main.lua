-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )

local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )

math.randomseed( os.time() )

local sheetOptions = {

    frames =
    {
        { -- cache cleaner
            x = 0, 
            y = 0,
            width = 512,
            height = 512
        },
        {-- chrome
            x = 0,
            y = 512,
            width = 512,
            height = 512
        },
        {--ram big!
            x = 0,
            y = 1024,
            width = 512,
            height = 512
        },
        {--ram comune
            x = 0,
            y = 1536,
            width = 512,
            height = 512
        },
    },

}

local objectSheet = graphics.newImageSheet("GameObjects.png", sheetOptions)

local lives = 3
local score = 0
local died = false

local ramTable = {}

local cache
local playerChrome
local livesText
local scoreText

local backGroup = display.newGroup()
local mainGroup = display.newGroup()
local uiGroup = display.newGroup()

local background = display.newImageRect( backGroup, "background.jpg", 828, 1729)
background.x = display.contentCenterX
background.y = display.contentCenterY

playerChrome = display.newImageRect(mainGroup, objectSheet, 2, 120, 120)
playerChrome.x = display.contentCenterX
playerChrome.y = display.contentHeight - 150
physics.addBody( playerChrome, { radius=30, isSensor=true } )
playerChrome.myName = "Chrome"

livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
scoreText = display.newText( uiGroup, "Score: " .. score, 400, 80, native.systemFont, 36 )

local function updateText()
    livesText.text = "Lives: " .. lives
    scoreText.text = "Score: " .. score
end

local function createRam()
    
    local newRam = display.newImageRect( mainGroup, objectSheet, 4, 102, 102 )
    table.insert( ramTable, newRam )
    physics.addBody( newRam, "dynamic", { radius=40, bounce=0.8 } )
    newRam.myName = "RamCommon"

    local whereFrom = math.random( 3 )

    if ( whereFrom == 1 ) then
        -- From the left
        newRam.x = -60
        newRam.y = math.random( 500 )
        newRam:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
    elseif ( whereFrom == 2 ) then
        -- From the top
        newRam.x = math.random( display.contentWidth )
        newRam.y = -60
        newRam:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
    elseif ( whereFrom == 3 ) then
        -- From the right
        newRam.x = display.contentWidth + 60
        newRam.y = math.random( 500 )
        newRam:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
    end

    newRam:applyTorque( math.random( -6,6 ) )
end




local function gameLoop()
    createRam()
 
    -- Remove asteroids which have drifted off screen
    for i = #ramTable, 1, -1 do
        local thisRam = ramTable[i]
 
        if ( thisRam.x < -100 or
             thisRam.x > display.contentWidth + 100 or
             thisRam.y < -100 or
             thisRam.y > display.contentHeight + 100 )
        then
            display.remove( thisRam )
            table.remove( ramTable, i )
        end
 
    end
 
end

gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
