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
        self.roundIndex = 1
        self.currentRound = rounds[(self.roundIndex)]
    end;
    placeTower = function(self, gridX, gridY, type)
        if type == "SAW" then
            if not self.grid:isOccupied(gridX, gridY, constants.TOWER.SAW.WIDTH, constants.TOWER.SAW.HEIGHT) then
                if self.currentRound.towersPlaced < self.currentRound.maxTowers then
                    local worldX, worldY = self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)
                    local newSaw = Saw(Vector(gridX, gridY), Vector(worldX, worldY))
                    table.insert(self.towers, newSaw)
                    self.collisionWorld:add(newSaw, newSaw:calculateHitbox())
                    self.currentRound.towersPlaced = self.currentRound.towersPlaced + 1

                    for i = gridX, gridX + newSaw.width-1 do
                        for j = gridY, gridY + newSaw.width-1 do
                            self.grid:toggleObstacle(i, j)
                        end
                    end
        
                    self.grid:calculatePaths()
                    return true --a tower was placed
                end
            end
        end
        return false --nothing placed
    end;
    spawnEnemyAt = function(self, gridX, gridY)
        local worldX, worldY = self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)
        if self.grid:isValidGridCoords(gridX, gridY) and not self.grid:isSpawnable(gridX, gridY) then
            if self.currentRound.enemiesSpawned < #self.currentRound.enemies then 
                --local newEnemy = SmallGuy(Vector(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2))
                local newEnemy = self.currentRound.enemies[self.currentRound.enemiesSpawned + 1]
                newEnemy.worldOrigin = (Vector(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2))
                table.insert(self.enemies, newEnemy)
                self.collisionWorld:add(newEnemy, newEnemy:calculateHitbox())
                self.currentRound.enemiesSpawned = self.currentRound.enemiesSpawned + 1
            else 
                self.isSpawning = false
                self.roundIndex = self.roundIndex + 1
                self.currentRound = rounds[self.roundIndex]
            end
        end
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, tower in pairs(self.towers) do
            tower:update(dt)
        end

        for i = #self.enemies, 1, -1 do
            local destroy = self.enemies[i]:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(self.enemies[i].worldOrigin.x, self.enemies[i].worldOrigin.y)))
            if destroy then
                self.collisionWorld:remove(self.enemies[i]) 
                table.remove(self.enemies, i)
            else 
                local actualX, actualY, cols, len = self.collisionWorld:move(self.enemies[i], self.enemies[i].worldOrigin.x - constants.GRID.CELL_SIZE/2, self.enemies[i].worldOrigin.y - constants.GRID.CELL_SIZE/2, function() return "cross" end)
                for j = #cols, 1, -1 do 
                    local collision = cols[j]
                    
                    if collision.other.type == "TOWER" then
                        if collision.other.towerType == "SAW" then
                            if collision.item:takeDamage(collision.other.attackDamage, dt) then
                                -- enemy still alive
                            else -- enemy died
                                self.collisionWorld:remove(self.enemies[i])
                                table.remove(self.enemies, i) 
                                print("RIP!")
                                break; --exit the loop, this enemy is already dead
                            end
                        end
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
            love.graphics.setColor(constants.COLOURS.ENEMY)
            local items, len = self.collisionWorld:getItems()
            for i =#items, 1, -1 do
                love.graphics.rectangle('line', self.collisionWorld:getRect(items[i]))
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