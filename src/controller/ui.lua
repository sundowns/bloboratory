UiController = Class {
    init = function(self)
    end;
    update = function(self, dt)
        nk.frameBegin()
            if nk.windowBegin('Wallet', constants.UI.WALLET.X, constants.UI.WALLET.Y, constants.UI.WALLET.WIDTH, constants.UI.WALLET.HEIGHT) then
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
                if nk.windowBegin('Menu', constants.UI.MENU.X, constants.UI.MENU.Y, constants.UI.MENU.WIDTH, constants.UI.MENU.HEIGHT) then
                    nk.layoutRow('dynamic', 50, 2)
                    if nk.button('Place Obstacle') then 
                        playerController:setCurrentBlueprint(1)
                    end
                    if nk.button('Place Saw') then 
                        playerController:setCurrentBlueprint(2)
                    end

                    nk.layoutRow('dynamic', 50, 2)
                    if nk.button('Place Cannon') then 
                        playerController:setCurrentBlueprint(3)
                    end
                    if world.grid.validPath then
                        if nk.button('Start Wave') then
                            roundController:startRound()
                        end
                    end
                end
                nk.windowEnd()

                if nk.windowBegin('Selected', constants.UI.SELECTED.X, constants.UI.SELECTED.Y, constants.UI.SELECTED.WIDTH, constants.UI.SELECTED.HEIGHT) then
                    if playerController.lastSelectedStructure ~= nil then 
                        nk.layoutRow('dynamic', 50, 2)
                        if nk.button('Fire') then 
                            if playerController.lastSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.FIRE.COST) then
                                playerController.lastSelectedStructure:addMutation(FireMutation()) 
                                playerController.lastSelectedStructure = nil
                            end
                        end
                        if nk.button('Ice') then 
                            if playerController.lastSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ICE.COST) then
                                playerController.lastSelectedStructure:addMutation(IceMutation()) 
                                playerController.lastSelectedStructure = nil
                            end
                        end
                        nk.layoutRow('dynamic', 50, 2)
                        if nk.button('Elec') then 
                            if playerController.lastSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                                playerController.lastSelectedStructure:addMutation(ElectricMutation()) 
                                playerController.lastSelectedStructure = nil
                            end
                        end
                        if nk.button('Refund') then 
                            playerController:refundLastStructure()
                        end
                    end
                end
                nk.windowEnd()
            end
        nk.frameEnd()
    end;
    draw = function(self)
        Util.l.resetColour()
        nk.draw()
    end;
}