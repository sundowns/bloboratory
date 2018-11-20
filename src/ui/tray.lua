
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
                    if nk.button('', blueprint.image) then 
                        playerController:setCurrentBlueprint(i)
                    elseif nk.widgetIsHovered() then
                        nk.tooltip(blueprint.costToolTip)
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
            nk.layoutRow('dynamic', (constants.UI.ROUNDS.LAYOUTROW_HEIGHT*windowHeight), {1/2, 1/2})
            nk.label('Rounds:')
            nk.label('50')
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.styles.SELECT_MENU)
        if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)                        
            if playerController.currentSelectedStructure ~= nil then 
                if roundController:isBuildPhase() then 
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    if nk.button('Fire') then 
                        playerController:upgradeCurrentStructure("FIRE")
                    elseif nk.widgetIsHovered() then
                        nk.tooltip("Fire: Applies damage over time debuff. Cost = 30 flint")
                    end
                    if nk.button('Ice') then 
                        playerController:upgradeCurrentStructure("ICE")
                    elseif nk.widgetIsHovered() then
                        nk.tooltip("Ice: Applies movement speed slowing debuff. Cost = 30 icicles")
                    end

                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    if nk.button('Elec') then 
                        playerController:upgradeCurrentStructure("ELECTRIC")    
                    elseif nk.widgetIsHovered() then
                        nk.tooltip("Elec: Applies high variance bonus damage. Cost = 30 charge")                 
                    end
                    nk.spacing(3)
                    if nk.button('Refund') then 
                        playerController:refundCurrentStructure()
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
}

