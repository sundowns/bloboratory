World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil
        self.towers = {}
    end;
    placeTower = function(self, x, y)
        if not self.grid:isOccupied(x, y, constants.TOWER.WIDTH, constants.TOWER.HEIGHT) then
            local worldX, worldY = self.grid:calculateWorldCoordinates(x, y)
            table.insert(self.towers, Tower(x, y, worldX, worldY, constants.TOWER.WIDTH, constants.TOWER.HEIGHT))
            for i = x, x + constants.TOWER.WIDTH-1 do
                for j = y, y + constants.TOWER.HEIGHT-1 do
                    self.grid:toggleObstacle(i, j)
                end
            end

            return true --a tower was placed
        end
        return false --nothing placed
    end;
    update = function(self, dt, isPlacingTower)
        self.grid:update(dt, isPlacingTower)
        for i, tower in pairs(self.towers) do
            tower:update(dt)
        end
    end;
    draw = function(self)
        self.grid:draw()
        for i, tower in pairs(self.towers) do
            tower:draw()
        end
    end;
}