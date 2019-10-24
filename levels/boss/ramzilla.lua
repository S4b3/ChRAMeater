local composer = require( "composer" )

local ramzilla = {}
ramzilla.show = {}

local function movements()
    transition.to(ramzilla.show, {time = 800, x = math.random(0, display.contentWidth), y = math.random(350, 500), onComplete = movements})
end


local function shoot()
    local projectile = display.newRect(ramzilla.sceneGroup, ramzilla.show.x, ramzilla.show.y, 20, 60)
    projectile:setFillColor(255, 255, 0)
    physics.addBody(projectile, "dinamic", {isSensor = true })
    projectile.isBullet = true
    projectile:toBack()
    transition.to ( projectile, { x = ramzilla.target.x, y = display.contentHeight , time = 1000, onComplete = function () display.remove(projectile) end})
end

function ramzilla.ramzillaInit(target, sceneGroup)
    ramzilla.show = display.newImageRect(sceneGroup, "images/bosses/firefox.png", 500, 500)
    ramzilla.show.x = display.contentCenterX
    ramzilla.show.y = -100
    ramzilla.show:toFront()
    physics.addBody( ramzilla.show, {radius = ramzilla.show.contentHeight/2, isSensor = true})
    ramzilla.myName = "Ramzilla"
    transition.to(ramzilla.show, {time = 3000, y = 350})
    timer.performWithDelay(3000, movements())
    ramzilla.sceneGroup = sceneGroup
    ramzilla.target = target
    ShootTimer = timer.performWithDelay(500, shoot, 0)
    
end

return ramzilla