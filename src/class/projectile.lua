Projectile = Class {
    init = function(self, worldOrigin, speed, width, height, mutation)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(speed)
        assert(width)
        assert(height)
        self.type = "PROJECTILE"
        self.worldOrigin = worldOrigin
        self.speed = speed
        self.width = width
        self.height = height
        self.markedForDeath = false
        self.mutation = mutation
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.PROJECTILE)
        love.graphics.circle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.PROJECTILE.RADIUS)
    end;
    moveBy = function(self, dx, dy)
        self.worldOrigin = Vector(self.worldOrigin.x + dx, self.worldOrigin.y + dy)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x-self.width/2, self.worldOrigin.y-self.height/2, self.width, self.height
    end;
    hitTarget = function(self)
        print("[WARNING] projectile base hitTarget triggered. Missing subclass override?")
    end;
}

HomingProjectile = Class {
    __includes=Projectile,
    init = function(self, worldOrigin, target, speed, width, height, mutation)
        assert(target)
        Projectile.init(self, worldOrigin, speed, width, height, mutation)
        self.target = target
        self.archetype = "HOMING"
    end;
    update = function(self, dt)
        local dx = self.target.worldOrigin.x - self.worldOrigin.x 
        local dy = self.target.worldOrigin.y - self.worldOrigin.y
        local delta = Vector(dx, dy):normalizeInplace()
        self:moveBy(delta.x*dt*self.speed, delta.y*dt*self.speed)

        if self.target.markedForDeath or self.target.hitGoal then
            self.markedForDeath = true
        end
    end;
    draw = function(self)
        Projectile.draw(self)
    end;
}