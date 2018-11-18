
Tray = Class {
    init = function(self)
        self.mainMenu = true
        self.buildMenu = false
        self.upgradeMenu = false
        self.styles = {
            MAIN_MENU = {
                ['text'] = {
                    ['color'] = '#000000', 
                },
                ['window'] = {
                    ['background'] = '#c89870',
                    ['fixed background'] = assets.ui.menuRight,
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = '#c89870',
                    ['text normal'] = '#000000',
                    ['text hovered'] = '#FFFFFF',
                    ['text active'] = '#000000',
                },
            },
            SELECT_MENU = {
                ['text'] = {
                    ['color'] = '#000000', 
                },
                ['window'] = {
                    ['background'] = '#c89870',
                    ['fixed background'] = assets.ui.menuLeft,
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = '#c89870',
                    ['text normal'] = '#000000',
                    ['text hovered'] = '#FFFFFF',
                    ['text active'] = '#000000',
                    },
                },
            }
    end; 

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.styles.MAIN_MENU)
        if nk.windowBegin('Menu', constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight)    
            
            if self.mainMenu then 
                nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), 2)
                if nk.button('Build') then 
                    self.mainMenu = false
                    self.buildMenu = true
                end
                if nk.button('Start Wave') then
                    if world.grid.validPath then
                        roundController:startRound()
                    end
                end
            elseif self.buildMenu then 
                nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), 5)
                if nk.button('', assets.blueprints.obstacle) then 
                    playerController:setCurrentBlueprint(1)
                end
                if nk.button('', assets.blueprints.saw) then 
                    playerController:setCurrentBlueprint(2)
                end
                nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), 5)
                if nk.button('', assets.blueprints.cannon) then 
                    playerController:setCurrentBlueprint(3)
                end
                nk.spacing(3)
                if nk.button('Back') then
                    self.buildMenu = false
                    self.mainMenu = true
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
                if self.upgradeMenu then 
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    if nk.button('Fire') then 
                        if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.FIRE.COST) then
                            playerController.currentSelectedStructure:addMutation(FireMutation()) 
                            self.upgradeMenu = false
                        end
                    end
                    if nk.button('Ice') then 
                        if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ICE.COST) then
                            playerController.currentSelectedStructure:addMutation(IceMutation()) 
                            self.upgradeMenu = false
                        end
                    end
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 5)
                    if nk.button('Elec') then 
                        if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                            playerController.currentSelectedStructure:addMutation(ElectricMutation()) 
                            self.upgradeMenu = false
                        end                           
                    end
                    nk.spacing(3)
                    if nk.button('Back') then 
                        self.upgradeMenu = false
                    end
                else
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), 2)
                    if nk.button('Upgrade') then 
                        self.upgradeMenu = true
                    end
                    if nk.button('Refund') then 
                        playerController:refundCurrentStructure()
                        self.upgradeMenu = false
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

