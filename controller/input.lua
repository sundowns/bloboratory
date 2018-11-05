InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
        self.isPlacingTower = false
        self.currentSelectedStructure = nil -- TODO: replace this with a proper collection of current base towers
    end;
    update = function(self, dt)
        if self.isPlacingTower then
            local mouseX, mouseY = love.mouse.getPosition()
            world.grid:highlightCells(mouseX, mouseY, constants.STRUCTURE[self.currentSelectedStructure].WIDTH, constants.STRUCTURE[self.currentSelectedStructure].HEIGHT)
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
        --TODO: clean up the below logic with proper tower collection/inventory (yikes)
        if key == "1" and world.currentRound.obstaclesPlaced < world.currentRound.maxObstacles then
            if not self.isPlacingTower or self.currentSelectedStructure == "OBSTACLE" then self:togglePlacingTower() end
            self.currentSelectedStructure = "OBSTACLE" -- TODO: Remove this hack when adding collection of towers
        elseif key == "2" and world.currentRound.towersPlaced < world.currentRound.maxTowers then
            if not self.isPlacingTower or self.currentSelectedStructure == "SAW"  then self:togglePlacingTower() end
            self.currentSelectedStructure = "SAW" -- TODO: Remove this hack when adding collection of towers
        elseif key == "3" and world.currentRound.towersPlaced < world.currentRound.maxTowers then
            if not self.isPlacingTower or self.currentSelectedStructure == "SPUDGUN" then self:togglePlacingTower() end
            self.currentSelectedStructure = "SPUDGUN" -- TODO: Remove this hack when adding collection of towers
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
            if world:placeStructure(x, y, self.currentSelectedStructure) or world.currentRound.obstaclesPlaced >= world.currentRound.maxObstacles then
                self:togglePlacingTower()
            end
        end
    end;
}