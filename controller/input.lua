InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
        self.isPlacingTower = false
    end;
    update = function(self, dt)
        if self.isPlacingTower then
            local mouseX, mouseY = love.mouse.getPosition()
            world.grid:highlightCells(mouseX, mouseY, constants.STRUCTURE[playerController.currentBlueprint].WIDTH, constants.STRUCTURE[playerController.currentBlueprint].HEIGHT)
        end
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
        if key == "1" and world.currentRound.obstaclesPlaced < world.currentRound.maxObstacles then
            playerController:setCurrentBlueprint(1)
        elseif tonumber(key) and world.currentRound.towersPlaced < world.currentRound.maxTowers then
            playerController:setCurrentBlueprint(tonumber(key))
        end

        if not self.isPlacingTower then
            if key == "e" then
                world:spawnEnemyAt(world.grid:calculateGridCoordinatesFromScreen(love.mouse.getPosition()))
            elseif key == "s" then
                world.grid:setSpawn(world.grid:calculateGridCoordinatesFromScreen(love.mouse.getPosition()))
            elseif key == "g" then
                world.grid:setGoal(world.grid:calculateGridCoordinatesFromScreen(love.mouse.getPosition()))
            elseif key == "space" then
                world:toggleSpawning()
            end
        end
    end;  
    mousepressed = function(self, screen_x, screen_y, button)
        local x, y = world.grid:calculateGridCoordinatesFromScreen(screen_x, screen_y)
        if self.isPlacingTower then
            if world:placeStructure(x, y, playerController.currentBlueprint) or world.currentRound.obstaclesPlaced >= world.currentRound.maxObstacles then
                self:togglePlacingTower()
            end
        end
    end;
}