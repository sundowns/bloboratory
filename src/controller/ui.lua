UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.mainMenu = true
        self.buildMenu = false
        self.upgradeMenu = false
        self.isChoosing = 0
        self.styles = {
            CRUCIBLE = {
                ['window'] = {
                    ['background'] = '#c89870',
                    ['fixed background'] = assets.ui.menuCrucible,
                },
                ['button'] = {
                    ['normal'] = assets.ui.slotClean,
                    ['hover'] = assets.ui.slotCleanHovered,
                    ['active'] = assets.ui.slotClean,
                },
            },
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
                nk.stylePush(self.styles.MAIN_MENU)
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

                if nk.windowBegin('Rounds', constants.UI.ROUNDS.X*windowWidth, constants.UI.ROUNDS.Y*windowHeight, constants.UI.ROUNDS.WIDTH*windowWidth, constants.UI.ROUNDS.HEIGHT*windowHeight) then
                    self:handleResize(constants.UI.ROUNDS.X*windowWidth, constants.UI.ROUNDS.Y*windowHeight, constants.UI.ROUNDS.WIDTH*windowWidth, constants.UI.ROUNDS.HEIGHT*windowHeight)
                    nk.layoutRow('dynamic', (constants.UI.ROUNDS.LAYOUTROW_HEIGHT*windowHeight), {1/2, 1/2})
                    nk.label('Rounds:')
                    nk.label('50')
                end
                nk.windowEnd()
                nk.stylePop()

                nk.stylePush(self.styles.CRUCIBLE)
                if nk.windowBegin('Crucible', constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight) then
                    self:handleResize(constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight)
                    nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                    for i=1, 9 do 
                        if i+1 % 3 == 0 then
                            nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                        end
                
                        if nk.button('') then
                            self.isChoosing = i
                        end
                    end
                end
                nk.windowEnd()
                nk.stylePop()

                if self.isChoosing > 0 then 
                    if nk.windowBegin('PICKER', constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight, 'border','scrollbar','closable') then
                        self:handleResize(constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight)
                        nk.layoutRow('dynamic', (constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight), {(1/6),(1/6),(1/6),(1/6),(1/6),(1/6)})
                        if nk.button('Blob') then 
                            for i=1, 3 do
                                table.remove(world.crucible.slots[self.isChoosing], 1)
                                table.insert(world.crucible.slots[self.isChoosing], Blob(Vector(0,0)))
                            end
                            self.isChoosing = 0
                        end
                        nk.label('HP: ' ..constants.ENEMY.BLOB.HEALTH.. '', 'centered')
                        nk.label('YIELD: Scrap +' ..constants.ENEMY.BLOB.YIELD.SCRAP..'', 'centered')
                        nk.label('')
                        nk.label('')
                        nk.image(assets.ui.slotClean)
                        nk.layoutRow('dynamic', (constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight), {(1/6),(1/6),(1/6),(1/6),(1/6),(1/6)})
                        if nk.button('Large Blob') then 
                            for i=1, 3 do
                                table.remove(world.crucible.slots[self.isChoosing], 1)
                                table.insert(world.crucible.slots[self.isChoosing], LargeBlob(Vector(0,0)))
                            end
                            self.isChoosing = 0
                        end
                        nk.label('HP: ' ..constants.ENEMY.LARGEBLOB.HEALTH.. '', 'centered')
                        nk.label('YIELD: Scrap +' ..constants.ENEMY.BLOB.YIELD.SCRAP..'', 'centered')
                        nk.label('')
                        nk.label('')
                        nk.image(assets.ui.slotClean)
                        nk.layoutRow('dynamic', (constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight), {(1/6),(1/6),(1/6),(1/6),(1/6),(1/6)})
                        if nk.button('Fire Blob') then 
                            for i=1, 3 do
                                table.remove(world.crucible.slots[self.isChoosing], 1)
                                table.insert(world.crucible.slots[self.isChoosing], BlobFire(Vector(0,0)))
                            end
                            self.isChoosing = 0
                        end 
                        nk.label('HP: ' ..constants.ENEMY.BLOBFIRE.HEALTH.. '', 'centered')
                        nk.label('YIELD: Fire +' ..constants.ENEMY.BLOBFIRE.YIELD.FIRE..'', 'centered')
                        nk.label('')
                        nk.label('')
                        nk.image(assets.ui.slotClean)
                        nk.layoutRow('dynamic', (constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight), {(1/6),(1/6),(1/6),(1/6),(1/6),(1/6)})
                        if nk.button('Large Fire Blob') then 
                            for i=1, 3 do
                                table.remove(world.crucible.slots[self.isChoosing], 1)
                                table.insert(world.crucible.slots[self.isChoosing], LargeBlobFire(Vector(0,0)))
                            end
                            self.isChoosing = 0
                        end 
                        nk.label('HP: ' ..constants.ENEMY.LARGEBLOBFIRE.HEALTH.. '', 'centered')
                        nk.label('YIELD: Fire +' ..constants.ENEMY.LARGEBLOBFIRE.YIELD.FIRE..'', 'centered')
                        nk.label('')
                        nk.label('')
                        nk.image(assets.ui.slotClean)
                        nk.layoutRow('dynamic', (constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight), {(1/6),(1/6),(1/6),(1/6),(1/6),(1/6)})
                        if nk.button('Ice Blob') then 
                            for i=1, 3 do
                                table.remove(world.crucible.slots[self.isChoosing], 1)
                                table.insert(world.crucible.slots[self.isChoosing], BlobIce(Vector(0,0)))
                            end
                            self.isChoosing = 0
                        end 
                        nk.label('HP: ' ..constants.ENEMY.BLOBICE.HEALTH.. '', 'centered')
                        nk.label('YIELD: Ice +' ..constants.ENEMY.BLOBICE.YIELD.ICE..'', 'centered')
                        nk.label('')
                        nk.label('')
                        nk.image(assets.ui.slotClean)
                    else -- Allow 'close' button to work
                        self.isChoosing = 0 
                    end
                    nk.windowEnd()
                end


                nk.stylePush(self.styles.SELECT_MENU)
                if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
                    self:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)                        
                    if playerController.currentSelectedStructure ~= nil then 
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
                end
                nk.windowEnd()

                if nk.windowBegin('Stats', constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight) then
                    self:handleResize(constants.UI.STATS.X*windowWidth, constants.UI.STATS.Y*windowHeight, constants.UI.STATS.WIDTH*windowWidth, constants.UI.STATS.HEIGHT*windowHeight)
                    nk.layoutRow('dynamic', (constants.UI.STATS.LAYOUTROW_HEIGHT*windowHeight), {0.2, 0.8})
                    nk.label('')
                    nk.label('Things go here')
                end
                nk.windowEnd()
                nk.stylePop()
            end
        nk.frameEnd()
        self.resizeTriggered = false
    end;
    draw = function(self)
        Util.l.resetColour()
        nk.draw()
    end;
}