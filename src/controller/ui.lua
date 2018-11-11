UiController = Class {
    init = function(self)
    end;
    update = function(self, dt)
        nk.frameBegin()
            if roundController:isBuildPhase() then 
                if world.grid.validPath then
                    --TODO: show some sort of disabled/greyed out state instead of hiding it (when this is false)
                    if nk.windowBegin('Start', constants.UI.BUTTON.START_WAVE.X, constants.UI.BUTTON.START_WAVE.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                        nk.layoutRow('dynamic', 32, 1)
                        if nk.button('Start Wave') then 
                            world.crucible:prepareToSend()
                            roundController.currentRound = Round(1, world.crucible.enemies)
                            roundController:startRound()
                        end
                    end
                    
                    nk.windowEnd()
                end

                if nk.windowBegin('Obstacle', constants.UI.BUTTON.OBSTACLE.X, constants.UI.BUTTON.OBSTACLE.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Obstacle') then 
                        playerController:setCurrentBlueprint(1)
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Saw', constants.UI.BUTTON.SAW.X, constants.UI.BUTTON.SAW.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Saw') then 
                        playerController:setCurrentBlueprint(2)
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Cannon', constants.UI.BUTTON.CANNON.X, constants.UI.BUTTON.CANNON.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Cannon') then 
                        playerController:setCurrentBlueprint(3)
                    end
                end
                nk.windowEnd()
            end

            if nk.windowBegin('Wallet', constants.UI.WALLET.X, constants.UI.WALLET.Y, constants.UI.WALLET.WIDTH, constants.UI.WALLET.HEIGHT) then
                local width, height = nk.windowGetSize()
                nk.layoutRow('dynamic', height*0.6, playerController.wallet.totalCurrencies)
                for key, currency in pairs(playerController.wallet.currencies) do
                    nk.layoutRowPush(1/playerController.wallet.totalCurrencies)
                    nk.label(currency.value, 'centered', nk.colorRGBA(currency:colourRGB()))
                end
                nk.layoutRowEnd()
            end
            nk.windowEnd()

            if nk.windowBegin('Crafting', 100, 500, constants.UI.BUTTON.WIDTH, 1.5* constants.UI.BUTTON.HEIGHT, 'border', 'scrollbar') then
                nk.menubarBegin()
                nk.layoutRow('dynamic', 40, 1)
                if nk.menuBegin('Crucible', 'none', 110, 110) then 
                    nk.layoutRow('dynamic', 30, 3)
                    if nk.menuItem('1') then 
                        world.crucible.isChoosing = 1
                    end
                    if nk.menuItem('2') then 
                        world.crucible.isChoosing = 2
                    end
                    if nk.menuItem('3') then 
                        world.crucible.isChoosing = 3
                    end
                    nk.layoutRow('dynamic', 30, 3)
                    if nk.menuItem('4') then 
                        world.crucible.isChoosing = 4
                    end
                    if nk.menuItem('5') then 
                        world.crucible.isChoosing = 5
                    end
                    if nk.menuItem('6') then 
                        world.crucible.isChoosing = 6
                    end
                    nk.layoutRow('dynamic', 30, 3)
                    if nk.menuItem('7') then 
                        world.crucible.isChoosing = 7
                    end
                    if nk.menuItem('8') then 
                        world.crucible.isChoosing = 8
                    end
                    if nk.menuItem('9') then 
                        world.crucible.isChoosing = 9
                    end
                    nk.menuEnd()
                end
                nk.menubarEnd()
            end 
            nk.windowEnd()

            if world.crucible.isChoosing ~= 0 then 
                if nk.windowBegin('Chooser', 300, 400, 2 * constants.UI.BUTTON.WIDTH, 4.5 * constants.UI.BUTTON.HEIGHT, 'border', 'scrollbar') then
                    nk.layoutRow('dynamic', 50, 3)
                    if nk.button('Blob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = Blob(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('FireBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = BlobFire(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('IceBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = BlobIce(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    nk.layoutRow('dynamic', 50, 3)
                    if nk.button('LargeBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = LargeBlob(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('LargeFireBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = LargeBlobFire(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('LargeIceBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = LargeBlobIce(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    nk.layoutRow('dynamic', 50, 3)
                    if nk.button('ElecBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = BlobElectric(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('LargeElecBlob') then 
                        world.crucible.enemies[world.crucible.isChoosing] = LargeBlobElectric(Vector(0,0))
                        world.crucible.isChoosing = 0
                    end
                    if nk.button('Nothing') then 
                        world.crucible.enemies[world.crucible.isChoosing] = 0
                        world.crucible.isChoosing = 0
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