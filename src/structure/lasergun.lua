Lasergun = Class {
    __includes=LineTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "LASERGUN"
        self.orientation = "LEFT"
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
}