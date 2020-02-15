
local composer = require( "composer" )
local buttons = require("costanti.buttons")
local scene = composer.newScene()
local sounds = require("costanti.sounds")
local widget = require( "widget" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- Initialize variables
--musica
themeSong = sounds.menuThemeSong
selectionSound = sounds.selectionSound
local lastScore

--musica
local json = require( "json" )
 
local scoresTable = {}
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local function loadScores()
    local file = io.open( filePath, "r" )
    if file then
        local contents = file:read( "*a" )
        io.close( file )
        scoresTable = json.decode( contents )
    end
    if ( scoresTable == nil or #scoresTable == 0 ) then
        scoresTable = { 0,0,0,0,0,0,0,0,0,0 }
    end
end

local function saveScores()
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	loadScores()
    -- Insert the saved score from the last game into the table, then reset it
    table.insert( scoresTable, composer.getVariable( "finalScore" ) )
    lastScore = composer.getVariable("finalScore")
    print(lastScore)
	composer.setVariable( "finalScore", 0 )
	-- Sort the table entries from highest to lowest
    local function compare( a, b )
        return a > b
    end
	table.sort( scoresTable, compare )
	saveScores()

	local background = display.newImageRect( sceneGroup, "images/highscores.jpg", display.actualContentWidth, display.actualContentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
     
	local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 200, native.systemFont, 80 )
	for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 250 + ( i * 76 )

            local fontSize = 45
            if(scoresTable[i] == lastScore ) then
                fontSize = 60
                lastScore = nil
            end
			local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, native.systemFont, fontSize )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1
            print(scoresTable[i], lastScore)
 
            local thisScore = display.newText( sceneGroup, scoresTable[i], display.contentCenterX, yPos, native.systemFont, fontSize )
            thisScore.anchorX = 0
		end
    end

    local previousScene = composer.getSceneName("previous")
    if (previousScene=="menu") then   
    elseif(composer.getVariable("died") == true ) then
        
        local retryButton = widget.newButton(
            {
                font = "SourceCodePro-SemiBold",
                labelColor = { default={ 1, 1, 1 }},
                fontSize = 70,
                id = "menu",
                label = "Retry",
                shape = "Rect",
                cornerRadius =50,
                strokeWidth = 5,
                fillColor =  { default={1,0.2,0,0.6}, over ={1,0.2,0,0.6}},
                strokeColor = { default={1,0.2,0,1}, over ={1,0.2,0,1}},
                width = 240,
                height = 110
            }
            )
        retryButton.x = display.contentCenterX
        retryButton.y = 1400
        --local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, yValue, native.systemFont, 70 )
        --menuButton:setFillColor( 0.75, 0.78, 1 )
        sceneGroup:insert(retryButton)
        --local retryButton = display.newText(sceneGroup, "Retry", display.contentCenterX, 1400, native.systemFont, 130)
        retryButton:addEventListener("tap", function () composer.gotoScene(composer.getSceneName("previous")) end )
    else
        if(previousScene == "levels.liv4.liv4") then
            return
        end
        local nextLevelButton = widget.newButton(
            {
                font = "SourceCodePro-SemiBold",
                labelColor = { default={ 1, 1, 1 }},
                fontSize = 70,
                id = "menu",
                label = "Next Level",
                shape = "Rect",
                cornerRadius =50,
                strokeWidth = 5,
                fillColor =  { default={1,0.2,0,0.6}, over ={1,0.2,0,0.6}},
                strokeColor = { default={1,0.2,0,1}, over ={1,0.2,0,1}},
                width = 450,
                height = 110
            }
            )
        nextLevelButton.x = display.contentCenterX
        nextLevelButton.y = 1400
        --local nextLevelButton = display.newText(sceneGroup, "Next Level", display.contentCenterX, 1400, native.systemFont, 130)
        sceneGroup:insert(nextLevelButton)
        nextLevelButton:addEventListener("tap", function ()
            local nextScene
            if(previousScene == "levels.liv1.liv1") then
                nextScene = "levels.liv2.liv2"
            elseif(previousScene == "levels.liv2.liv2") then
                nextScene = "levels.liv3.liv3"
            elseif(previousScene == "levels.liv3.liv3") then
                nextScene = "levels.liv4.liv4"
            end
            composer.gotoScene(nextScene)
        end )
    end
	buttons.goToMenuInit(sceneGroup, 1200)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- chiamata quando la scena è ancora spenta e sta per essere mostrata
	elseif phase == "did" then
		-- chiamata quando la scena è già sullo schermo
		audio.play( themeSong, { channel=1, loops=-1 } )
	end	
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.setVariable("died" , false)
        composer.removeScene( "highscores")
        audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    --audio.dispose( themeSong )
	--audio.dispose( selectionSound )
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene