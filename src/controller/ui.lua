UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.mainMenu = true
        self.buildMenu = false
    end;
    triggerResize = function(self)
        self.resizeTriggered = true
    end;
    handleResize = function(self, x, y, width, height)
        if self.resizeTriggered then
            nk.windowSetBounds(x, y, width, height)
        end
    end;
    update = function(self, dt)
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()
        nk.frameBegin()
            if nk.windowBegin('Wallet', constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight) then

                self:handleResize(constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight)
            
                local width, height = nk.windowGetSize()
                nk.layoutRowBegin('dynamic', height*0.6, playerController.wallet.totalCurrencies)
                for key, currency in pairs(playerController.wallet.currencies) do
                    nk.layoutRowPush(1/playerController.wallet.totalCurrencies)
                    nk.label(currency.value, 'centered', nk.colorRGBA(currency:colourRGB()))
                end
                nk.layoutRowEnd()
            end
            nk.windowEnd()

            if roundController:isBuildPhase() then 
                if nk.windowBegin('Menu', constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight) then
                    self:handleResize(constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight)
                    nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                    if self.mainMenu then 
                        if nk.button('Build') then 
                            self.mainMenu = false
                            self.buildMenu = true
                        end
                    elseif self.buildMenu then 
                        if nk.button('Place Obstacle') then 
                            playerController:setCurrentBlueprint(1)
                        end
                        if nk.button('Place Saw') then 
                            playerController:setCurrentBlueprint(2)
                        end
                    end 
                    nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                    if self.mainMenu then 
                        if nk.button('Start Wave') then
                            if world.grid.validPath then
                                roundController:startRound()
                            end
                        end
                    elseif self.buildMenu then 
                        if nk.button('Place Cannon') then 
                            playerController:setCurrentBlueprint(3)
                        end
                        if nk.button('Back') then
                            self.buildMenu = false
                            self.mainMenu = true
                        end
                    end 

                end
                nk.windowEnd()

                if playerController.currentSelectedStructure ~= nil then 
                    if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
                        self:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)
                        nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                        if nk.button('Fire') then 
                            if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.FIRE.COST) then
                                playerController.currentSelectedStructure:addMutation(FireMutation()) 
                            end
                        end
                        if nk.button('Ice') then 
                            if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ICE.COST) then
                                playerController.currentSelectedStructure:addMutation(IceMutation()) 
                            end
                        end
                        nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                        if nk.button('Elec') then 
                            if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                                playerController.currentSelectedStructure:addMutation(ElectricMutation()) 
                            end
                        end
                        if nk.button('Refund') then 
                            playerController:refundCurrentStructure()
                        end
                    end
                    nk.windowEnd()
                end
            end
        nk.frameEnd()
        self.resizeTriggered = false
    end;
    draw = function(self)
        Util.l.resetColour()
        nk.draw()
    end;
}