
Tray = Class {
    init = function(self, hotkeyedImages)
        self.styles = {
            MAIN_MENU = {
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.BLACK, 
                },
                ['window'] = {
                    ['background'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['fixed background'] = assets.ui.menuLeft,
                    ['padding'] = {x = 0, y = 24}
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['text normal'] = constants.COLOURS.UI.BLACK,
                    ['text hovered'] = constants.COLOURS.UI.WHITE,
                    ['text active'] = constants.COLOURS.UI.BLACK,
                    ['image padding'] = {x = 4, y = 5},
                    ['padding'] = {x = 1, y = 3}
                },
            },
            DISABLED = {
                ['button'] = {
                    ['normal'] = assets.ui.buttonDisabled,
                    ['hover'] = assets.ui.buttonDisabled,
                    ['active'] = assets.ui.buttonDisabled,
                }
            },
            ACTIVE = {
                ['button'] = {
                    ['normal'] = assets.ui.buttonHovered,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.buttonHovered,
                }
            },
            SELECT_MENU = {
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.BLACK, 
                },
                ['window'] = {
                    ['background'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['fixed background'] = assets.ui.menuRight,
                    ['padding'] = {x = 0, y = 24}
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['text normal'] = constants.COLOURS.UI.BLACK,
                    ['text hovered'] = constants.COLOURS.UI.WHITE,
                    ['text active'] = constants.COLOURS.UI.BLACK,
                    ['image padding'] = {x = 4, y = 5},
                    ['padding'] = {x = 2, y = 3}
                },
            },
        }
        self.hotkeyedImages = hotkeyedImages
    end; 

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.styles.MAIN_MENU)
        if nk.windowBegin('Menu', constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.MENU.X*windowWidth, constants.UI.MENU.Y*windowHeight, constants.UI.MENU.WIDTH*windowWidth, constants.UI.MENU.HEIGHT*windowHeight) 
            if roundController:isBuildPhase() then 
                nk.layoutRow('dynamic', (constants.UI.MENU.LAYOUTROW_HEIGHT*windowHeight), {4/10, 1/7, 1/7, 1/7, 1/7})
                nk.spacing(1)
                for i, blueprint in pairs(playerController.blueprints) do
                    local state = "DEFAULT"

                    if playerController.currentBlueprint and playerController.currentBlueprint.name == blueprint.name then
                        state = "ACTIVE"
                        nk.stylePush(self.styles.ACTIVE)
                    elseif not playerController.wallet:canAfford(blueprint.cost) then
                        state = "DISABLED"
                        nk.stylePush(self.styles.DISABLED)
                    end
                    
                    self:displayTooltip(blueprint.costToolTip)
                    if nk.button('', blueprint.uiImages[state]) then 
                        if playerController:setCurrentBlueprint(i) then
                            audioController:playAny("BUTTON_PRESS")
                        end
                    end

                    if not playerController.wallet:canAfford(blueprint.cost) or playerController.currentBlueprint and playerController.currentBlueprint.name == blueprint.name then
                        nk.stylePop()
                    end
                end
                if nk.windowIsHovered() and not nk.widgetIsHovered() then 
                    if not nk.windowHasFocus() then 
                        nk.windowSetFocus('Menu')
                    end
                end
            end
        end
        nk.windowEnd()
        nk.stylePop()

        nk.stylePush(self.styles.SELECT_MENU)
        if nk.windowBegin('Selected', constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.SELECTED.X*windowWidth, constants.UI.SELECTED.Y*windowHeight, constants.UI.SELECTED.WIDTH*windowWidth, constants.UI.SELECTED.HEIGHT*windowHeight)                        
            if playerController.currentSelectedStructure ~= nil then 
                if roundController:isBuildPhase() then 
                    nk.layoutRow('dynamic', (constants.UI.SELECTED.LAYOUTROW_HEIGHT*windowHeight), {0.03, 1/7, 1/7, 1/7, 1/7, 0.055, 1/7, 1/7})
                    nk.spacing(1)
                    if playerController.currentSelectedStructure.type ~= "OBSTACLE" then 
                        self:renderUpgradeButton("FIRE", " +DAMAGE OVER TIME. COST: ")
                        self:renderUpgradeButton("ICE", " +SLOWS ENEMIES. COST: ")
                        self:renderUpgradeButton("ELECTRIC", " +BASE DAMAGE. COST: ")
                       
                        nk.spacing(2)
                        if playerController.currentSelectedStructure.towerType == "LASERGUN" then 
                            self:displayTooltip(" Rotate")
                            if nk.button('', self.hotkeyedImages.ROTATE.DEFAULT) then
                                playerController:rotateCurrentStructure()
                            end
                        else
                            nk.spacing(1)
                        end 
                    else
                        nk.spacing(6)
                    end
                    self:displayTooltip(" Refund")
                    if nk.button('', self.hotkeyedImages.REFUND.DEFAULT) then 
                        audioController:playAny("BUTTON_PRESS")
                        playerController:refundCurrentStructure()
                    end

                    if nk.windowIsHovered() and not nk.widgetIsHovered() then 
                        if not nk.windowHasFocus() then 
                            nk.windowSetFocus('Selected')
                        end
                    end
                end
            end
        end
        nk.windowEnd()
        nk.stylePop()
    end;
    displayTooltip = function(self, tooltip)
        if nk.widgetIsHovered() then 
            nk.stylePush({['window'] = {
                ['background'] = constants.COLOURS.UI.BLACK,
                ['padding'] = {x = 5, y = 0}},
                ['text'] = {
                    ['color'] = constants.COLOURS.UI.WHITE}
            })
            nk.tooltip(' ' ..tooltip)
            nk.stylePop()
        end
    end;
    renderUpgradeButton = function(self, upgradeType, tooltipTextPrefix)
        local costTable = constants.MUTATION_COSTS[upgradeType][playerController.currentSelectedStructure.towerType]
        local tooltip = tooltipTextPrefix
        for key, cost in pairs(costTable) do
            tooltip = tooltip .. cost .. ' ' .. key
        end
        self:displayTooltip(tooltip)
        local state = "DEFAULT"
        if not playerController.currentSelectedStructure.mutable or not playerController.wallet:canAfford(constants.MUTATION_COSTS[upgradeType][playerController.currentSelectedStructure.towerType]) then
            state = "DISABLED"
            nk.stylePush(self.styles.DISABLED)
        end

        if nk.button('', self.hotkeyedImages[upgradeType][state]) then 
            if playerController:upgradeCurrentStructure(upgradeType) then
                audioController:playAny("BUTTON_PRESS")
            end
        end

        if state == "DISABLED" then
            nk.stylePop()
        end
    end;
}

