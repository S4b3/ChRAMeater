local composer = require( "composer" )
local player = require("costanti.player")
local costantiSchermo = require ("costanti.costantiSchermo")



local safaram = {}
safaram.show = {}
safaram.life = 10
safaram.isDead = false

local isPaused
local currentTransitions = {}

local function movements()
    if(isPaused==true) then
        return
    end
    table.insert( currentTransitions, transition.to(safaram.show, {time=800, x = safaram.target.x, y= math.random(100, 500)}) )
end

function safaram.onHit()
    if(safaram.isDead) then
        return
    end
    safaram.show.hp = safaram.show.hp - 5
    if(safaram.show.hp <= 0 ) then
        safaram.isDead = true
        return safaram.isDead
    end
    transition.to(safaram.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () transition.to(safaram.show, {yScale = 1, xScale = 1, time = 300} ) end } )
end

local function shoot()
    if(isPaused==true) then
        return
    end
    local projectile = display.newImageRect(safaram.sceneGroup, "images/bosses/apple.png", 150, 150)
    --test
    projectile.x = safaram.show.x
    projectile.y = safaram.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    --local currTrans = transition.to ( projectile, { x = safaram.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
    table.insert( currentTransitions, transition.to ( projectile, { x = math.random(1000), y = display.contentHeight , time = 1200, onComplete = function () display.remove(projectile) end}) )
end

function safaram.safariInit(target, sceneGroup)
    isPaused=false
    safaram.show = display.newImageRect(sceneGroup, "images/bosses/safari.png", 500, 500)
    safaram.show.x = display.contentCenterX
    safaram.show.y = -100
    physics.addBody(safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true })
    safaram.show.hp = 10
    safaram.show:toFront()
    safaram.myName = "Safari"
    transition.to(safaram.show, {time = 3000, y = 350, onComplete =
    
         function () 
            costantiSchermo.background:addEventListener( "tap" , player.shoot)
            Movements = timer.performWithDelay(800, movements, 0) end
        })
    
    physics.addBody( safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true})
    safaram.sceneGroup = sceneGroup
    safaram.target = target
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(2000, shoot, 0) end)   
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(2412, shoot, 0) end)    
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(2424, shoot, 0) end)  
  
 

end

function safaram.pause()
    isPaused=true
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.pause(trans)
        end
    end
end

function safaram.resume()
    isPaused=false
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.resume(trans)
        end
    end
end

function safaram.safariRemove()
    if(ShootTimer ~= nil ) then
        timer.cancel(ShootTimer)
    end
    timer.cancel(Movements)
    safaram.show:removeSelf()
end

return safaram