local ORIENTATIONS = {
    RIGHT = math.rad(0),
    DOWN = math.rad(90),
    LEFT = math.rad(180),
    UP = math.rad(270)
}

Tower = Class {
    __includes=Structure,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        Structure.init(self, animation, gridOrigin, worldOrigin, width, height, cost)
        self.type = "TOWER" -- used to check for valid collisions
        self.mutation = nil
        self.mutable = true
        self.rotatable = false
        self.attackDamage = attackDamage
        self.attackInterval = attackInterval
        self.orientation = ORIENTATIONS.LEFT
    end;
    addMutation = function(self, mutation, animation)
        if not self.mutation then
            self.mutation = mutation
            self.animation = animation
            self:changeAnimationState("DEFAULT")
            audioController:playAny("UPGRADE_"..mutation.id)
            self.mutable = false
            playerController.wallet:charge(mutation.cost, Vector(self.worldOrigin.x + self.width/2*constants.GRID.CELL_SIZE, self.worldOrigin.y))
        end
    end;
    update = function(self, dt)
        Structure.update(self, dt)
    end;
    draw = function(self, blockingPath)        
        Structure.draw(self, blockingPath)
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.targettingRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.targettingRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
    rotateClockwise = function(self)
        if self.rotatable then
            self.orientation = self.orientation + math.rad(90)
            if self.orientation >= math.rad(360) then
                self.orientation = self.orientation - math.rad(360)
            end
            if self.angleToTarget then
                self.angleToTarget = self.angleToTarget + math.rad(90)
            end
            animationController:updateInstanceRotation(self.animation, self.orientation)
        end
    end;
}

MeleeTower = Class {
    __includes = Tower,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval, attackRange)
        Tower.init(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        self.archetype = "MELEE"
        self.armed = false
        self.targettingRadius = attackRange

        self.attackTimer = Timer.new()
        self.attackTimer:every(self.attackInterval, function()
            self:arm()
        end)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
        self.attackTimer:update(dt)
    end;
    attack = function(self, other, playOnHit)
        other:takeDamage(self.attackDamage, playOnHit, 1)

        if self.mutation then
            self.mutation:attack(other, 1)
        end
    end;
    addMutation = function(self, mutation, animation)
        Tower.addMutation(self, mutation, animation)
    end;
    arm = function(self)
        self.armed = true
    end;
    disarm = function(self)
        self.armed = false
    end;
    draw = function(self, blockingPath)
        if self.isSelected then
            love.graphics.setColor(constants.COLOURS.STRUCTURE_RANGE)
            love.graphics.rectangle('fill', self.worldOrigin.x - self.targettingRadius*constants.GRID.CELL_SIZE, self.worldOrigin.y - self.targettingRadius*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.width)*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.height)*constants.GRID.CELL_SIZE)
        end
        Tower.draw(self, blockingPath)
    end;
}

LineTower = Class {
    __includes = Tower,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval, lineLength, lineWidth)
        Tower.init(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        self.archetype = "LINE"
        self.armed = false
        self.lineLength = lineLength
        self.lineWidth = lineWidth
        self.rotatable = true

        self.attackTimer = Timer.new()
        self.attackTimer:every(self.attackInterval, function()
            self:arm()
        end)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
        self.attackTimer:update(dt)
    end;
    attack = function(self, other, playOnHit)
        other:takeDamage(self.attackDamage, playOnHit, 1)
        audioController:playAny("LASERGUN_SHOOT")
        if self.mutation then
            self.mutation:attack(other, 1)
        end
    end;
    addMutation = function(self, mutation, animation)
        Tower.addMutation(self, mutation, animation)
    end;
    arm = function(self)
        self.armed = true
    end;
    disarm = function(self)
        self.armed = false
    end;
    calculateHitbox = function(self)
        local x, y, width, height
        if self.orientation == ORIENTATIONS.LEFT then
            x = self.worldOrigin.x - self.lineLength * constants.GRID.CELL_SIZE
            y = self.worldOrigin.y + self.lineWidth * constants.GRID.CELL_SIZE
            width = self.lineLength * constants.GRID.CELL_SIZE
            height = (self.height - self.lineWidth) *constants.GRID.CELL_SIZE / 1.5
        elseif self.orientation == ORIENTATIONS.UP then
            x = self.worldOrigin.x + self.lineWidth * constants.GRID.CELL_SIZE
            y = self.worldOrigin.y - self.lineLength * constants.GRID.CELL_SIZE
            width = (self.height - self.lineWidth) *constants.GRID.CELL_SIZE / 1.5
            height = self.lineLength *constants.GRID.CELL_SIZE
        elseif self.orientation == ORIENTATIONS.RIGHT then
            x = self.worldOrigin.x + (self.width*constants.GRID.CELL_SIZE)
            y = self.worldOrigin.y + self.lineWidth * constants.GRID.CELL_SIZE
            width = self.lineLength *constants.GRID.CELL_SIZE
            height = (self.height - self.lineWidth) *constants.GRID.CELL_SIZE / 1.5
        elseif self.orientation == ORIENTATIONS.DOWN then
            x = self.worldOrigin.x + self.lineWidth * constants.GRID.CELL_SIZE
            y = self.worldOrigin.y + self.height * constants.GRID.CELL_SIZE
            width = (self.height - self.lineWidth) *constants.GRID.CELL_SIZE / 1.5
            height = self.lineLength *constants.GRID.CELL_SIZE
        end
        return x, y, width, height
    end;
    draw = function(self, blockingPath)
        if self.isSelected then
            love.graphics.setColor(constants.COLOURS.STRUCTURE_RANGE)
            love.graphics.rectangle('fill', self:calculateHitbox())
        end
        Tower.draw(self, blockingPath)
    end;
}

