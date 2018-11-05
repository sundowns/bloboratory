Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        MeleeTower.init(self, assets.towers.saw, gridOrigin, worldOrigin, constants.TOWER.SAW.WIDTH, constants.TOWER.SAW.HEIGHT)
        self.towerType = "SAW"
        self.targettingRadius = constants.TOWER.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.TOWER.SAW.ATTACK_DAMAGE
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
}