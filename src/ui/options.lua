
Options = Class {
    init = function(self)      
        self.style = {
            MENU = {
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.WHITE, 
                },
                ['window'] = {
                    ['fixed background'] = constants.COLOURS.UI.NONE,
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['active'] = constants.COLOURS.UI.NONE,
                    ['text background'] = constants.COLOURS.UI.NONE,
                    ['text normal'] = constants.COLOURS.UI.WHITE,
                    ['text hovered'] = constants.COLOURS.UI.BLACK,
                    ['text active'] = constants.COLOURS.UI.WHITE,
                },
            },
            SOUND = {
                ['font'] = assets.ui.planerRegular(22),
                ['window'] = {
                    ['fixed background'] = assets.ui.button,
                    ['background'] = constants.COLOURS.UI.NONE,
                    ['border color'] = constants.COLOURS.UI.NONE,
                    ['padding'] = {x = 10, y = 7}
                },
                ['button'] = {
                    ['normal'] = constants.COLOURS.UI.NONE,
                    ['hover'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['active'] = constants.COLOURS.UI.PANEL_DARK,
                    ['border color'] = constants.COLOURS.UI.NONE
                },
                ['slider'] = {
                    ['normal'] = constants.COLOURS.UI.NONE,
                    ['hover'] = constants.COLOURS.UI.NONE,
                    ['active'] = constants.COLOURS.UI.NONE,
                    ['bar normal'] = constants.COLOURS.UI.SLIDER_DARK,
                    ['bar active'] = constants.COLOURS.UI.SLIDER_DARK,
                    ['bar filled'] = constants.COLOURS.UI.SLIDER_DARKEST,
                    ['cursor normal'] = constants.COLOURS.UI.SLIDER_DARKEST,
                    ['cursor hover'] = constants.COLOURS.UI.SLIDER_DARKEST,
                    ['cursor active'] = constants.COLOURS.UI.SLIDER_DARKEST,
                }
            }
        }        
        self.markedForRestart = false
    end; 

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.style.MENU)
        if nk.windowBegin(constants.UI.OPTIONS_MENU.NAME, constants.UI.OPTIONS_MENU.X*windowWidth, constants.UI.OPTIONS_MENU.Y*windowHeight, constants.UI.OPTIONS_MENU.WIDTH*windowWidth, constants.UI.OPTIONS_MENU.HEIGHT*windowHeight) then 
            uiController:handleResize(constants.UI.OPTIONS_MENU.X*windowWidth, constants.UI.OPTIONS_MENU.Y*windowHeight, constants.UI.OPTIONS_MENU.WIDTH*windowWidth, constants.UI.OPTIONS_MENU.HEIGHT*windowHeight)
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), {(1)})
            if nk.button("Resume Game") then 
                nk.windowHide(constants.UI.OPTIONS_MENU.NAME)
                audioController:playAny("BUTTON_PRESS")
            end 
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), {(1)})
            if nk.button("Sound") then 
                nk.windowHide(constants.UI.OPTIONS_MENU.NAME)
                nk.windowShow(constants.UI.OPTIONS_SOUND.NAME)
                audioController:playAny("BUTTON_PRESS")
            end 
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), 1)
            if nk.button("Restart Game") then 
                self.markedForRestart = true
            end 
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), 1)
            if nk.button("Exit Game") then 
                love.event.quit()
            end 
            if uiController.firstRun then
                nk.windowHide(constants.UI.OPTIONS_MENU.NAME)
            end
        else 
            nk.windowHide(constants.UI.OPTIONS_MENU.NAME)
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.style.SOUND)
        if nk.windowBegin(constants.UI.OPTIONS_SOUND.NAME, constants.UI.OPTIONS_SOUND.X*windowWidth, constants.UI.OPTIONS_SOUND.Y*windowHeight, constants.UI.OPTIONS_SOUND.WIDTH*windowWidth, constants.UI.OPTIONS_SOUND.HEIGHT*windowHeight) then 
            uiController:handleResize(constants.UI.OPTIONS_SOUND.X*windowWidth, constants.UI.OPTIONS_SOUND.Y*windowHeight, constants.UI.OPTIONS_SOUND.WIDTH*windowWidth, constants.UI.OPTIONS_SOUND.HEIGHT*windowHeight)
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), 1)
            nk.label("Music Volume:") 
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_SOUND.LAYOUTROW_HEIGHT*windowHeight), 1)
            configController.settings.music_multiplier = nk.slider(0, configController.settings.music_multiplier, 2, 0.01)
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_MENU.LAYOUTROW_HEIGHT*windowHeight), 1)
            nk.label("SFX Volume:") 
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_SOUND.LAYOUTROW_HEIGHT*windowHeight), 1)
            configController.settings.sfx_multiplier = nk.slider(0, configController.settings.sfx_multiplier, 2, 0.01)
            nk.layoutRow('dynamic', (constants.UI.OPTIONS_SOUND.LAYOUTROW_HEIGHT*windowHeight*0.5), 1)
            if nk.button("Back") then 
                audioController:playAny("BUTTON_PRESS")
                audioController:updateMusicVolume()
                audioController:updateSfxVolume()
                configController:saveUserSettings()
                nk.windowHide(constants.UI.OPTIONS_SOUND.NAME)
                nk.windowShow(constants.UI.OPTIONS_MENU.NAME)
            end 
            if uiController.firstRun then
                nk.windowHide(constants.UI.OPTIONS_SOUND.NAME)
            end
        else 
            nk.windowHide(constants.UI.OPTIONS_SOUND.NAME)
        end
        nk.windowEnd()
        nk.stylePop()
    end;
}

