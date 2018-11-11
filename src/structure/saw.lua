Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "SAW"
        MeleeTower.init(self, animationController:createInstance(self.towerType), gridOrigin, worldOrigin, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT, constants.STRUCTURE.SAW.COST)
        self.targettingRadius = constants.STRUCTURE.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.SAW.ATTACK_DAMAGE
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        MeleeTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
}