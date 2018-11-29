World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil
        self.spawnAnimation = animationController:createInstance("SPAWN") --TODO: Put this somewhere better
        self.goalAnimation = animationController:createInstance("GOAL")
        self.structures = {}
        self.enemies = {}
        self.projectiles = {}
        self.impacts = {}
        self.collisionWorld = bump.newWorld(constants.GRID.CELL_SIZE/4)
        self:setupTimers()

        self.collisionWorld:add(inputController.mouse, inputController.mouse:calculateHitbox())
    end;
    placeStructure = function(self, gridOrigin, type, orientation)
        if not self.grid:isValidGridCoords(gridOrigin) then return end
        if type == "SAW" then
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.SAW.COST) then
                    self:addNewTower(Saw(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)))
                end
            end
        elseif type == "CANNON" then
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.CANNON.WIDTH, constants.STRUCTURE.CANNON.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.CANNON.COST) then
                    self:addNewTower(Cannon(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)))
                end
            end
        elseif type == "OBSTACLE" then
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.OBSTACLE.COST) then
                    self:addNewObstacle(Obstacle(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)))
                end
            end
        elseif type == "LASERGUN" then 
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.LASERGUN.WIDTH, constants.STRUCTURE.LASERGUN.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.LASERGUN.COST) then
                    self:addNewTower(Lasergun(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin), orientation))
                end
            end
        elseif type == "BEACON" then 
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.BEACON.WIDTH, constants.STRUCTURE.BEACON.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.BEACON.COST) then
                    self:addNewTower(Beacon(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)))
                end
            end
        elseif type == "BOUNCER" then 
            if not self.grid:isOccupied(gridOrigin, constants.STRUCTURE.BOUNCER.WIDTH, constants.STRUCTURE.BOUNCER.HEIGHT) then
                if playerController.wallet:canAfford(constants.STRUCTURE.BOUNCER.COST) then
                    self:addNewTower(Bouncer(gridOrigin, self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)))
                end
            end
        end
    end;
    addNewStructure = function(self, structure)
        table.insert(self.structures, structure)
        self.grid:occupySpaces(structure)
        self.grid:calculatePaths()
        audioController:playAny("PLACE_STRUCTURE")

        playerController:newStructurePlaced(structure)
    end;
    addNewObstacle = function(self, obstacle)
        cameraController:shake(0.3, 0.7)
        self:addNewStructure(obstacle)
    end;
    addNewTower = function(self, newTower)
        self.collisionWorld:add(newTower, newTower:calculateHitbox())
        self.collisionWorld:add(newTower.auraHitbox, newTower:calculateAuraHitbox())
        cameraController:shake(0.4, 1)
        self:addNewStructure(newTower)
    end;
    removeStructure = function(self, structure)
        assert(structure)
        if structure.type == "TOWER" then 
            self.collisionWorld:remove(structure.auraHitbox)
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
    spawnEnemyAt = function(self, gridOrigin)
        local worldOrigin = self.grid:calculateWorldCoordinatesFromGrid(gridOrigin)
        if self.grid:isValidGridCoords(gridOrigin) and self.grid:isSpawnable(gridOrigin) then
            if roundController:canSpawn() then 
                local newEnemy = roundController:nextEnemy()
                newEnemy.worldOrigin = (Vector(worldOrigin.x + constants.GRID.CELL_SIZE/2, worldOrigin.y + constants.GRID.CELL_SIZE/2))
                table.insert(self.enemies, newEnemy)
                self.collisionWorld:add(newEnemy, newEnemy:calculateHitbox())
            end
        end
    end;
    update = function(self, dt)
        self.grid:update(dt)
        for i, structure in pairs(self.structures) do
            structure:update(dt)
            self:processCollisionForTower(structure)
        end

        for i = #self.projectiles, 1, -1 do
            self.projectiles[i]:update(dt)
            self:processCollisionForProjectile(self.projectiles[i], dt)

            if not self.projectiles[i].markedForDeath and (self.projectiles[i].archetype == "HOMING" and not self.projectiles[i].target) then
                self:findNewTargetForProjectile(self.projectiles[i])
            end

            if self.projectiles[i].markedForDeath then
                self.collisionWorld:remove(self.projectiles[i])
                if self.projectiles[i].targettingHitbox then
                    self.collisionWorld:remove(self.projectiles[i].targettingHitbox)
                end
                table.remove(self.projectiles, i)
            end
        end

        for i = #self.impacts, 1, -1 do
            self.impacts[i]:update(dt)
            if self.impacts[i].collides and self.impacts[i].active then
                self:processCollisionForImpact(self.impacts[i], dt)
                self.collisionWorld:remove(self.impacts[i])
                self.impacts[i]:deactivate()
            end

            if self.impacts[i].markedForDeath then
                table.remove(self.impacts, i)
            end
        end

        for i = #self.enemies, 1, -1 do
            if not self.enemies[i].markedForDeath then
                self.enemies[i]:update(dt, self.grid:getCell(self.grid:calculateGridCoordinatesFromWorld(self.enemies[i].worldOrigin)))
            end
            
            if self.enemies[i].markedForDeath then
                playerController.wallet:refund(self.enemies[i].yield, self.enemies[i].worldOrigin)
            end

            if self.enemies[i].markedForDeath or self.enemies[i].hitGoal then 
                self.collisionWorld:remove(self.enemies[i]) 
                table.remove(self.enemies, i)
                roundController:enemyDefeated()
            end
        end

        -- Loop over the alive enemies FORWARDS detecting collisions. Doing it forwards ensures targetted towers pick the next enemy, rather than the last
        for i, enemy in pairs(self.enemies) do
            self:processCollisionForEnemy(enemy, dt)
        end

        local camX, camY = cameraController:mousePosition()
        local actualX, actualY, cols, len = self.collisionWorld:move(inputController.mouse, camX - inputController.mouse.width/2, camY - inputController.mouse.height/2, function() return "cross" end)

        for i = 1, len do
            local entity = cols[i].other
            if entity.type == "ENEMY" then
                entity:triggerHealthBar()
            end
        end

        if roundController:isEnemyPhase() then
            self.spawnTimer:update(dt)
        end

        animationController:updateSpriteInstance(self.spawnAnimation, dt)
        animationController:updateSpriteInstance(self.goalAnimation, dt)
    end;
    draw = function(self)
        self.grid:draw(roundController:isEnemyPhase())
        for i, structure in pairs(self.structures) do
            if not self.grid.validPath and playerController.lastPlacedStructure.gridOrigin == structure.gridOrigin then
                structure:draw(true)
            else
                structure:draw(false)
            end
        end

        Util.l.resetColour()
        for i, projectile in pairs(self.projectiles) do
            projectile:draw()
        end

        for i, enemy in pairs(self.enemies) do
            enemy:draw()
        end

        for i, impact in pairs(self.impacts) do
            impact:draw()
        end

        if debug then 
            love.graphics.setColor(constants.COLOURS.DEBUG_HITBOX)
            love.graphics.setLineWidth(1)
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
                self:spawnEnemyAt(self.grid.spawn.gridOrigin)
            end
        end)

        for i, structure in pairs(self.structures) do
            if structure.type == "TOWER" then
                structure:resetTimers()
            end
        end
    end;
    processCollisionForEnemy = function(self, enemy, dt)
        local actualX, actualY, cols, len = self.collisionWorld:move(enemy, enemy.worldOrigin.x - constants.GRID.CELL_SIZE/4, enemy.worldOrigin.y - constants.GRID.CELL_SIZE/4,
        function(item, other)
            if other.type == "TOWER" then
                return "cross"
            else 
                return false
            end
        end)
        for i = len, 1, -1 do 
            local collision = cols[i]
            
            if collision.other.type == "TOWER" then
                if collision.other.archetype == "TARGETTED" then
                    collision.other:spottedEnemy(enemy)
                end
            end
        end
    end;
    processCollisionForTower = function(self, tower)
        if tower.armed then
            local x, y, width, height = tower:calculateHitbox()
            local actualX, actualY, cols, len = self.collisionWorld:check(tower, x, y,
            function(item, other)
                if other.type == "ENEMY" or other.type == "AURA" then
                    return "cross"
                else
                    return false
                end
            end)
            local playOnHit = true
            local createImpact = false
            for i = 1, len do 
                if cols[i].other.type == "ENEMY" then
                    if tower.archetype == "MELEE" and tower.towerType ~= "BEACON" then
                        tower:attack(cols[i].other, playOnHit)
                        playOnHit = false
                        tower:disarm()
                    elseif tower.archetype == "LINE" then
                        createImpact = true
                    elseif tower.archetype == "TARGETTED" then
                        print('yeet')
                    end
                elseif cols[i].other.type == "AURA" then
                    if tower.towerType == "BEACON" then
                        if cols[i].other.owner.towerType ~= "BEACON" then
                            tower:attack(cols[i].other.owner)
                            tower:disarm()
                        end
                    end
                end
            end
            if createImpact then
                --create an impact
                if tower.towerType == "LASERGUN" then
                    self:addImpact(tower:fireLaser())
                end
                tower:disarm()
            end
        elseif tower.archetype == "TARGETTED" then
            self:findNewTargetForTower(tower)
        end
    end;
    processCollisionForProjectile = function(self, projectile, dt)
        local actualX, actualY, cols, len = self.collisionWorld:move(projectile, projectile.worldOrigin.x - projectile.width/2, projectile.worldOrigin.y - projectile.height/2,
        function(item, other)
            if other.type == "ENEMY" and other == projectile.target then
                return "cross"
            else 
                return false
            end
        end)
        for i = len, 1, -1 do 
            local collision = cols[i]
      
            if collision.other.type == "ENEMY" and collision.other == projectile.target then
                local impact = projectile:hitTarget()
                if impact then 
                    self:addImpact(impact)
                end
            end
        end
    end;
    processCollisionForImpact = function(self, impact, dt)
        local actualX, actualY, cols, len = self.collisionWorld:check(impact, impact.worldOrigin.x, impact.worldOrigin.y,
        function(item, other)
            if other.type == "ENEMY" then
                return "cross"
            else return false
            end
        end)
        for i = 1, len do 
            local collision = cols[i]
            if collision.other.type == "ENEMY" then
                impact:attack(collision.other, dt)
            end
        end
    end;
    findNewTargetForProjectile = function(self, projectile)
        assert(projectile.targettingHitbox)
        local actualX, actualY, cols, len = self.collisionWorld:move(projectile.targettingHitbox, projectile.worldOrigin.x-projectile.targettingRadius*constants.GRID.CELL_SIZE/2, projectile.worldOrigin.y-projectile.targettingRadius*constants.GRID.CELL_SIZE/2,
        function(item, other)
            if other.type == "ENEMY" then
                return "cross"
            else
                return false
            end
        end)
        local centre = projectile:centre()
        local best = nil
        for i = len, 1, -1 do 
            local collision = cols[i]
            -- consider lowest distance enemy to target
            if collision.other.type == "ENEMY" and not projectile.hasHit[collision.other.id] then
                -- calculate distance from projectile centre to enemy. if lower than the best, become the best.
                local dist = Util.m.distanceBetween(centre.x, centre.y, collision.other.worldOrigin.x, collision.other.worldOrigin.y)
                if not best or (best and dist < best.dist) then
                    best = {dist = dist, enemy = collision.other}
                end
            end
        end
        if best then
            projectile:setTarget(best.enemy)
        else
            projectile.markedForDeath = true
        end
    end;
    findNewTargetForTower = function(self, tower)
        -- print('yeet')
    end;
    getStructureAt = function(self, gridOrigin)
        local cell = self.grid:getCell(gridOrigin)
        if cell then
            return cell.occupant
        end
    end;
    displayBlueprint = function(self, blueprint, screenOrigin)
        assert(blueprint)
        self.grid:displayBlueprint(blueprint, self.grid:calculateGridCoordinatesFromScreen(screenOrigin))
    end;
    addProjectile = function(self, projectile)
        self.collisionWorld:add(projectile, projectile:calculateHitbox())
        if projectile.targettingHitbox then
            self.collisionWorld:add(projectile.targettingHitbox, projectile:calculateTargettingHitbox())
        end
        table.insert(self.projectiles, projectile)
    end;
    addImpact = function(self, impact)
        if impact.collides then
            self.collisionWorld:add(impact, impact:calculateHitbox())
        end
        table.insert(self.impacts, impact)
    end;
    updateTowerHitbox = function(self, structure)
        assert(self.collisionWorld:hasItem(structure.auraHitbox))
        assert(self.collisionWorld:hasItem(structure))
        self.collisionWorld:update(structure.auraHitbox, structure:calculateAuraHitbox())
        self.collisionWorld:update(structure, structure:calculateHitbox())
    end;
}