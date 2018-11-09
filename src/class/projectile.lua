Projectile = Class {
    init = function(self, worldOrigin, speed)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(speed)
        self.worldOrigin = worldOrigin
        self.speed = speed
        self.markedForDeath = false
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
}

HomingProjectile = Class {
    __includes=Projectile,
    init = function(self, worldOrigin, target, speed)
        assert(target)
        Projectile.init(self, worldOrigin, speed)
        self.target = target
    end;
    update = function(self, dt)
        local dx = self.target.worldOrigin.x - self.worldOrigin.x 
        local dy = self.target.worldOrigin.y - self.worldOrigin.y
        self:moveBy(dx*dt*self.speed, dy*dt*self.speed)

        if self.target.markedForDeath then
            self.markedForDeath = true
        elseif math.abs(dx)+math.abs(dy) < constants.GRID.CELL_SIZE then --kinda hacky but it works
            self:hitTarget()
            self.markedForDeath = true
        end
    end;
    draw = function(self)
        Projectile.draw(self)
    end;
}