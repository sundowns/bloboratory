World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil
        self.structures = {}
        self.enemies = {}
        self.collisionWorld = bump.newWorld(constants.GRID.CELL_SIZE/4)
        self.isSpawning = false
        self:setupTimers()

        self.collisionWorld:add(inputController.mouse, inputController.mouse:calculateHitbox())
    end;
    placeStructure = function(self, gridX, gridY, type)
        if not self.grid:isValidGridCoords(gridX, gridY) then return end
        local placedTower = false
        if type == "SAW" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.SAW.COST) then
                    placedTower = self:addNewTower(Saw(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))
                end
            end
        elseif type == "CANNON" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.CANNON.WIDTH, constants.STRUCTURE.CANNON.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.CANNON.COST) then
                    placedTower = self:addNewTower(Cannon(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))
                end
            end
        elseif type == "OBSTACLE" then
            if not self.grid:isOccupied(gridX, gridY, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.OBSTACLE.COST) then
                    self:addNewStructure(Obstacle(Vector(gridX, gridY), Vector(self.grid:calculateWorldCoordinatesFromGrid(gridX, gridY))))

                    if not playerController.wallet:canAfford(constants.STRUCTURE.OBSTACLE.COST) then
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

        playerController.wallet:charge(newTower:getTotalCost(), Vector(newTower.worldOrigin.x + newTower.width/2*constants.GRID.CELL_SIZE, newTower.worldOrigin.y))
        return true --a tower was placed  
    end;
    addNewStructure = function(self, newStructure)
        table.insert(self.structures, newStructure)
        self.grid:occupySpaces(newStructure)
        self.grid:calculatePaths()

        playerController.wallet:charge(newStructure:getTotalCost(), Vector(newStructure.worldOrigin.x + newStructure.width/2*constants.GRID.CELL_SIZE, newStructure.worldOrigin.y))
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
            if roundController:canSpawn() then 
                local newEnemy = roundController:nextEnemy()
                newEnemy.worldOrigin = (Vector(worldX + constants.GRID.CELL_SIZE/2, worldY + constants.GRID.CELL_SIZE/2))
                table.insert(self.enemies, newEnemy)
                self.collisionWorld:add(newEnemy, newEnemy:calculateHitbox())
            else 
                self.isSpawning = false
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
                playerController.wallet:refund(self.enemies[i].yield, self.enemies[i].worldOrigin)
            end

            if self.enemies[i].markedForDeath or self.enemies[i].hitGoal then 
                self.collisionWorld:remove(self.enemies[i]) 
                table.remove(self.enemies, i)
                roundController:enemyDefeated()
            end
        end

        local camX, camY = cameraController:mousePosition()
        local actualX, actualY, cols, len = self.collisionWorld:move(inputController.mouse, camX, camY, function() return "cross" end)

        for i = 1, len do
            local entity = cols[i].other
            if entity.type == "ENEMY" then
                entity:triggerHealthBar()
            end
        end

        -- Loop over the alive enemies FORWARDS detecting collisions. Doing it forwards ensures targetted towers pick the next enemy, rather than the last
        for i, enemy in pairs(self.enemies) do
            self:processCollisionForEnemy(enemy, dt)
        end

        self.isSpawning = roundController:isEnemyPhase()
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
    processCollisionForEnemy = function(self, enemy, dt)
        local actualX, actualY, cols, len = self.collisionWorld:move(enemy, enemy.worldOrigin.x - constants.GRID.CELL_SIZE/4, enemy.worldOrigin.y - constants.GRID.CELL_SIZE/4, function() return "cross" end)
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