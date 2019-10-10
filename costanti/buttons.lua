local buttons = {}
buttons.musicButton = {}
buttons.musicButton.show = {}
buttons.effectsButton = {}
buttons.effectsButton.show = {}

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


function buttons.buttonSwitcheroo(button, target)
    button.x = target.x
    button.y = target.y
    button.imageIfTapped = target.imageIfTapped
    button.imageIfNotTapped = target.imageIfNotTapped
    button.onTapEffect = target.onTapEffect
    button:addEventListener("tap", buttons.onTap)
    target:removeSelf()
end

function buttons.onTap(event)
    local button = event.target
    if(button.pressed) then
        button = display.newImageRect(button.imageIfNotTapped, 100, 100)
        button.pressed = false
    else
        button = display.newImageRect(button.imageIfTapped, 100, 100)
        button.pressed = true
    end
    buttons.buttonSwitcheroo(button, event.target)
    event.target.onTapEffect(event.target)
end

function buttons.buttonsInit()
    buttons.musicButton.show = display.newImageRect("images/buttons/musicIcon.png", 100, 100)
    buttons.musicButton.show.x = display.contentWidth - 70
    buttons.musicButton.show.y = display.contentCenterY + -700
    buttons.musicButton.show.imageIfTapped = "images/buttons/musicIconDisabled.png"
    buttons.musicButton.show.imageIfNotTapped = "images/buttons/musicIcon.png"
    buttons.musicButton.show.pressed = false
    buttons.musicButton.show:addEventListener("tap", buttons.onTap)
    buttons.musicButton.show.onTapEffect = buttons.onMusicTapEffect
    
    buttons.effectsButton.show = display.newImageRect("images/buttons/audioIcon.png", 100, 100)
    buttons.effectsButton.show.x = display.contentWidth - 70
    buttons.effectsButton.show.y = display.contentCenterY + -600
    buttons.effectsButton.show.imageIfTapped = "images/buttons/audioIconDisabled.png"
    buttons.effectsButton.show.imageIfNotTapped = "images/buttons/audioIcon.png"
    buttons.effectsButton.show.pressed = false
    buttons.effectsButton.show:addEventListener("tap", buttons.onTap)
    buttons.effectsButton.show.onTapEffect = buttons.onEffectsTapEffect
    
end





--buttons.musicButton:addEventListener("tap", buttons.onTap )

return buttons;
