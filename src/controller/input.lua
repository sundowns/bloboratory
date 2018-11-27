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
        if playerController.hasWon or playerController.hasLost then
            if key == "escape" then
                love.event.quit()
            else
                return
            end
        end
        if tonumber(key) and roundController:isBuildPhase() then
            playerController:setCurrentBlueprint(tonumber(key))
        end
        if key == "escape" then
            if not nk.windowIsHidden(constants.UI.PICKER.NAME) then 
                uiController.picker.prepareToHide = true
            elseif self.isPlacingTower then
                self:togglePlacingTower()
            end
        end
        if not self.isPlacingTower then
            if key == "x" and roundController:isBuildPhase() then 
                playerController:refundCurrentStructure()
            elseif key == "r" and roundController:isBuildPhase() then 
                playerController:rotateCurrentStructure()
            elseif key == "f" and playerController.currentSelectedStructure and roundController:isBuildPhase() then
                playerController:upgradeCurrentStructure("FIRE")
            elseif key == "i" and playerController.currentSelectedStructure and roundController:isBuildPhase() then
                playerController:upgradeCurrentStructure("ICE")
            elseif key == "e" and playerController.currentSelectedStructure and roundController:isBuildPhase() then
                playerController:upgradeCurrentStructure("ELECTRIC")
            end
        end
    end;  
    mousepressed = function(self, screenOrigin, button)
        if not self:isAboveTray(screenOrigin) or not nk.windowIsHidden(constants.UI.PICKER.NAME) or not nk.windowIsHidden(constants.UI.OPTIONS_MENU.NAME) then return end
        local gridOrigin = world.grid:calculateGridCoordinatesFromScreen(screenOrigin)
        if self.isPlacingTower then
            world:placeStructure(gridOrigin, playerController.currentBlueprint.name)
            if not love.keyboard.isDown('lshift', 'rshift') or not playerController.wallet:canAfford(playerController.currentBlueprint.cost) then
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
    isAboveTray = function(self, screenOrigin)
        return screenOrigin.y < love.graphics.getHeight() * constants.UI.CRUCIBLE.Y  
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
        local mouseX, mouseY = love.mouse.getPosition()
        self.origin = Vector(mouseX - self.width/2, mouseY - self.height/2)
    end;
    draw = function(self)
        love.graphics.rectangle('line', self.origin.x, self.origin.y, self.width, self.height)
    end;
    calculateHitbox = function(self)
        return self.origin.x, self.origin.y, self.width, self.height
    end;
    centre = function(self)
        return Vector(self.origin.x + self.width/2, self.origin.y + self.height/2)
    end;
}