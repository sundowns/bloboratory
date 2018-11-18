
Picker = Class {
    init = function(self)
        self.choice = 0
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
        }
    end; 

    display = function(self, windowWidth, windowHeight)
            nk.stylePush(self.styles.CRUCIBLE)
            if nk.windowBegin('Crucible', constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight) then
                uiController:handleResize(constants.UI.CRUCIBLE.X*windowWidth, constants.UI.CRUCIBLE.Y*windowHeight, constants.UI.CRUCIBLE.WIDTH*windowWidth, constants.UI.CRUCIBLE.HEIGHT*windowHeight)
                nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                for i=1, #roundController.crucible.slots do 
                    local blueprint = roundController.crucible.slots[i].blueprint
                    if i+1 % 3 == 0 then
                        nk.layoutRow('dynamic', (constants.UI.CRUCIBLE.LAYOUTROW_HEIGHT*windowHeight), {(1/3),(1/3),(1/3)})
                    end
    
                    if blueprint then
                        nk.stylePush({
                            ['button'] = {
                                ['normal'] = blueprint.image,
                                ['hover'] = blueprint.imageHovered,
                                ['active'] = blueprint.imageActive,
                            },
                        })
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

