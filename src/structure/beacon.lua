Beacon = Class {
    __includes=AuraTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "AURA"
        AuraTower.init(self, animationController:createInstance(self.towerType),
            gridOrigin, worldOrigin, constants.STRUCTURE.BEACON.WIDTH,
            constants.STRUCTURE.BEACON.HEIGHT, constants.STRUCTURE.BEACON.COST,
            constants.STRUCTURE.BEACON.ATTACK_DAMAGE, constants.STRUCTURE.BEACON.ATTACK_INTERVAL,
            constants.STRUCTURE.BEACON.TARGETTING_RADIUS
        )
    end;
    update = function(self, dt)
        AuraTower.update(self, dt)
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        AuraTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
}