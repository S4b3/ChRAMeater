local composer = require( "composer" )

local safeari = {}
safeari.show = {}
safeari.life = 100

local function movements()
    transition.to(safeari.show, {time=800, x = math.random(0,display.contentWidth), y= math.random(350, 500)})
end

local function shoot()
    local projectile = display.newImageRect(safeari.sceneGroup, "images/bosses/safari.png", 100, 100)
    projectile.x = safeari.show.x
    projectile.y = safeari.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    transition.to ( projectile, { x = safeari.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
end
function safeari.safariInit(target, sceneGroup)
    safeari.show = display.newImageRect(sceneGroup, "images/bosses/safari.png", 500, 500)
    safeari.show.x = display.contentCenterX
    safeari.show.y = -100
    safeari.show:toFront()
    safeari.myName = "Safari"
    transition.to(safeari.show, {time = 3000, y = 350, onComplete =
         function () Movements = timer.performWithDelay(800, movements, 0) end
        })
    
    physics.addBody( safeari.show, {radius = safeari.show.contentHeight/2, isSensor = true})
    safeari.sceneGroup = sceneGroup
    safeari.target = target
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(600, shoot, 0) end)
end
function safeari.safariRemove()
    timer.cancel(ShootTimer)
    timer.cancel(Movements)
    safeari.show:removeSelf()
end

return safeari