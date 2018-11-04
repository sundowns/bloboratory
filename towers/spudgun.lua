local image = nil

SpudGun = Class {
    __includes=TargetedTower,
    init = function(self, gridOrigin, worldOrigin)
        TargetedTower.init(self, "SPUDGUN", nil, gridOrigin, worldOrigin, constants.TOWER.SPUDGUN.WIDTH, constants.TOWER.SPUDGUN.HEIGHT)
        self.targettingRadius = constants.TOWER.SPUDGUN.TARGETTING_RADIUS
        self.attackDamage = constants.TOWER.SPUDGUN.ATTACK_DAMAGE
    end;
    update = function(self, dt)
        TargetedTower.update(self, dt)

        if self.currentTarget then
            self:shoot()
        end
    end;
    shoot = function(self)
        print(os.time())
    end;
}