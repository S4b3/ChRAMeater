local player = require("costanti.player")
local costantiSchermo = require("costanti.costantiSchermo")

local tor = {}
tor.show = {}
tor.isDead = false

local isPaused
local currentTransitions ={}

local function movements()
    if(isPaused==true) then
        return
    end
    table.insert(currentTransitions ,transition.to(tor.show, {time = 800, x = math.random(0, display.contentWidth), y = math.random(350, 500)}))
end
function tor.onHit()
    if(tor.isDead) then
        return
    end
    tor.show.hp = tor.show.hp - 10
    if(tor.show.hp <= 0 ) then
        tor.isDead = true
        return tor.isDead
    end
    transition.to(tor.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () table.insert(currentTransitions, transition.to(tor.show, {yScale = 1, xScale = 1, time = 300} ) ) end } )
end
local function shoot()
  if(isPaused==true or tor.sceneGroup == nil) then
        return
    end
    local projectile = display.newImageRect(tor.sceneGroup, "images/bosses/onion.png", 100, 100)
    projectile.x = tor.show.x
    projectile.y = tor.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    table.insert(currentTransitions, transition.to ( projectile, { x = tor.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end}))
end

function tor.torInit(target, sceneGroup)
    isPaused=false
    tor.isDead = false
    tor.show = display.newImageRect(sceneGroup, "images/bosses/tor.png", 500, 500)
    tor.show.x = display.contentCenterX
    tor.show.y = -100
    physics.addBody(tor.show, {radius = tor.show.contentHeight/2-100, isSensor = true })
    tor.show.hp = 100
    tor.show:toFront()
    tor.show.myName = "Tor"
    table.insert(currentTransitions, transition.to(tor.show, {time = 3000, y = 350, onComplete =
         function ()
            costantiSchermo.background:addEventListener( "tap" , player.shoot)
            Movements = timer.performWithDelay(800, movements, 0)
            ShootTimer = timer.performWithDelay(600, shoot, 0) 
            print(ShootTimer)
        end
    }) )
    physics.addBody( tor.show, {radius = tor.show.contentHeight/2-100, isSensor = true}) 
    tor.sceneGroup = sceneGroup
    tor.target = target
end

function tor.pause()
    isPaused=true
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.pause(trans)
        end
    end
end

function tor.resume()
    isPaused=false
    for i = #currentTransitions, 1, -1 do
        local trans = currentTransitions[i]
        if (trans ~= nil) then
            transition.resume(trans)
        end
    end
end
function tor.torRemove()
    if(ShootTimer ~= nil) then
        timer.cancel(ShootTimer)
    end
    isPaused = true
    if(Movements ~= nil) then
        timer.cancel(Movements)
    end
    if(tor.show ~= nil) then
        tor.show:removeSelf()
    end
    if(#currentTransitions > 0) then
        for i = 1, #currentTransitions do
            transition.cancel(currentTransitions[i])
           currentTransitions[i] = nil
        end
    end
end

return tor