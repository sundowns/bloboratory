InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.isPlacingTower = false
        self.mouse = Mouse(Vector(love.mouse.getPosition()))
    end;
    update = function(self, dt)
        self.mouse:update(dt)
    end;
    togglePlacingTower = function(self)
        self.isPlacingTower = not self.isPlacingTower
    end;
    keypressed = function(self, key)
        if tonumber(key) and roundController:isBuildPhase() then
            playerController:setCurrentBlueprint(tonumber(key))
        end
        if key == "escape" then
            self:togglePlacingTower()
        end
        if not self.isPlacingTower then
            if key == "s" and roundController:isBuildPhase() then
                world.grid:setSpawn(world.grid:calculateGridCoordinatesFromScreen(self.mouse.origin), true)
            elseif key == "g" and roundController:isBuildPhase() then
                world.grid:setGoal(world.grid:calculateGridCoordinatesFromScreen(self.mouse.origin), true)
            elseif key == "r" and roundController:isBuildPhase() then 
                playerController:refundCurrentStructure()
            elseif key == "f" and playerController.currentSelectedStructure then
                if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.FIRE.COST) then
                    playerController.currentSelectedStructure:addMutation(FireMutation()) 
                end
            elseif key == "i" and playerController.currentSelectedStructure then
                if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ICE.COST) then
                    playerController.currentSelectedStructure:addMutation(IceMutation()) 
                end
            elseif key == "e" and playerController.currentSelectedStructure then
                if playerController.currentSelectedStructure.mutable and playerController.wallet:canAfford(constants.MUTATIONS.ELECTRIC.COST) then
                    playerController.currentSelectedStructure:addMutation(ElectricMutation()) 
                end
            end
            elseif key == "escape" then
                love.event.quit()
            end
    end;  
    mousepressed = function(self, screenOrigin, button)
        if nk.windowIsAnyHovered() and not nk.windowIsHidden(constants.UI.PICKER.NAME) and not nk.windowIsHidden(constants.UI.OPTIONS_MENU.NAME) then return end
        local gridOrigin = world.grid:calculateGridCoordinatesFromScreen(screenOrigin)
        if self.isPlacingTower then
            if world:placeStructure(gridOrigin, playerController.currentBlueprint.name) then
                self:togglePlacingTower()
            end
        else
            playerController:toggleStructureSelection(world:getStructureAt(gridOrigin)) 
        end
    end;
    draw = function(self)
        if debug then
            love.graphics.setColor(0,0.8,0,1)
            self.mouse:draw()
        end
    end;
}

Mouse = Class {
    init = function(self, origin)
        self.origin = origin
        self.width = constants.CAMERA.MOUSE.WIDTH
        self.height = constants.CAMERA.MOUSE.HEIGHT
        self.type = "MOUSE"
    end;
    update = function(self, dt)
        self.origin = Vector(love.mouse.getPosition())
    end;
    draw = function(self)
        love.graphics.rectangle('line', self.origin.x, self.origin.y, self.width, self.height)
    end;
    calculateHitbox = function(self)
        return self.origin.x, self.origin.y, self.width, self.height
    end;
}