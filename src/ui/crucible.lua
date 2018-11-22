Picker = Class {
    init = function(self)
        self.choice = 0
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
                    ['hover'] = constants.COLOURS.UI.PANEL_LIGHT,
                    ['active'] = constants.COLOURS.UI.PANEL_DARK,
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
            }
        }
    end; 
    tooltipSlotClear = function(self)
        self.tooltip_slot_current = self.tooltip_slot_default
    end;
    tooltipSlotUpdate = function(self, enemy)
        self.tooltip_slot_current = " This slot sends "..enemy.name.." this round"
    end;
    display = function(self, windowWidth, windowHeight)
            nk.stylePush(self.styles.CRUCIBLE)
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
                                    ['active'] = blueprint.imageActive,
                                },
                            })
                            self:tooltipSlotUpdate(blueprint)
                        elseif self.tooltip_slot_current ~= self.tooltip_slot_default then
                            self:tooltipSlotClear()
                        end

                        if nk.widgetIsHovered() then 
                            nk.stylePush({['window'] = {
                                ['background'] = constants.COLOURS.UI.BLACK,
                                ['padding'] = {x = 5, y = 0}}
                            })
                            nk.tooltip(self.tooltip_slot_current)
                            nk.stylePop()
                        elseif nk.windowIsHovered() then 
                            if not nk.windowHasFocus() then 
                                nk.windowSetFocus('Crucible')
                            end
                        end

                        if nk.button('') then
                            self.choice = i
                            nk.windowShow(constants.UI.PICKER.NAME)
                            playerController:toggleStructureSelection(playerController.currentSelectedStructure)
                        end

        
                        if blueprint then
                            nk.stylePop()
                        end
                    end
                end
            end
            nk.windowEnd()
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
                    if roundController:isBuildPhase() and world.grid.validPath then
                        roundController:startRound()
                    end
                end

                if roundController:isBuildPhase() then 
                    nk.stylePop()
                end
            end
            nk.windowEnd()
            nk.stylePop()
    
            if nk.windowBegin(constants.UI.PICKER.NAME, '', constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight, 'border','scrollbar','closable') then
                uiController:handleResize(constants.UI.PICKER.X*windowWidth, constants.UI.PICKER.Y*windowHeight, constants.UI.PICKER.WIDTH*windowWidth, constants.UI.PICKER.HEIGHT*windowHeight)

                if self.choice > 0 and not roundController.crucible:slotIsEmpty(self.choice) then
                    nk.layoutRow('dynamic', constants.UI.PICKER.LAYOUTROW_HEIGHT/4*windowHeight, 1)
                    if nk.button('REMOVE') then
                        roundController.crucible:resetSlot(self.choice)
                        nk.windowHide(constants.UI.PICKER.NAME)
                    end
                end

                for i, blueprint in pairs(roundController.ENEMY_BLUEPRINTS) do
                    nk.layoutRow('dynamic', constants.UI.PICKER.LAYOUTROW_HEIGHT*windowHeight, 6)
                    if nk.button('', blueprint.image) then
                        roundController.crucible.slots[self.choice]:setBlueprint(blueprint)
                        nk.windowHide(constants.UI.PICKER.NAME)
                    end
                    nk.spacing(1)
                    nk.label(blueprint.name, 'left')
                    nk.spacing(1)

                    for key, value in pairs(blueprint.yield) do
                        nk.label(key .. ':  ' .. value, 'left', nk.colorRGBA(playerController.wallet.currencies[key]:colourRGB()))
                    end
                end
    
                if uiController.firstRun then
                    nk.windowHide(constants.UI.PICKER.NAME)
                end
            else -- Allow 'close' button to work
                nk.windowHide(constants.UI.PICKER.NAME)
            end
            nk.windowEnd()
    end;
}
