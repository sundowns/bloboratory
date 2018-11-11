World = Class {
    init = function(self, origin, rows, cols, rounds)
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
        self.floatingGains = {}
        self.gainTimer = Timer.new()
    end;
    placeStructure = function(self, gridX, gridY, type)
        if not self.grid:isValidGridCoords(gridX, gridY) then return end
        local placedTower = false
        if type == "SAW" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT) then
                if playerController.money >= constants.STRUCTURE.SAW.COST then
                    placedTower = self:addNewTower(Saw(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))
                end
            end
        elseif type == "CANNON" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.CANNON.WIDTH, constants.STRUCTURE.CANNON.HEIGHT) then
                if playerController.money >= constants.STRUCTURE.CANNON.COST then
                    placedTower = self:addNewTower(Cannon(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))
                end
            end
        elseif type == "OBSTACLE" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT) then
                if playerController.money >= constants.STRUCTURE.OBSTACLE.COST then
                    self:addNewStructure(Obstacle(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))

                    if playerController.money < constants.STRUCTURE.OBSTACLE.COST then
                        inputController:togglePlacingTower()
                    end
                end
            end
        end
        return placedTower
    end;
    addNewTower = function(self, newTower)
        table.insert(self.structures, newTower)
        self.collisionWorld:add(newTower, newTower:calculateHitbox())
        self.grid:occupySpaces(newTower)
        self.grid:calculatePaths()

        playerController:updateMoney(-newTower.cost)
        self:addFloatingGain('-'..newTower.cost, newTower.worldOrigin.x + newTower.width/2*constants.GRID.CELL_SIZE, newTower.worldOrigin.y, false)
        return true --a tower was placed  
    end;
    addNewStructure = function(self, newStructure)
        table.insert(self.structures, newStructure)
        self.grid:occupySpaces(newStructure)
        self.grid:calculatePaths()

        playerController:updateMoney(-newStructure.cost)
        self:addFloatingGain('-'..newStructure.cost, newStructure.worldOrigin.x + newStructure.width/2*constants.GRID.CELL_SIZE, newStructure.worldOrigin.y, false)
        return true --an obstacle was placed
    end;
    removeStructure = function(self, structure)
        assert(structure)
        if structure.type == "TOWER" then 
            self.collisionWorld:remove(structure)
        end
        self.grid:vacateSpacesForStructure(structure)
        for i, markedStructure in pairs(world.structures) do
            if markedStructure.worldOrigin == structure.worldOrigin then 
                table.remove(self.structures, i)
            end
        end
        self.grid:calculatePaths()
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
            end
        end
    end;
    addFloatingGain = function(self, amount, origin_x, origin_y, isPositive)
        local newVector = Vector(origin_x, origin_y)
        table.insert(self.floatingGains, FloatingText(amount, newVector, Vector(0,-0.5), isPositive)) 
        self.gainTimer:after(constants.CURRENCY.GAINS.TIME_TO_LIVE, function()
            table.remove(self.floatingGains, 1)
        end)
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, structure in pairs(self.structures) do
            structure:update(dt)
        end

        for i = #self.enemies, 1, -1 do
            self.enemies[i]:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(self.enemies[i].worldOrigin.x, self.enemies[i].worldOrigin.y)))
            if self.enemies[i].markedForDeath then
                playerController:updateMoney(self.enemies[i].yield)
                self:addFloatingGain("+"..self.enemies[i].yield, self.enemies[i].worldOrigin.x, self.enemies[i].worldOrigin.y, true)
            end

            if self.enemies[i].markedForDeath or self.enemies[i].hitGoal then 
                self.collisionWorld:remove(self.enemies[i]) 
                table.remove(self.enemies, i)
                self.currentRound.enemiesDefeated = self.currentRound.enemiesDefeated + 1
                if self.currentRound.enemiesDefeated == self.currentRound.totalEnemies then 
                    self:nextRound()
                end
            end
        end

        -- Loop over the alive enemies FORWARDS detecting collisions. Doing it forwards ensures targetted towers pick the next enemy, rather than the last
        for i, enemy in pairs(self.enemies) do
            self:processCollisionForEnemy(enemy, dt)
        end

        for i, gain in pairs(self.floatingGains) do
            gain:update(dt) 
        end
                    
        self.gainTimer:update(dt)

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

        Util.l.resetColour()
        for i, gain in pairs(self.floatingGains) do 
            gain:draw()
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
    startRound = function(self)
        if not self.currentRound.hasStarted then
            self:toggleSpawning()
            self.currentRound.hasStarted = true
        end
    end;
    nextRound = function(self)
        if self.rounds[(self.roundIndex + 1)] ~= nil then 
            self.roundIndex = self.roundIndex + 1
            self.currentRound = self.rounds[self.roundIndex]
        end 
    end;
    processCollisionForEnemy = function(self, enemy, dt)
        local actualX, actualY, cols, len = self.collisionWorld:move(enemy, enemy.worldOrigin.x - constants.GRID.CELL_SIZE/2, enemy.worldOrigin.y - constants.GRID.CELL_SIZE/2, function() return "cross" end)
        for j = #cols, 1, -1 do 
            local collision = cols[j]
            
            if collision.other.type == "TOWER" then
                if collision.other.archetype == "MELEE" then
                    collision.other:attack(collision.item, dt)

                    if collision.item.markedForDeath then
                        break; --exit the loop, this enemy is already dead
                    end
                elseif collision.other.archetype == "TARGETTED" then
                    collision.other:spottedEnemy(enemy)
                end
            end
        end
    end;
    getStructureAt = function(self, gridX, gridY)
        local cell = self.grid:getCell(gridX, gridY)
        if cell then
            return cell.occupant
        end
    end;
}