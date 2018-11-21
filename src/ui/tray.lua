
Tray = Class {
    init = function(self)
        self.styles = {
            MAIN_MENU = {
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.BLACK, 
                },
                ['window'] = {
                    ['background'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['fixed background'] = assets.ui.menuRight,
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['text normal'] = constants.COLOURS.UI.BLACK,
                    ['text hovered'] = constants.COLOURS.UI.WHITE,
                    ['text active'] = constants.COLOURS.UI.BLACK,
                    ['image padding'] = {x = 4, y = 4}
                },
            },
            SELECT_MENU = {
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.BLACK, 
                },
                ['window'] = {
                    ['background'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['fixed background'] = assets.ui.menuLeft,
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['text normal'] = constants.COLOURS.UI.BLACK,
                    ['text hovered'] = constants.COLOURS.UI.WHITE,
                    ['text active'] = constants.COLOURS.UI.BLACK,
                    ['image padding'] = {x = 6, y = 6}
                },
            },
        }
    end; 

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.styles.MAIN_MENU)
        if nk.windowBegin('Menu', constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight)    
            if roundController:isBuildPhase() then 
                nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), 5)
                for i, blueprint in pairs(playerController.blueprints) do
                    self:displayTooltip(blueprint.costToolTip)
                    if nk.button('', blueprint.uiImage) then 
                        playerController:setCurrentBlueprint(i)
                    end
                end
                if nk.windowIsHovered() and not nk.widgetIsHovered() then 
                    if not nk.windowHasFocus() then 
                        nk.windowSetFocus('Menu')
                    end
                end
                nk.spacing(9 - #playerController.blueprints)
                if nk.button('Start Wave') then
                    if world.grid.validPath then
                        roundController:startRound()
                    end
                end
            end
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.styles.MAIN_MENU)
        if nk.windowBegin('Rounds', constants.UI.ROUNDS.X*windowWidth, constants.UI.ROUNDS.Y*windowHeight, constants.UI.ROUNDS.WIDTH*windowWidth, constants.UI.ROUNDS.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.ROUNDS.X*windowWidth, constants.UI.ROUNDS.Y*windowHeight, constants.UI.ROUNDS.WIDTH*windowWidth, constants.UI.ROUNDS.HEIGHT*windowHeight)
            nk.layoutRow('dynamic', (constants.UI.ROUNDS.LAYOUTROW_HEIGHT*windowHeight/2), 1)
            nk.label('Rounds: ' .. roundController.roundIndex .. ' / ' .. roundController.totalRounds)
            nk.layoutRow('dynamic', (constants.UI.ROUNDS.LAYOUTROW_HEIGHT*windowHeight/2), 1)
            nk.label('Lives: ' .. playerController.livesRemaining .. ' / ' .. constants.MISC.STARTING_LIVES)
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.styles.SELECT_MENU)
        if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)                        
            if playerController.currentSelectedStructure ~= nil then 
                if roundController:isBuildPhase() then 
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    self:displayTooltip("Fire: Applies damage over time debuff. Cost = 30 flint")
                    if nk.button('', assets.ui.iconFire) then 
                        playerController:upgradeCurrentStructure("FIRE")
                    end
                    self:displayTooltip("Ice: Applies movement speed slowing debuff. Cost = 30 icicles")
                    if nk.button('', assets.ui.iconIce) then 
                        playerController:upgradeCurrentStructure("ICE")
                    end
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    self:displayTooltip("Elec: Applies high variance bonus damage. Cost = 30 charge")      
                    if nk.button('', assets.ui.iconElectric) then 
                        playerController:upgradeCurrentStructure("ELECTRIC")    
                    end
                    nk.spacing(3)
                    self:displayTooltip("Refund tower for full cost")
                    if nk.button('', assets.ui.refund) then 
                        playerController:refundCurrentStructure()
                    end

                    if nk.windowIsHovered() and not nk.widgetIsHovered() then 
                        if not nk.windowHasFocus() then 
                            nk.windowSetFocus('Selected')
                        end
                    end
                end
            end
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.styles.SELECT_MENU)
        if nk.windowBegin('Stats', constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight)
            nk.layoutRow('dynamic', (constants.UI.STATS.LAYOUTROW_HEIGHT*windowHeight), {0.2, 0.8})
            nk.spacing(1)

        end
        nk.windowEnd()
        nk.stylePop()
    end;

    displayTooltip = function(self, tooltip)
        if nk.widgetIsHovered() then 
            nk.stylePush({['window'] = {
                ['background'] = constants.COLOURS.UI.BLACK,
                ['padding'] = {x = 5, y = 0}},
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.WHITE}
            })
            nk.tooltip(tooltip)
            nk.stylePop()
        end
    end;
}