TargetedTower = Class {
    __includes = Tower,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, rotationTime, attackDamage, attackInterval)
        Tower.init(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        self.archetype = "TARGETTED"
        self.currentTarget = nil
        self.targetIsNew = false
        self.rotating = false
        self.angleToTarget = 0
        self.rotationTime = rotationTime

        self.attackTimer = Timer.new()
        self.attackTimer:every(self.attackInterval, function()
            self.canShoot = true
        end)
    end;
    spottedEnemy = function(self, enemy)
        if not self.currentTarget then
            self.currentTarget = enemy
            self.targetIsNew = true
            self.rotating = true
        end
    end;
    calculateAngleToTarget = function(self, extrapolateEnemyPosition, extrapolationTime)
        if not self.currentTarget then return 0 end
        local centre = self:centre()
        local dx, dy = 0
        if extrapolateEnemyPosition then
            local extrapolatedPosition = self.currentTarget:getExtrapolatedPosition(extrapolationTime)
            dy = centre.y - extrapolatedPosition.y  
            dx = extrapolatedPosition.x - centre.x
        else
            dy = centre.y - self.currentTarget.worldOrigin.y  
            dx = self.currentTarget.worldOrigin.x - centre.x
        end
        return math.atan2(dx, dy)
    end;
    update = function(self, dt)
        Tower.update(self, dt)

        if self.currentTarget and (not self:inRange(self.currentTarget) or self.currentTarget.markedForDeath or self.currentTarget.hitGoal)  then 
            self.currentTarget = nil
        end

        if self.currentTarget and self.targetIsNew then
            Timer.tween(self.rotationTime, self, {angleToTarget = self:calculateAngleToTarget()})
            Timer.after(self.rotationTime, function() self.rotating = false end)
            self.targetIsNew = false
        end

        if self.currentTarget and not self.rotating then
            self.angleToTarget = self:calculateAngleToTarget()
        end

        if not self.canShoot then
            self.attackTimer:update(dt)
        end

        if self.canShoot and self.currentTarget then
            self:shoot()
            self.canShoot = false
        end
    end;
    draw = function(self, blockingPath)
        if self.isSelected then
            love.graphics.setColor(constants.COLOURS.STRUCTURE_RANGE)
            love.graphics.rectangle('fill', self.worldOrigin.x - self.targettingRadius*constants.GRID.CELL_SIZE, self.worldOrigin.y - self.targettingRadius*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.width)*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.height)*constants.GRID.CELL_SIZE)
        end
        Tower.draw(self, blockingPath)
    end;
    addMutation = function(self, mutation, animation)
        Tower.addMutation(self, mutation, animation)
    end;
    inRange = function(self, enemy)
        assert(enemy and enemy.worldOrigin)
        local x, y, width, height = Tower.calculateHitbox(self)
        return enemy.worldOrigin.x > x and 
            enemy.worldOrigin.x < x + width and
            enemy.worldOrigin.y > y and
            enemy.worldOrigin.y < y + height
    end;
}
