Cannon = Class {
    __includes=TargetedTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "CANNON"
        self.cost = constants.STRUCTURE.CANNON.COST
        local animations = {
            animationController:createInstance(self.towerType)
        }

        TargetedTower.init(self, animations, gridOrigin, worldOrigin, constants.STRUCTURE.CANNON.WIDTH, constants.STRUCTURE.CANNON.HEIGHT)

        self.targettingRadius = constants.STRUCTURE.CANNON.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.CANNON.ATTACK_DAMAGE
        self.attackInterval = constants.STRUCTURE.CANNON.ATTACK_INTERVAL

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
        table.insert(self.projectiles, Cannonball(projOrigin, self.currentTarget, self.attackDamage))
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        local animations = {
            animationController:createInstance(self.towerType..'-'..mutation.id)
        }
        MeleeTower.addMutation(self, mutation, animations)
    end;
}

Cannonball = Class {
    __includes=HomingProjectile,
    init = function(self, worldOrigin, target, damage)
        HomingProjectile.init(self, worldOrigin, target, constants.PROJECTILE.CANNONBALL.SPEED)
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