Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "SAW"
        MeleeTower.init(self, animationController:createInstance(self.towerType), gridOrigin, worldOrigin, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT)
        self.targettingRadius = constants.STRUCTURE.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.SAW.ATTACK_DAMAGE
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
}