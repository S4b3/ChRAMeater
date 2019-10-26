local composer = require( "composer" )

local ramzilla = {}
ramzilla.show = {}
ramzilla.life = 100

local function movements()
    transition.to(ramzilla.show, {time = 800, x = math.random(0, display.contentWidth), y = math.random(350, 500)})
end
function ramzilla.onHit()
    print("hit!")
    ramzilla.show.hp = ramzilla.show.hp - 5
    print(ramzilla.show.hp)
    if(ramzilla.show.hp <= 0 ) then
        return true
    end
    transition.to(ramzilla.show, {yScale = 1.1, xScale = 1.1, time = 300, onComplete = function () transition.to(ramzilla.show, {yScale = 1, xScale = 1, time = 300} ) end } )
end
local function shoot()
    local projectile = display.newImageRect(ramzilla.sceneGroup, "images/bosses/thunderbird.png", 100, 100)
    projectile.x = ramzilla.show.x
    projectile.y = ramzilla.show.y
    --projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    projectile.myName ="projectile"
    transition.to ( projectile, { x = ramzilla.target.x, y = display.contentHeight , time = 1400, onComplete = function () display.remove(projectile) end})
end

function ramzilla.ramzillaInit(target, sceneGroup)
    ramzilla.show = display.newImageRect(sceneGroup, "images/bosses/firefox.png", 500, 500)
    ramzilla.show.x = display.contentCenterX
    ramzilla.show.y = -100
    ramzilla.show.hp = 10
    ramzilla.show:toFront()
    ramzilla.show.myName = "Ramzilla"
    transition.to(ramzilla.show, {time = 3000, y = 350, onComplete =
         function () 
            physics.addBody(ramzilla.show, {radius = ramzilla.show.contentHeight/2, isSensor = true })
            Movements = timer.performWithDelay(800, movements, 0) end
    })
    physics.addBody( ramzilla.show, {radius = ramzilla.show.contentHeight/2, isSensor = true})
    ramzilla.sceneGroup = sceneGroup
    ramzilla.target = target
    timer.performWithDelay(4000, function () ShootTimer = timer.performWithDelay(600, shoot, 0) end)
end
function ramzilla.ramzillaRemove()
    timer.cancel(ShootTimer)
    timer.cancel(Movements)
    ramzilla.show:removeSelf()
end

return ramzilla