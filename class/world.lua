World = Class {
    init = function(self, origin, rows, cols, rounds, money)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil
        self.structures = {}
        self.enemies = {}
        self.collisionWorld = bump.newWorld(constants.GRID.CELL_SIZE)
        self.isSpawning = false
        self:setupTimers()
        self.rounds = rounds
        self.roundIndex = 1
        self.currentRound = self.rounds[(self.roundIndex)]
        self.money = money
    end;
    placeStructure = function(self, gridX, gridY, type)
        local placedTower = false
        if type == "SAW" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT) then
                placedTower = self:addNewTower(Saw(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)))) 
            end
        elseif type == "SPUDGUN" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.SPUDGUN.WIDTH, constants.STRUCTURE.SPUDGUN.HEIGHT) then
                placedTower = self:addNewTower(SpudGun(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)))) 
            end
        elseif type == "OBSTACLE" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT) then
                --place a new block
                if self:addNewStructure(Obstacle(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)))) then
                    self.currentRound.obstaclesPlaced = self.currentRound.obstaclesPlaced + 1
                end
            end
        end
        if placedTower then
            self.currentRound.towersPlaced = self.currentRound.towersPlaced + 1
        end
        return placedTower
    end;
    addNewTower = function(self, newTower)
        table.insert(self.structures, newTower)
        self.collisionWorld:add(newTower, newTower:calculateHitbox())
        self.grid:occupySpaces(newTower.gridOrigin.x, newTower.gridOrigin.y, newTower.width, newTower.height)
        self.grid:calculatePaths()
        return true --a tower was placed  
    end;
    addNewStructure = function(self, newStructure)
        table.insert(self.structures, newStructure)
        self.grid:occupySpaces(newStructure.gridOrigin.x, newStructure.gridOrigin.y, newStructure.width, newStructure.height)
        self.grid:calculatePaths()
        return true --an obstacle was placed
    end;
    spawnEnemyAt = function(self, gridX, gridY)
        local worldX, worldY = self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY)
        if self.grid:isValidGridCoords(gridX, gridY) and self.grid:isSpawnable(gridX, gridY) then
            if self.currentRound.enemiesSpawned < #self.currentRound.enemies then 
                local newEnemy = self.currentRound.enemies[self.currentRound.enemiesSpawned + 1]
                newEnemy.worldOrigin = (Vector(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2))
                table.insert(self.enemies, newEnemy)
                self.collisionWorld:add(newEnemy, newEnemy:calculateHitbox())
                self.currentRound.enemiesSpawned = self.currentRound.enemiesSpawned + 1
            else 
                self.isSpawning = false
                if self.rounds[(self.roundIndex + 1)] ~= nil then 
                    self.roundIndex = self.roundIndex + 1
                    self.currentRound = self.rounds[self.roundIndex]
                end 
            end
        end
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, structure in pairs(self.structures) do
            structure:update(dt)
        end

        for i = #self.enemies, 1, -1 do
            self.enemies[i]:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(self.enemies[i].worldOrigin.x, self.enemies[i].worldOrigin.y)))
            if self.enemies[i].markedForDeath then
                self.money = self.money + self.enemies[i].yield
                print("hey boss")
            end

            if self.enemies[i].markedForDeath or self.enemies[i].hitGoal then 
                self.collisionWorld:remove(self.enemies[i]) 
                table.remove(self.enemies, i)
                print("hi")
            else 
                self:processCollisionForEnemy(i, dt)
            end
        end

        if self.isSpawning then
            self.spawnTimer:update(dt)
        end
    end;
    draw = function(self)
        self.grid:draw(self.isSpawning)
        for i, structure in pairs(self.structures) do
            structure:draw()
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
    processCollisionForEnemy = function(self, index, dt)
        local enemy = self.enemies[index]
        local actualX, actualY, cols, len = self.collisionWorld:move(enemy, enemy.worldOrigin.x - constants.GRID.CELL_SIZE/2, enemy.worldOrigin.y - constants.GRID.CELL_SIZE/2, function() return "cross" end)
        for j = #cols, 1, -1 do 
            local collision = cols[j]
            
            if collision.other.type == "TOWER" then
                if collision.other.archetype == "MELEE" then
                    collision.item:takeDamage(collision.other.attackDamage, dt)

                    if collision.item.markedForDeath then
                        self.collisionWorld:remove(enemy)
                        table.remove(self.enemies, index) 
                        break; --exit the loop, this enemy is already dead
                    end
                elseif collision.other.archetype == "TARGETTED" then
                    collision.other:spottedEnemy(enemy)
                end
            end
        end
    end;
}