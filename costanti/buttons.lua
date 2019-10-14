local widget = require "widget"

local buttons = {}
buttons.musicButton = {}
buttons.musicButton.show = {}
buttons.effectsButton = {}
buttons.effectsButton.show = {}
buttons.buttonsMenu = {}
buttons.buttonsMenu.show = {}
buttons.buttonsMenu.closeMenuButton = {}
buttons.buttonsMenu.closeMenuButton.show = {}

function buttons.onMusicTapEffect(button)
    if(not button.pressed) then
        audio.setVolume(0, { channel = 1 } )
    else
        audio.setVolume(0.5, { channel = 1 })
    end
end

function buttons.onEffectsTapEffect(button)
    if(not button.pressed) then
        audio.setVolume(0, { channel = 2 } )
    else
        audio.setVolume(0.5, { channel = 2 })
    end
end

function buttons.onCloseMenuTapEffect(button)
    if(buttons.effectsButton.show.x == nil) then
        buttons.effectsButton.show.x = display.contentWidth - 40
    end
    if(buttons.musicButton.show.x == nil) then
        buttons.musicButton.show.x = display.contentWidth - 40
    end
    if(button.pressed) then
        transition.to(buttons.buttonsMenu.show, {time = 200, x = buttons.buttonsMenu.show.x - 200})
        transition.to(buttons.musicButton.show, {time = 200, x = buttons.musicButton.show.x - 200})
        transition.to(buttons.effectsButton.show, {time = 200, x = buttons.effectsButton.show.x - 200})
        transition.to(button, {rotation=180, time = 200, x = button.x - 160})
        buttons.buttonsMenu.closeMenuButton.pressed = true
    else
        transition.to(buttons.buttonsMenu.show, {time = 200, x = buttons.buttonsMenu.show.x + 200})
        transition.to(buttons.musicButton.show, {time = 200, x = buttons.musicButton.show.x + 200})
        transition.to(buttons.effectsButton.show, {time = 200, x = buttons.effectsButton.show.x + 200})
        transition.to(button, {rotation=0, time = 200, x = button.x + 160})
        buttons.buttonsMenu.closeMenuButton.pressed = false
        end
end

function buttons.buttonSwitcheroo(button, target)
    button.x = target.x
    button.y = target.y
    button.imageIfTapped = target.imageIfTapped
    button.imageIfNotTapped = target.imageIfNotTapped
    button.onTapEffect = target.onTapEffect
    button.name = target.name
    button:addEventListener("tap", buttons.onSwappableTap)
    target:removeSelf()
end

function buttons.onNonSwappableTap(event)
    event.target.pressed = not event.target.pressed
    event.target.onTapEffect(event.target)
end

function buttons.onSwappableTap(event)

    if(event.target.name == "musicButton") then
        if(buttons.musicButton.show.pressed) then
            buttons.musicButton.show = display.newImageRect(buttons.musicButton.show.imageIfNotTapped, 100, 100)
            buttons.musicButton.show.pressed = false
        else
            buttons.musicButton.show = display.newImageRect(buttons.musicButton.show.imageIfTapped, 100, 100)
            buttons.musicButton.show.pressed = true
        end
        buttons.buttonSwitcheroo(buttons.musicButton.show, event.target)
    elseif(event.target.name == "effectsButton") then
        if(buttons.effectsButton.show.pressed) then
            buttons.effectsButton.show = display.newImageRect(buttons.effectsButton.show.imageIfNotTapped, 100, 100)
            buttons.effectsButton.show.pressed = false
        else
            buttons.effectsButton.show = display.newImageRect(buttons.effectsButton.show.imageIfTapped, 100, 100)
            buttons.effectsButton.show.pressed = true
        end
        buttons.buttonSwitcheroo(buttons.effectsButton.show, event.target)
    end
    event.target.onTapEffect(event.target)
end

function buttons.buttonsInit()
    buttons.buttonsMenu.show = display.newImageRect("images/buttons/buttonsMenu.png", 300, 300)
    buttons.buttonsMenu.show.x = display.contentWidth + 140
    buttons.buttonsMenu.show.y = display.contentCenterY-650

    buttons.buttonsMenu.closeMenuButton.show = display.newImageRect("images/buttons/closeMenuButton.png", 40, 100)
    buttons.buttonsMenu.closeMenuButton.show.x = buttons.buttonsMenu.show.x-160
    buttons.buttonsMenu.closeMenuButton.show.y = buttons.buttonsMenu.show.y/2+100 --+ 120
    buttons.buttonsMenu.closeMenuButton.show.pressed = false

    buttons.buttonsMenu.closeMenuButton.show:addEventListener("tap", buttons.onNonSwappableTap)
    buttons.buttonsMenu.closeMenuButton.show.onTapEffect = buttons.onCloseMenuTapEffect
    buttons.buttonsMenu.closeMenuButton.show.name = "closeMenuButton"


    --buttons.buttonsMenu.closeMenuButton.show:rotate(180)
    --timer.performWithDelay(10000, transition.to( buttons.buttonsMenu.closeMenuButton.show, { rotation=180, time=200, transition=easing.inOutCubic } ) )

    buttons.musicButton.show = display.newImageRect("images/buttons/musicIcon.png", 100, 100)
    buttons.musicButton.show.x = display.contentWidth + 140
    buttons.musicButton.show.y = display.contentCenterY -700
    buttons.musicButton.show.imageIfTapped = "images/buttons/musicIconDisabled.png"
    buttons.musicButton.show.imageIfNotTapped = "images/buttons/musicIcon.png"
    buttons.musicButton.show.pressed = false
    buttons.musicButton.show:addEventListener("tap", buttons.onSwappableTap)
    buttons.musicButton.show.onTapEffect = buttons.onMusicTapEffect
    buttons.musicButton.show.name = "musicButton"

    buttons.effectsButton.show = display.newImageRect("images/buttons/audioIcon.png", 100, 100)
    buttons.effectsButton.show.x = display.contentWidth + 140
    buttons.effectsButton.show.y = display.contentCenterY -600
    buttons.effectsButton.show.imageIfTapped = "images/buttons/audioIconDisabled.png"
    buttons.effectsButton.show.imageIfNotTapped = "images/buttons/audioIcon.png"
    buttons.effectsButton.show.pressed = false
    buttons.effectsButton.show:addEventListener("tap", buttons.onSwappableTap)
    buttons.effectsButton.show.onTapEffect = buttons.onEffectsTapEffect
    buttons.effectsButton.show.name = "effectsButton"
end

--buttons.musicButton:addEventListener("tap", buttons.onTap )
return buttons