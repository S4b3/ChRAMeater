local composer = require( "composer" )

local safari = {}
safari.show = {}
safari.life = 100

local function movements()
    transition.to(safari.show, {time=800, x = math.random(0,display.contentWidth), y= math.random(350, 500)})
end

local function shoot()
    local projectile = display.newImageRect(safari.sceneGroup, "images/bosses/safari.png", 100, 100)
    projectile.x = safari.show.x
    projectile.y = safari.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    transition.to ( projectile, { x = safari.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
end
function safari.safariInit(target, sceneGroup)
    safari.show = display.newImageRect(sceneGroup, "images/bosses/safari.png", 500, 500)
    safari.show.x = display.contentCenterX
    safari.show.y = -100
    safari.show:toFront()
    safari.myName = "Safari"
    transition.to(safari.show, {time = 3000, y = 350, onComplete =
         function () Movements = timer.performWithDelay(800, movements, 0) end
        })
    
    physics.addBody( safari.show, {radius = safari.show.contentHeight/2, isSensor = true})
    safari.sceneGroup = sceneGroup
    safari.target = target
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(600, shoot, 0) end)
end
function safari.safariRemove()
    timer.cancel(ShootTimer)
    timer.cancel(Movements)
    safari.show:removeSelf()
end

return safari