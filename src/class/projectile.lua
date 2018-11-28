Projectile = Class {
    init = function(self, worldOrigin, animation, speed, width, height, mutation)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(speed)
        assert(width)
        assert(height)
        self.type = "PROJECTILE"
        self.worldOrigin = worldOrigin
        self.animation = animation
        self.speed = speed
        self.width = width
        self.height = height
        self.markedForDeath = false
        self.mutation = mutation
        self.angle = 0
    end;
    update = function(self, dt)
        animationController:updateSpriteInstance(self.animation, dt)
    end;
    draw = function(self)
        animationController:drawProjectileSpriteInstance(self.animation, self.worldOrigin, 1, 1, self.angle)
    end;
    moveBy = function(self, dx, dy)
        self.worldOrigin = Vector(self.worldOrigin.x + dx, self.worldOrigin.y + dy)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x-self.width/2, self.worldOrigin.y-self.height/2, self.width, self.height
    end;
    hitTarget = function(self)
    end;
    centre = function(self)
        return Vector(self.worldOrigin.x + self.width/2, self.worldOrigin.y + self.height/2)
    end;
}

HomingProjectile = Class {
    __includes=Projectile,
    init = function(self, worldOrigin, anim, target, speed, width, height, mutation)
        assert(target)
        Projectile.init(self, worldOrigin, anim, speed, width, height, mutation)
        self.target = target
        self.archetype = "HOMING"
    end;
    calculateAngleToTarget = function(self)
        if not self.target then return 0 end
        local dy = self.worldOrigin.y - self.target.worldOrigin.y  
        local dx = self.target.worldOrigin.x - self.worldOrigin.x
        return math.atan2(dx, dy)
    end;
    setTarget = function(self, target)
        self.target = target
    end;
    update = function(self, dt)
        Projectile.update(self, dt)
        self.angle = self:calculateAngleToTarget()
        local dx = self.target.worldOrigin.x - self.worldOrigin.x 
        local dy = self.target.worldOrigin.y - self.worldOrigin.y
        local delta = Vector(dx, dy):normalizeInplace()
        self:moveBy(delta.x*dt*self.speed, delta.y*dt*self.speed)

        if self.target.markedForDeath or self.target.hitGoal then -- TODO: might need to change to handle bouncer as well
            self:hitTarget()
        end
    end;
    draw = function(self)
        Projectile.draw(self)
    end;
}
