World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil
        self.towers = {}
        self.enemies = {}
        self.collisionWorld = bump.newWorld(constants.GRID.CELL_SIZE)
        self.isSpawning = false
        self:setupTimers()
    end;
    placeTower = function(self, gridX, gridY)
        if not self.grid:isOccupied(gridX, gridY, constants.TOWER.WIDTH, constants.TOWER.HEIGHT) then
            local worldX, worldY = self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)
            table.insert(self.towers, Tower(gridX, gridY, worldX, worldY, constants.TOWER.WIDTH, constants.TOWER.HEIGHT))
            for i = gridX, gridX + constants.TOWER.WIDTH-1 do
                for j = gridY, gridY + constants.TOWER.HEIGHT-1 do
                    self.grid:toggleObstacle(i, j)
                end
            end

            self.grid:calculatePaths()
            return true --a tower was placed
        end
        return false --nothing placed
    end;
    spawnEnemyAt = function(self, gridX, gridY)
        local worldX, worldY = self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)
        if self.grid:isValidGridCoords(gridX, gridY) and not self.grid:isSpawnable(gridX, gridY) then
            table.insert(self.enemies, SmallGuy(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2))
        end
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, tower in pairs(self.towers) do
            tower:update(dt)
        end

        for i, enemy in pairs(self.enemies) do
            local destroy = enemy:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(enemy.worldX, enemy.worldY)))
            if destroy then
                table.remove(self.enemies, i)
            end
        end

        if self.isSpawning then
            self.spawnTimer:update(dt)
        end
    end;
    draw = function(self)
        self.grid:draw(self.isSpawning)
        for i, tower in pairs(self.towers) do
            tower:draw()
        end

        for i, enemy in pairs(self.enemies) do
            enemy:draw()
        end
    end;
    setupTimers = function(self)
        self.spawnTimer = Timer.new()

        self.spawnTimer:every(constants.ENEMY.SPAWN_INTERVAL, function()
            if self.grid.spawn then
                self:spawnEnemyAt(self.grid.spawn.x, self.grid.spawn.y)
            end
        end)
    end;
    toggleSpawning = function(self)
        self.isSpawning = not self.isSpawning
    end;
}