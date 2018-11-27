Picker = Class {
    init = function(self)
        self.choice = 0
        self.prepareToHide = false -- Make sure we hide at end of window frame
        self.tooltip_slot_default = " Select enemies to be sent this round."
        self.tooltip_slot_current = self.tooltip_slot_default
        self.styles = {
            CRUCIBLE = {
                ['window'] = {
                    ['fixed background'] = assets.ui.menuCrucibleBottom,
                    ['padding'] = {x = 14, y = 12}
                },
                ['button'] = {
                    ['border color'] = constants.COLOURS.UI.NONE,
                    ['normal'] = constants.COLOURS.UI.NONE,
                    ['hover'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['active'] = constants.COLOURS.UI.PANEL_TRANSPARENT_DARK,
                },
            },
            CRUCIBLE_LOCKED = {
                ['button'] = {
                    ['border color'] = constants.COLOURS.UI.NONE,
                    ['normal'] = constants.COLOURS.UI.DISABLED,
                    ['hover'] = constants.COLOURS.UI.DISABLED,
                    ['active'] = constants.COLOURS.UI.DISABLED,
                },
            },
            START = {
                ['window'] = {
                    ['fixed background'] = assets.ui.menuCrucibleButton,
                    ['padding'] = {x = 44, y = 8}
                },
                ['button'] = {
                    ['normal'] = assets.ui.startGrey,
                    ['hover'] = assets.ui.startGrey,
                    ['active'] = assets.ui.startGrey,
                },
            },
            PICKER = {
                ['font'] = assets.ui.planerRegular(28),
                ['window'] = {
                    ['header'] = {
                        ['normal'] = constants.COLOURS.UI.PANEL,
                        ['hover'] = constants.COLOURS.UI.PANEL,
                        ['active'] = constants.COLOURS.UI.PANEL,
                        ['close button'] = {
                            ['normal'] = constants.COLOURS.UI.PANEL,
                            ['hover'] = constants.COLOURS.UI.PANEL,
                            ['active'] = constants.COLOURS.UI.PANEL,
                        }
                    },
                    ['fixed background'] = constants.COLOURS.UI.PANEL_DARK,
                    ['background'] = constants.COLOURS.UI.PANEL_DARK,
                    ['border color'] = constants.COLOURS.UI.PANEL,
                },
                ['button'] = {
                    ['normal'] = constants.COLOURS.UI.PANEL_DARK,
                    ['hover'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['active'] = constants.COLOURS.UI.PANEL_DARK,
                    ['border color'] = constants.COLOURS.UI.PANEL
                }
            }
        }
    end; 
    tooltipSlotClear = function(self)
        self.tooltip_slot_current = self.tooltip_slot_default
    end;
    tooltipSlotUpdate = function(self, enemy)
        self.tooltip_slot_current = " This slot will send " .. roundController.crucible.enemiesPerSlot .. 'x ' ..enemy.name.."s this round"
    end;
    pickerIsOpen = function(self)

    end;
    calcEnemyHealth = function(self, blueprint)
        local multiplier = roundController.crucible:calculateHealthScaling(roundController.roundIndex, roundController.totalRounds)
        return math.floor((blueprint.baseHealth * multiplier))
    end;
    pairsByKeys = function(self, t, f)
        local a = {}
        for n in pairs(t) do table.insert(a, n) end
            table.sort(a, f)
            local i = 0      -- iterator variable
            local iter = function ()   -- iterator function
                i = i + 1
                if a[i] == nil then return nil
                else return a[i], t[a[i]]
            end
        end
        return iter
    end;
    display = function(self, windowWidth, windowHeight)
            nk.stylePush(self.styles.CRUCIBLE)
            if roundController.crucible.isLocked then
                nk.stylePush(self.styles.CRUCIBLE_LOCKED)
            end
            if nk.windowBegin('Crucible', constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight) then
                uiController:handleResize(constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight)

                if roundController:isBuildPhase() then
                    nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), 3)
                    for i=1, #roundController.crucible.slots do 
                        local blueprint = roundController.crucible.slots[i].blueprint
                        if i+1 % 3 == 0 then
                            nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), 3)
                        end

                        if blueprint then
                            nk.stylePush({
                                ['button'] = {
                                    ['normal'] = blueprint.image,
                                    ['hover'] = blueprint.imageHovered,
                                    ['active'] = blueprint.imageActive
                                },
                            })
                            self:tooltipSlotUpdate(blueprint)
                        elseif self.tooltip_slot_current ~= self.tooltip_slot_default then
                            self:tooltipSlotClear()
                        end

                        if nk.widgetIsHovered() then
                            if blueprint or not roundController.crucible.isLocked then
                                nk.stylePush({['window'] = {
                                    ['background'] = constants.COLOURS.UI.BLACK,
                                    ['padding'] = {x = 5, y = 0}}
                                })
                                nk.tooltip(self.tooltip_slot_current)
                                nk.stylePop()
                            end
                        elseif nk.windowIsHovered() then 
                            if not nk.windowHasFocus() then 
                                nk.windowSetFocus('Crucible')
                            end
                        end

                        if nk.button('') then
                            audioController:playAny("BUTTON_PRESS")
                            if not roundController.crucible.isLocked then
                                self.choice = i
                                nk.windowShow(constants.UI.PICKER.NAME)
                                playerController:toggleStructureSelection(playerController.currentSelectedStructure)
                            end
                        end
        
                        if blueprint then
                            nk.stylePop()
                        end
                    end
                end
            end
            nk.windowEnd()
            if roundController.crucible.isLocked then
                nk.stylePop()
            end
            nk.stylePop()
            
            nk.stylePush(self.styles.START)
            if nk.windowBegin('Start', constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight -48, constants.UI.CRUCIBLE.WIDTH*windowWidth, 0.05*windowHeight) then 
                uiController:handleResize(constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight -48, constants.UI.CRUCIBLE.WIDTH*windowWidth, 0.05*windowHeight)
                nk.layoutRow('dynamic', constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT * windowWidth - 42, 1)

                if roundController:isBuildPhase() then
                    nk.stylePush({['button'] = 
                        {   
                            ['active'] = assets.ui.startActive,
                            ['normal'] = assets.ui.startActive,
                            ['hovered'] = assets.ui.startActive,
                        },
                    })
                end

                if nk.button('') then
                    if roundController:isBuildPhase()  then
                        if world.grid.validPath then
                            roundController.readyToStart = true
                        else
                            helpController:addText("Create a valid path for the enemies in order to start the round!", nil, {0.8,0.3,0})
                        end
                    end
                end

                if roundController:isBuildPhase() then 
                    nk.stylePop()
                end
            end
            nk.windowEnd()
            nk.stylePop()
            
            nk.stylePush(self.styles.PICKER)
            if nk.windowBegin(constants.UI.PICKER.NAME, '', constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight, 'border','scrollbar','closable') then
                uiController:handleResize(constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight)

                for i, blueprint in self:pairsByKeys(roundController.ENEMY_BLUEPRINTS) do
                    if blueprint.isUnlocked then
                        nk.layoutRow('dynamic', constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight, {1/12, 4/12, 2/12, 1/12, 1/12, 1/8, 1/8})
                        nk.image(blueprint.image)
                        nk.label('3x ' ..blueprint.name, 'left')
                        nk.label('HP: ' ..self:calcEnemyHealth(blueprint), 'left')

                        for key, value in pairs(blueprint.yield) do
                            nk.image(playerController.wallet.currencies[key].image)
                            nk.label(value, 'left', nk.colorRGBA(playerController.wallet.currencies[key]:colourRGB()))
                        end

                        if nk.button('SEND') then
                            audioController:playAny("ENEMY_HIT")
                            roundController.crucible:setSlot(self.choice, blueprint)
                            nk.windowHide(constants.UI.PICKER.NAME)
                        end        
                        if nk.button('FILL') then 
                            for i = 1, #roundController.crucible.slots do
                                if roundController.crucible:slotIsEmpty(i) then 
                                    audioController:playAny("ENEMY_HIT")
                                    roundController.crucible:setSlot(i, blueprint)
                                end
                            end
                            nk.windowHide(constants.UI.PICKER.NAME)
                        end
                    end
                end

                if self.choice > 0 and not roundController.crucible:slotIsEmpty(self.choice) then
                    nk.layoutRow('dynamic', constants.UI.PICKER.LAYOUTROW_HEIGHT/2*windowHeight, 3)
                    nk.stylePush({
                        ['font'] = assets.ui.planerRegular(18),
                    })
                    nk.spacing(1)
                    if nk.button('CLEAR SLOT') then
                        audioController:playAny("ENEMY_LEAK")
                        roundController.crucible:resetSlot(self.choice)
                        nk.windowHide(constants.UI.PICKER.NAME)
                    end
                    nk.spacing(2)
                    if nk.button('CLEAR ALL SLOTS') then 
                        for i = 1, #roundController.crucible.slots do
                            audioController:playAny("ENEMY_LEAK")
                            roundController.crucible:resetSlot(i, blueprint)
                        end
                        nk.windowHide(constants.UI.PICKER.NAME)
                    end
                    nk.stylePop()
                end

                if uiController.firstRun or self.prepareToHide then
                    nk.windowHide(constants.UI.PICKER.NAME)
                    self.prepareToHide = false
                end
            else -- Allow 'close' button to work
                nk.windowHide(constants.UI.PICKER.NAME)
            end
            nk.windowEnd()
            nk.stylePop()
    end;
}
