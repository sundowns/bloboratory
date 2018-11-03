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
            local newTower = Tower(gridX, gridY, worldX, worldY, constants.TOWER.WIDTH, constants.TOWER.HEIGHT)
            table.insert(self.towers, newTower)
            self.collisionWorld:add(newTower, worldX, worldY, newTower.width + constants.TOWER.SAW.ATTACK_RANGE, newTower.height + constants.TOWER.SAW.ATTACK_RANGE)
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
            local newEnemy = SmallGuy(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2)
            table.insert(self.enemies, newEnemy)
            self.collisionWorld:add(newEnemy, worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        end
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, tower in pairs(self.towers) do
            tower:update(dt)
        end

        for i =#self.enemies, 1, -1 do
            local destroy = self.enemies[i]:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(self.enemies[i].worldX, self.enemies[i].worldY)))
            if destroy then
                table.remove(self.enemies, i)
                --self.collisionWorld:remove(self.enemies[i]) 
            else 
                local actualX, actualY, cols, len = self.collisionWorld:move(self.enemies[i], self.enemies[i].worldX, self.enemies[i].worldY, false)
                for j = #cols, 1, -1 do 
                    print("HEALTH: " .. cols[j].item.health)
                    if cols[j].item:processAttack(1) == true then -- enemy still alive
 
                    else 
                        self.collisionWorld:remove(self.enemies[i])
                        table.remove(self.enemies, i) -- enemy died
                        table.remove(cols, j)
                    end
                end
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


        if debug == true then 
            local items, len = self.collisionWorld:getItems()
            for i =#items, 1, -1 do
                local box_x, box_y, width, height = self.collisionWorld:getRect(items[i])
                love.graphics.rectangle('fill', box_x, box_y, width, height)
            end
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