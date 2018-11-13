InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
        self.isPlacingTower = false
        self.mouse = Mouse(Vector(love.mouse.getPosition()))
    end;
    update = function(self, dt)
        if self.isPlacingTower then
            if playerController.currentBlueprint.image then
                world.grid:displayBlueprint(self.mouse.origin.x, self.mouse.origin.y, playerController.currentBlueprint)
            else
                world.grid:highlightCells(self.mouse.origin.x, self.mouse.origin.y, constants.STRUCTURE[playerController.currentBlueprint.name].WIDTH, constants.STRUCTURE[playerController.currentBlueprint.name].HEIGHT)
            end
        end
        self.mouse:update(dt)
    end;
    togglePlacingTower = function(self)
        self.isPlacingTower = not self.isPlacingTower
        if self.isPlacingTower then
            love.mouse.setCursor(self.placingTowerCursor)
        else
            love.mouse.setCursor()
        end
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
                world.grid:setSpawn(world.grid:calculateGridCoordinatesFromScreen(love.mouse.getPosition()))
            elseif key == "g" and roundController:isBuildPhase() then
                world.grid:setGoal(world.grid:calculateGridCoordinatesFromScreen(love.mouse.getPosition()))
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
    mousepressed = function(self, screen_x, screen_y, button)
        if nk.windowIsAnyHovered() then return end
        local gridX, gridY = world.grid:calculateGridCoordinatesFromScreen(screen_x, screen_y)
        if self.isPlacingTower then
            if world:placeStructure(gridX, gridY, playerController.currentBlueprint.name) then
                self:togglePlacingTower()
            end
        else
            playerController:toggleStructureSelection(world:getStructureAt(gridX, gridY)) 
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