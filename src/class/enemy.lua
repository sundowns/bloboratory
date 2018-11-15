local ORIENTATIONS = {
    RIGHT = math.rad(0),
    DOWN = math.rad(90),
    LEFT = math.rad(180),
    UP = math.rad(270)
}

Enemy = Class {
    init = function(self, enemyType, worldOrigin, health, speed, yield, animation)
        assert(worldOrigin.x and worldOrigin.y)
        self.type = "ENEMY" -- used to check for valid collisions
        self.enemyType = enemyType
        self.worldOrigin = worldOrigin
        self.maxHealth = health
        self.health = health
        self.showHealth = false
        self.healthTimer = 0
        self.speed = speed
        self.yield = yield
        self.animation = animation
        self.movingTo = nil
        self.markedForDeath = false
        self.hitGoal = false
        self.orientation = ORIENTATIONS.LEFT --angle in radians

        self.debuffs = {}
    end;
    update = function(self, dt, currentCell)
        if not currentCell then
            self.markedForDeath = true
        end
        if currentCell.isGoal then
            --TODO: reduce remaining leakcount somehow
            self.hitGoal = true
        end
        --decide direction to move based on current grid's came_from value (breadth first search)
        if self.movingTo == nil then
            self.movingTo = currentCell.cameFrom
            self:calculateDirection(currentCell)
        else
            local moveToX = self.movingTo.gridOrigin.x * constants.GRID.CELL_SIZE + constants.GRID.CELL_SIZE/2
            local moveToY = self.movingTo.gridOrigin.y * constants.GRID.CELL_SIZE + constants.GRID.CELL_SIZE/2

            if Util.m.withinVariance(self.worldOrigin.x, moveToX, 5) and Util.m.withinVariance(self.worldOrigin.y, moveToY, 5) then
                --If we are at the centre of the tile
                self.movingTo = nil
            else
                local delta = Vector(moveToX - self.worldOrigin.x, moveToY - self.worldOrigin.y):normalizeInplace()
                self:moveBy(delta.x*dt*self.speed, delta.y*dt*self.speed)
            end
        end 

        if self.animation then
            animationController:updateSpriteInstance(self.animation, dt)
        end

        self:updateDebuffs(dt)

        if self.showHealth then
            self.healthTimer = self.healthTimer - dt
            if self.healthTimer <= 0 then
                self.showHealth = false
            end
        end
    end;
    draw = function(self)
        if self.animation then
            Util.l.resetColour()
            animationController:drawEnemySpriteInstance(self.animation, self.worldOrigin, self.orientation)
        end

        if self.showHealth then
            local healthWidth = 32
            local healthHeight = 3
            local x, y = self.worldOrigin.x - constants.ENEMY.HEALTHBAR.WIDTH/2, self.worldOrigin.y - constants.GRID.CELL_SIZE/2
            love.graphics.setColor(0.8,0,0)
            love.graphics.rectangle('fill', x, y, constants.ENEMY.HEALTHBAR.WIDTH, healthHeight)
            love.graphics.setColor(0,0.8,0)
            love.graphics.rectangle('fill', x, y, healthWidth*self.health/self.maxHealth, healthHeight)
        end

        Util.l.resetColour()
        for i, debuff in pairs(self.debuffs) do
            debuff:draw(self.worldOrigin)
        end
    end;
    triggerHealthBar = function(self)
        self.showHealth = true
        self.healthTimer = constants.ENEMY.HEALTHBAR.TIMEOUT
    end;
    updateDebuffs = function(self, dt)
        for key, debuff in pairs(self.debuffs) do
            self.debuffs[key]:update(dt)

            if not self.debuffs[key].alive then
                self.debuffs[key]:deactivate(self)
                self.debuffs[key] = nil
            end
        end
    end;
    applyDebuff = function(self, debuff)
        assert(debuff and debuff.type)
        if not self.debuffs[debuff.type] then
            self.debuffs[debuff.type] = debuff
            self.debuffs[debuff.type]:activate(self)
        end
    end;
    takeDamage = function(self, damage, playHitSound, dt)
        if not dt then dt = 1 end -- allows the function to work with constant attacks (melee) and projectiles
        self.health = self.health - (damage*dt)
        if playHitSound then
            self.onHit:play()
        end
        self.markedForDeath = self.health < 0
        if self.markedForDeath then 
            self.deathSound:play()
        end
        self:triggerHealthBar()
    end;
    moveBy = function(self, dx, dy)
        self.worldOrigin = Vector(self.worldOrigin.x + dx, self.worldOrigin.y + dy)
    end;
    calculateDirection = function(self, from)
        if from and self.movingTo then
            if from.gridOrigin.x > self.movingTo.gridOrigin.x then
                Timer.tween(constants.ENEMY.ORIENTATION_CHANGE_TIME, self, {orientation = ORIENTATIONS.LEFT})
            end
            if from.gridOrigin.x < self.movingTo.gridOrigin.x then
                Timer.tween(constants.ENEMY.ORIENTATION_CHANGE_TIME, self, {orientation = ORIENTATIONS.RIGHT})
            end
            if from.gridOrigin.y > self.movingTo.gridOrigin.y then
                Timer.tween(constants.ENEMY.ORIENTATION_CHANGE_TIME, self, {orientation = ORIENTATIONS.UP})
            end
            if from.gridOrigin.y < self.movingTo.gridOrigin.y then
                Timer.tween(constants.ENEMY.ORIENTATION_CHANGE_TIME, self, {orientation = ORIENTATIONS.DOWN})
            end
        end
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x - constants.GRID.CELL_SIZE/4, self.worldOrigin.y - constants.GRID.CELL_SIZE/4, constants.GRID.CELL_SIZE/2, constants.GRID.CELL_SIZE/2
    end;
}