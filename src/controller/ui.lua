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
                if nk.windowBegin('Menu', constants.UI.MENU.X, constants.UI.MENU.Y, love.graphics.getWidth(), constants.UI.MENU.HEIGHT) then
                    nk.layoutRow('dynamic', 50, {(1/3),(1/3),(1/6),(1/6)})
                    if nk.button('Place Obstacle') then 
                        playerController:setCurrentBlueprint(1)
                    end
                    if nk.button('Place Saw') then 
                        playerController:setCurrentBlueprint(2)
                    end
                    if playerController.currentSelectedStructure ~= nil then 
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
                    end
                    nk.layoutRow('dynamic', 50, {(1/3),(1/3),(1/6),(1/6)})
                    if nk.button('Place Cannon') then 
                        playerController:setCurrentBlueprint(3)
                    end
                    if nk.button('Start Wave') then
                        if world.grid.validPath then
                            roundController:startRound()
                        end
                    end
                    if playerController.currentSelectedStructure ~= nil then 
                        if nk.button('Elec') then 
                            if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                                playerController.currentSelectedStructure:addMutation(ElectricMutation()) 
                            end
                        end
                        if nk.button('Refund') then 
                            playerController:refundCurrentStructure()
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