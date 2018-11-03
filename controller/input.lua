InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
        self.isPlacingTower = false
    end;
    update = function(self, dt)
        if self.isPlacingTower then
            world.grid:highlightCells(love.mouse.getPosition())
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
        if key == "t" then
            self:togglePlacingTower()
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
            if world:placeTower(x, y) then
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