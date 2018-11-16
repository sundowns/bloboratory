UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.mainMenu = true
        self.buildMenu = false
        self.upgradeMenu = false
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
                        if nk.button('Start Wave') then
                            if world.grid.validPath then
                                roundController:startRound()
                            end
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
                        -- Other mainmenu stuff
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

                local crucible_style = {
                    ['window'] = {
                        ['background'] = '#c89870',
                        ['fixed background'] = '#615348',
                    },
                }
                nk.stylePush(crucible_style)
                if nk.windowBegin('Crucible', constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight, 'border') then
                    self:handleResize(constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight)
                    nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                    for i=3, 1, -1 do 
                        local style = {
                            ['button'] = {
                                ['normal'] = world.crucible.slots[i].image,
                                ['hover'] = world.crucible.slots[i].image_hovered,
                                ['active'] = world.crucible.slots[i].image,
                            },
                        }
                        nk.stylePush(style)
                        if nk.button('') then 
                            print("Crucible button: " ..i.."")
                        end
                        nk.stylePop()
                    end
                    nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                    for i=6, 4, -1 do 
                        local style = {
                            ['button'] = {
                                ['normal'] = world.crucible.slots[i].image,
                                ['hover'] = world.crucible.slots[i].image_hovered,
                                ['active'] = world.crucible.slots[i].image,
                            },
                        }
                        nk.stylePush(style)
                        if nk.button('') then 
                            print("Crucible button: " ..i.."")
                        end
                        nk.stylePop()
                    end
                    nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                    for i=9, 7, -1 do 
                        local style = {
                            ['button'] = {
                                ['normal'] = world.crucible.slots[i].image,
                                ['hover'] = world.crucible.slots[i].image_hovered,
                                ['active'] = world.crucible.slots[i].image,
                            },
                        }
                        nk.stylePush(style)
                        if nk.button('') then 
                            print("Crucible button: " ..i.."")
                        end
                        nk.stylePop()
                    end
                end
                nk.windowEnd()
                nk.stylePop()

                if playerController.currentSelectedStructure ~= nil then 
                    if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
                        self:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)
                        nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                        if self.upgradeMenu then 
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
                            nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), {(1/2),(1/2)})
                            if nk.button('Elec') then 
                                if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                                    playerController.currentSelectedStructure:addMutation(ElectricMutation()) 
                                    self.upgradeMenu = false
                                end                           
                            end
                            if nk.button('Back') then 
                                self.upgradeMenu = false
                            end
                        else
                            if nk.button('Upgrade') then 
                                self.upgradeMenu = true
                            end
                            if nk.button('Refund') then 
                                playerController:refundCurrentStructure()
                                self.upgradeMenu = false
                            end
                        end
                    end
                    nk.windowEnd()

                    if nk.windowBegin('Stats', constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight) then
                        self:handleResize(constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight)
                        nk.layoutRow('dynamic', (constants.UI.STATS.LAYOUTROW_HEIGHT*windowHeight), {0.2, 0.8})
                        nk.label('')
                        nk.label('Things go here')
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