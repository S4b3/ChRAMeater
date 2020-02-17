local composer = require( "composer" )
local player = require("costanti.player")
local costantiSchermo = require ("costanti.costantiSchermo")

local edgram = {}
edgram.show = {}
edgram.isDead = false

local isPaused
local currentTransitions = {}

local function movements()
    if(isPaused==true) then
        return
    end
    table.insert( currentTransitions, transition.to(edgram.show, {time=800, x = edgram.target.x, y= math.random(100, 500)}) )
end

function edgram.onHit()
    if(edgram.isDead) then
        return
    end
    edgram.show.hp = edgram.show.hp - 10
    if(edgram.show.hp <= 0 ) then
        edgram.isDead = true
        return edgram.isDead
    end
    transition.to(edgram.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () transition.to(edgram.show, {yScale = 1, xScale = 1, time = 300} ) end } )
end

local function shoot()
    local function projectileInit()
        local projectile = display.newImageRect(edgram.sceneGroup, "images/bosses/microsoft.png", 150, 150)
        --test
        projectile.x = edgram.show.x
        projectile.y = edgram.show.y
        --projectile:setFillColor(255, 255, 0)
        physics.addBody(projectile, "dinamic", {isSensor = true })
        projectile.isBullet = true
        projectile:toBack()
        projectile.myName ="projectile"
        return projectile
    end
    if(isPaused==true or edgram.sceneGroup == nil) then
        return
    end
    local selector = math.random(50)
    local numberOfWindows
    if(selector >= 35) then
        numberOfWindows = 3
    elseif(selector >=20 and selector < 35) then
        numberOfWindows = 2
    else
        numberOfWindows = 1
    end
    local offset = math.random(500,600)
    --local currTrans = transition.to ( projectile, { x = edgram.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
    if numberOfWindows <= 3 then
        local proj1 = projectileInit()
        table.insert( currentTransitions, transition.to ( proj1, { x = edgram.target.x-offset, y = display.contentHeight , time = 1200, onComplete = function () display.remove(proj1) end}) )
        local proj2 = projectileInit()
        table.insert( currentTransitions, transition.to ( proj2, { x = edgram.target.x+offset, y = display.contentHeight , time = 1200, onComplete = function () display.remove(proj2) end}) )
        if(numberOfWindows == 2) then
            return
        end
    end
    local projectile = projectileInit()
    table.insert( currentTransitions, transition.to ( projectile, { x = edgram.target.x, y = display.contentHeight , time = 1200, onComplete = function () display.remove(projectile) end}) )
end

function edgram.edgramInit(target, sceneGroup)
    isPaused=false
    edgram.show = display.newImageRect(sceneGroup, "images/bosses/edge1.png", 500, 500)
    edgram.show.x = display.contentCenterX
    edgram.show.y = -100
    physics.addBody(edgram.show, {radius = edgram.show.contentHeight/2, isSensor = true })
    edgram.show.hp = 150
    edgram.show:toFront()
    edgram.show.myName = "Edgram"
    table.insert(currentTransitions, transition.to(edgram.show, {time = 3000, y = 350, onComplete =
    
         function () 
            costantiSchermo.background:addEventListener( "tap" , player.shoot)
            Movements = timer.performWithDelay(400, movements, 0) end
        }) )
    
    physics.addBody( edgram.show, {radius = edgram.show.contentHeight/2, isSensor = true})
    edgram.sceneGroup = sceneGroup
    edgram.target = target
   timer.performWithDelay(2000, function () ShootTimer = timer.performWithDelay(1200, shoot, 0) end)   
  
  
 

end

function edgram.pause()
    isPaused=true
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.pause(trans)
        end
    end
end

function edgram.resume()
    isPaused=false
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.resume(trans)
        end
    end
end

function edgram.edgramRemove()
    if(ShootTimer ~= nil ) then
        timer.cancel(ShootTimer)
    end
    isPaused = true
    if(Movements ~= nil) then
        timer.cancel(Movements)
    end
    if(edgram.show ~= nil) then
        edgram.show:removeSelf()
    end
    if(#currentTransitions > 0) then
        for i = 1, #currentTransitions do
            transition.cancel(currentTransitions[i])
           currentTransitions[i] = nil
        end
    end
end

return edgram