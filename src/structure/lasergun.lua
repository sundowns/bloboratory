Lasergun = Class {
    __includes=LineTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "LASERGUN"
        LineTower.init(self, animationController:createInstance(self.towerType),
            gridOrigin, worldOrigin, constants.STRUCTURE.LASERGUN.WIDTH,
            constants.STRUCTURE.LASERGUN.HEIGHT, constants.STRUCTURE.LASERGUN.COST,
            constants.STRUCTURE.LASERGUN.ATTACK_DAMAGE, constants.STRUCTURE.LASERGUN.ATTACK_INTERVAL,
            constants.STRUCTURE.LASERGUN.LINE_LENGTH, constants.STRUCTURE.LASERGUN.LINE_WIDTH
        )
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        MeleeTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
    fireLaser = function(self)
        -- create an Impact 
        audioController:playAny("LASERGUN_SHOOT")
        local x, y, width, height = LineTower.calculateHitbox(self)
        local stats = {BASE_DAMAGE = self.attackDamage}
        local dimensions = {width = width, height = height}
        if self.mutation then
            local mutationStats = Util.t.copy(self.mutation.stats)
            mutationStats.BASE_DAMAGE = self.attackDamage
            if self.mutation.id == "FIRE" then
                return LaserFireImpact(Vector(x, y), mutationStats, dimensions)
            elseif self.mutation.id == "ELECTRIC" then
                return LaserElectricImpact(Vector(x, y), mutationStats, dimensions)
            elseif self.mutation.id == "ICE" then
                print('?')
                return LaserIceImpact(Vector(x, y), mutationStats, dimensions)
            end
        else
            return LaserImpact(Vector(x, y), stats, dimensions)
        end
    end;
}