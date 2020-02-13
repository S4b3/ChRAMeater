local composer = require( "composer" )
local player = require("costanti.player")
local costantiSchermo = require ("costanti.costantiSchermo")



local safaram = {}
safaram.show = {}
safaram.life = 200
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
    safaram.show.hp = safaram.show.hp - 10
    if(safaram.show.hp <= 0 ) then
        safaram.isDead = true
        return safaram.isDead
    end
    transition.to(safaram.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () transition.to(safaram.show, {yScale = 1, xScale = 1, time = 300} ) end } )
end

local function shoot()
    local function projectileInit()
        local projectile = display.newImageRect(safaram.sceneGroup, "images/bosses/apple.png", 150, 150)
        --test
        projectile.x = safaram.show.x
        projectile.y = safaram.show.y
        --projectile:setFillColor(255, 255, 0)
        physics.addBody(projectile, "dinamic", {isSensor = true })
        projectile.isBullet = true
        projectile:toBack()
        projectile.myName ="projectile"
        return projectile
    end
    if(isPaused==true or safaram.sceneGroup == nil) then
        return
    end
    local selector = math.random(50)
    local numberOfApples
    if(selector >= 35) then
        numberOfApples = 3
    elseif(selector >=20 and selector < 35) then
        numberOfApples = 2
    else
        numberOfApples = 1
    end
    local offset = math.random(500,600)
    --local currTrans = transition.to ( projectile, { x = safaram.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
    if numberOfApples <= 3 then
        local proj1 = projectileInit()
        table.insert( currentTransitions, transition.to ( proj1, { x = safaram.target.x-offset, y = display.contentHeight , time = 1200, onComplete = function () display.remove(proj1) end}) )
        local proj2 = projectileInit()
        table.insert( currentTransitions, transition.to ( proj2, { x = safaram.target.x+offset, y = display.contentHeight , time = 1200, onComplete = function () display.remove(proj2) end}) )
        if(numberOfApples == 2) then
            return
        end
    end
    local projectile = projectileInit()
    table.insert( currentTransitions, transition.to ( projectile, { x = safaram.target.x, y = display.contentHeight , time = 1200, onComplete = function () display.remove(projectile) end}) )
end

function safaram.safariInit(target, sceneGroup)
    isPaused=false
    safaram.show = display.newImageRect(sceneGroup, "images/bosses/safari.png", 500, 500)
    safaram.show.x = display.contentCenterX
    safaram.show.y = -100
    physics.addBody(safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true })
    safaram.show.hp = 200
    safaram.show:toFront()
    safaram.show.myName = "Safari"
    table.insert(currentTransitions, transition.to(safaram.show, {time = 3000, y = 350, onComplete =
    
         function () 
            costantiSchermo.background:addEventListener( "tap" , player.shoot)
            Movements = timer.performWithDelay(800, movements, 0) end
        }) )
    
    physics.addBody( safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true})
    safaram.sceneGroup = sceneGroup
    safaram.target = target
   timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(2000, shoot, 0) end)   
  
  
 

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
    isPaused = true
    if(Movements ~= nil) then
        timer.cancel(Movements)
    end
    if(safaram.show ~= nil) then
        safaram.show:removeSelf()
    end
    if(#currentTransitions > 0) then
        for i = 1, #currentTransitions do
            transition.cancel(currentTransitions[i])
           currentTransitions[i] = nil
        end
    end
end

return safaram