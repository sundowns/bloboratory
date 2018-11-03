InputController = Class {
    init = function(self)
        --cargo doesnt cooperate with new cursor easy cause we cant :getData() in LOVE >11.0.
        self.placingTowerCursor = love.mouse.newCursor("asset/cursors/Green.png",assets.cursors.green:getWidth()/3, assets.cursors.green:getHeight()/3)
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
    end;  
    mousepressed = function(self, screen_x, screen_y, button)
        local x, y = world.grid:calculateGridCoordinates(screen_x, screen_y)
        if self.isPlacingTower then
            if world:placeTower(x, y) then
                self:togglePlacingTower()
            end
        else
            if world.grid:isOccupied(x, y) then
                if button == 1 then 
                    if love.keyboard.isDown("lshift") then
                        world.grid:toggleSpawn(x, y)
                    else
                        world.grid:toggleObstacle(x, y)
                    end
                elseif button == 2 then
                    world.grid:setGoal(x, y)
                end
            end
        end
    end;
}