local composer = require( "composer" )
local player = require("costanti.player")


local safaram = {}
safaram.show = {}
safaram.life = 100
safaram.isDead = false


local function movements()
    transition.to(safaram.show, {time=800, x = math.random(0,display.contentWidth), y= math.random(350, 500)})
end
function safaram.onHit()
    if(safaram.isDead) then
        return
    end
    print("hit!")
    safaram.show.hp = safaram.show.hp - 5
    print(safaram.show.hp)
    if(safaram.show.hp <= 0 ) then
        safaram.isDead = true
        return safaram.isDead
    end
    transition.to(safaram.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () transition.to(safaram.show, {yScale = 1, xScale = 1, time = 300} ) end } )
end
local function shoot()
    local projectile = display.newImageRect(safaram.sceneGroup, "images/bosses/safari.png", 100, 100)
    projectile.x = safaram.show.x
    projectile.y = safaram.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    transition.to ( projectile, { x = safaram.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
end
function safaram.safariInit(target, sceneGroup)
    safaram.show = display.newImageRect(sceneGroup, "images/bosses/safari.png", 500, 500)
    safaram.show.x = display.contentCenterX
    safaram.show.y = -100
    physics.addBody(safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true })
    safaram.show.hp = 10
    safaram.show:toFront()
    safaram.myName = "Safari"
    transition.to(safaram.show, {time = 3000, y = 350, onComplete =
    
         function () 
            player.playerChram:addEventListener( "tap" , player.shoot)
            Movements = timer.performWithDelay(800, movements, 0) end
        })
    
    physics.addBody( safaram.show, {radius = safaram.show.contentHeight/2, isSensor = true})
    safaram.sceneGroup = sceneGroup
    safaram.target = target
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(600, shoot, 0) end)
end
function safaram.safariRemove()
    if(ShootTimer ~= nil ) then
        timer.cancel(ShootTimer)
    end
    timer.cancel(Movements)
    safaram.show:removeSelf()
end

return safaram