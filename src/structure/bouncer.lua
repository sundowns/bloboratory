Bouncer = Class {
    __includes=TargetedTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "BOUNCER"

        TargetedTower.init(self,
            animationController:createInstance(self.towerType),
            gridOrigin, worldOrigin, constants.STRUCTURE.BOUNCER.WIDTH,
            constants.STRUCTURE.BOUNCER.HEIGHT, constants.STRUCTURE.BOUNCER.COST,
            constants.STRUCTURE.BOUNCER.ROTATION_TIME, constants.STRUCTURE.BOUNCER.ATTACK_DAMAGE,
            constants.STRUCTURE.BOUNCER.ATTACK_INTERVAL
        )

        self.targettingRadius = constants.STRUCTURE.BOUNCER.TARGETTING_RADIUS
        self.mutable = false -- TODO: add back when we have animations, ceebs mocking them until then
    end;
    update = function(self, dt)
        TargetedTower.update(self, dt)
    end;
    shoot = function(self)
        local centre = self:centre()
        local newX = centre.x + constants.STRUCTURE.BOUNCER.BARREL_LENGTH*math.sin(self.angleToTarget)
        local newY = centre.y - constants.STRUCTURE.BOUNCER.BARREL_LENGTH*math.cos(self.angleToTarget)

        world:addProjectile(BouncerProjectile(Vector(newX, newY), self.currentTarget, self.attackDamage, self.mutation))
        audioController:playAny("CANNON_SHOOT")
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        MeleeTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
}

BouncerProjectile = Class {
    __includes=HomingProjectile,
    init = function(self, worldOrigin, target, damage, mutation)
        self.projectileType = "BOUNCERPROJECTILE"
        self.bouncesLeft = constants.PROJECTILE.BOUNCERPROJECTILE.BOUNCES
        self.targettingRadius = constants.PROJECTILE.BOUNCERPROJECTILE.TARGETTING_RADIUS
        self.hasHit = {}
        local anim = nil
        if mutation then
            anim = animationController:createInstance("CANNONBALL"..'-'..mutation.id) --TODO: make this use bouncer image
        else
            anim = animationController:createInstance("CANNONBALL") --TODO: make this use bouncer image
        end
        HomingProjectile.init(self, worldOrigin, anim, target, constants.PROJECTILE.BOUNCERPROJECTILE.SPEED, constants.PROJECTILE.BOUNCERPROJECTILE.WIDTH, constants.PROJECTILE.BOUNCERPROJECTILE.HEIGHT, mutation)
        self.targettingHitbox = Hitbox(self, "BOUNCERTARGETTING", self:calculateTargettingHitbox())
        self.damage = damage
    end;
    update = function(self, dt)
        HomingProjectile.update(self, dt)
    end;
    draw = function(self)
        HomingProjectile.draw(self)
    end;
    calculateTargettingHitbox = function(self)
        return self.worldOrigin.x - self.targettingRadius * constants.GRID.CELL_SIZE, self.worldOrigin.y - self.targettingRadius * constants.GRID.CELL_SIZE, self.width + self.targettingRadius * constants.GRID.CELL_SIZE, self.height + self.targettingRadius * constants.GRID.CELL_SIZE
    end;
    --hitTarget can optionally return an 'Impact', to inflict some AoE effect/damage
    hitTarget = function(self)
        HomingProjectile.hitTarget(self)
        if self.target then
            self.target:takeDamage(self.damage, true)
            self.bouncesLeft = self.bouncesLeft - 1
            self.damage = self.damage/2
            self.hasHit[self.target.id] = true
            if self.bouncesLeft <= 0 then
                self.markedForDeath = true
            end

            if self.mutation then
                if self.mutation.areaOfEffect then
                    self.target = nil
                    return self.mutation:createImpact(self.worldOrigin)
                else
                    self.mutation:attack(self.target, 1)
                end
            else
                self.target = nil 
                return DefaultImpact(self.worldOrigin)
            end
        elseif self.mutation.areaOfEffect then --if our enemy is dead, explode on the spot!
            self.target = nil
            return self.mutation:createImpact(self.worldOrigin)
        end
    end;
}