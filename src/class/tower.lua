Tower = Class {
    __includes=Structure,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        Structure.init(self, animation, gridOrigin, worldOrigin, width, height, cost)
        self.type = "TOWER" -- used to check for valid collisions
        self.mutation = nil
        self.mutable = true
        self.attackDamage = attackDamage
        self.attackInterval = attackInterval
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
    draw = function(self)
        Structure.draw(self)
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.targettingRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.targettingRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
}

MeleeTower = Class {
    __includes = Tower,
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        Tower.init(self, animation, gridOrigin, worldOrigin, width, height, cost, attackDamage, attackInterval)
        self.archetype = "MELEE"
        self.armed = false

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
    calculateAngleToTarget = function(self)
        if not self.currentTarget then return 0 end
        local centre = self:centre()
        local dy = centre.y - self.currentTarget.worldOrigin.y  
        local dx = self.currentTarget.worldOrigin.x - centre.x
        return math.atan2(dx, dy)
    end;
    update = function(self, dt)
        Tower.update(self, dt)

        if self.currentTarget and (not self:inRange(self.currentTarget) or self.currentTarget.markedForDeath or self.currentTarget.hitGoal)  then 
            self.currentTarget = nil
        end

        if self.currentTarget and self.targetIsNew then
            Timer.tween(self.rotationTime, self, {angleToTarget = self:calculateAngleToTarget()}, 'in-out-sine')
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
    draw = function(self)
        Tower.draw(self)
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