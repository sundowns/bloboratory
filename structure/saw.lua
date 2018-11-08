Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "SAW"
        self.cost = constants.STRUCTURE.SAW.COST
        local animations = {
            animationController:createInstance(self.towerType)
        }
        MeleeTower.init(self, animations, gridOrigin, worldOrigin, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT)
        self.targettingRadius = constants.STRUCTURE.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.SAW.ATTACK_DAMAGE

    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        local animations = {
            animationController:createInstance(self.towerType..'-'..mutation.id)
        }
        MeleeTower.addMutation(self, mutation, animations)
    end;
}