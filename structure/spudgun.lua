local image = nil
local animationGrid = nil

SpudGun = Class {
    __includes=TargetedTower,
    init = function(self, gridOrigin, worldOrigin)
        TargetedTower.init(self, image, animationGrid, gridOrigin, worldOrigin, constants.STRUCTURE.SPUDGUN.WIDTH, constants.STRUCTURE.SPUDGUN.HEIGHT)
        self.towerType = "SPUDGUN"
        self.targettingRadius = constants.STRUCTURE.SPUDGUN.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.SPUDGUN.ATTACK_DAMAGE
        self.attackInterval = constants.STRUCTURE.SPUDGUN.ATTACK_INTERVAL

        self.attackTimer = Timer.new()

        self.attackTimer:every(self.attackInterval, function()
            if self.currentTarget then
                self:shoot()
            end
        end)
    end;
    update = function(self, dt)
        TargetedTower.update(self, dt)

        if self.currentTarget then
            self.attackTimer:update(dt)
        end
    end;
    shoot = function(self)
        local projOrigin = Vector(self.worldOrigin.x + constants.GRID.CELL_SIZE*self.width/2, self.worldOrigin.y + constants.GRID.CELL_SIZE*self.height/2)
        table.insert(self.projectiles, Spud(projOrigin, self.currentTarget, self.attackDamage))
    end;
}

Spud = Class {
    __includes=HomingProjectile,
    init = function(self, worldOrigin, target, damage)
        HomingProjectile.init(self, worldOrigin, target, constants.PROJECTILE.SPUD.SPEED)
        self.damage = damage
    end;
    update = function(self, dt)
        HomingProjectile.update(self, dt)
    end;
    draw = function(self)
        HomingProjectile.draw(self)
    end;
    hitTarget = function(self)
        if self.target then
            self.target:takeDamage(self.damage)
        end
    end;
}