local player = require("costanti.player")
local costantiSchermo = require("costanti.costantiSchermo")

local tor = {}
tor.show = {}
tor.isDead = false

local isPaused
local currentTransitions ={}

local function randomSelector(arg1, arg2, arg3)
    local selector =  math.random(1,3)
    timing = {
        [1] = function () return arg1 end,
        [2] = function () return arg2 end,
        [3] = function () return arg3 end,
      }
    return timing[selector]()
end

local function movements()
    if(isPaused==true) then
        return
    end
    table.insert(currentTransitions ,transition.to(tor.show, {time = 250, x = math.random(0, display.contentWidth), y = math.random(100, 900)}))
    timer.performWithDelay(randomSelector(200,400,600),movements)
end

function tor.onHit()
    if(tor.isDead) then
        return
    end
    tor.show.hp = tor.show.hp - 20
    if(tor.show.hp <= 0 ) then
        tor.isDead = true
        return tor.isDead
    end
    transition.to(tor.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () table.insert(currentTransitions, transition.to(tor.show, {yScale = 1, xScale = 1, time = 300} ) ) end } )
end

local function projectileInit(shootingSpeed)
    local projectile = display.newImageRect(tor.sceneGroup, "images/bosses/onion.png", 100, 100)
    projectile.x = tor.show.x
    projectile.y = tor.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    table.insert(currentTransitions, transition.to ( projectile, { x = tor.target.x, y = display.contentHeight , time = shootingSpeed, onComplete = function () display.remove(projectile) end}))
end

local function shoot()
  if(isPaused==true or tor.sceneGroup == nil) then
        return
    end

    local shootingSpeed = math.random(400,1500)
    projectileInit(shootingSpeed)
    timer.performWithDelay(randomSelector(200,400,600),shoot)
end

function tor.torInit(target, sceneGroup)
    isPaused=false
    tor.isDead = false
    tor.show = display.newImageRect(sceneGroup, "images/bosses/tor.png", 500, 500)
    tor.show.x = display.contentCenterX
    tor.show.y = -100
    physics.addBody(tor.show, {radius = tor.show.contentHeight/2-100, isSensor = true })
    tor.show.hp = 500
    tor.show:toFront()
    tor.show.myName = "Tor"
    table.insert(currentTransitions, transition.to(tor.show, {time = 3000, y = 350, onComplete =
         function ()
            costantiSchermo.background:addEventListener( "touch" , player.shoot)
            Movements = timer.performWithDelay(randomSelector(200,400,600), movements)
            ShootTimer = timer.performWithDelay(randomSelector(200,400,600), shoot) 
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