InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
        self.isPlacingTower = false
        self.currentSelectedTower = "SAW" -- TODO: replace this with a proper collection of current base towers
    end;
    update = function(self, dt)
        if self.isPlacingTower then
            local mouseX, mouseY = love.mouse.getPosition()
            world.grid:highlightCells(mouseX, mouseY, constants.TOWER[self.currentSelectedTower].WIDTH, constants.TOWER[self.currentSelectedTower].HEIGHT)
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
        if key == "t" and world.currentRound.towersPlaced < world.currentRound.maxTowers then
            self:togglePlacingTower()
        elseif key == "1" then
            self.currentSelectedTower = "SAW" -- TODO: Remove this hack when adding collection of towers
        elseif key == "2" then
            self.currentSelectedTower = "SPUDGUN" -- TODO: Remove this hack when adding collection of towers
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
            if world:placeTower(x, y, self.currentSelectedTower) then
                self:togglePlacingTower()
            end
        else
            if button == 1 then 
                world.grid:toggleObstacle(x, y)
                world.grid:calculatePaths()
            end
        end
    end;
}