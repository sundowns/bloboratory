Cannon = Class {
    __includes=TargetedTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "CANNON"

        TargetedTower.init(self,
            animationController:createInstance(self.towerType),
            gridOrigin, worldOrigin, constants.STRUCTURE.CANNON.WIDTH,
            constants.STRUCTURE.CANNON.HEIGHT, constants.STRUCTURE.CANNON.COST,
            constants.STRUCTURE.CANNON.ROTATION_TIME, constants.STRUCTURE.CANNON.ATTACK_DAMAGE,
            constants.STRUCTURE.CANNON.ATTACK_INTERVAL
        )

        self.targettingRadius = constants.STRUCTURE.CANNON.TARGETTING_RADIUS
    end;
    update = function(self, dt)
        TargetedTower.update(self, dt)
    end;
    shoot = function(self)
        local centre = self:centre()
        local newX = centre.x + constants.STRUCTURE.CANNON.BARREL_LENGTH*math.sin(self.angleToTarget)
        local newY = centre.y - constants.STRUCTURE.CANNON.BARREL_LENGTH*math.cos(self.angleToTarget)

        world:addProjectile(Cannonball(Vector(newX, newY), self.currentTarget, self.attackDamage, self.mutation))
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        MeleeTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
}

Cannonball = Class {
    __includes=HomingProjectile,
    init = function(self, worldOrigin, target, damage, mutation)
        self.projectileType = "CANNONBALL"
        local anim = nil
        if mutation then
            anim = animationController:createInstance(self.projectileType..'-'..mutation.id)
        else
            anim = animationController:createInstance(self.projectileType)
        end
        HomingProjectile.init(self, worldOrigin, anim, target, constants.PROJECTILE.CANNONBALL.SPEED, constants.PROJECTILE.CANNONBALL.WIDTH, constants.PROJECTILE.CANNONBALL.HEIGHT, mutation)
        self.damage = damage
    end;
    update = function(self, dt)
        HomingProjectile.update(self, dt)
    end;
    draw = function(self)
        HomingProjectile.draw(self)
    end;
    --hitTarget can optionally return an 'Impact', to inflict some AoE effect/damage
    hitTarget = function(self)
        HomingProjectile.hitTarget(self)
        if self.target then
            self.target:takeDamage(self.damage, true)

            if self.mutation then
                if self.mutation.areaOfEffect then
                    return self.mutation:createImpact(self.worldOrigin)
                else
                    self.mutation:attack(self.target, 1)
                end
            end
        elseif self.mutation.areaOfEffect then --if our enemy is dead, explode on the spot!
            return self.mutation:createImpact(self.worldOrigin)
        end
    end;
}