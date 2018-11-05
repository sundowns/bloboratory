local g = anim8.newGrid(32, 32, assets.towers.saw:getWidth(), assets.towers.saw:getHeight())

Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        MeleeTower.init(self, assets.towers.saw, anim8.newAnimation(g('1-3',1), 0.05), gridOrigin, worldOrigin, constants.STRUCTURE.SAW.WIDTH, constants.STRUCTURE.SAW.HEIGHT)
        self.towerType = "SAW"
        self.targettingRadius = constants.STRUCTURE.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.STRUCTURE.SAW.ATTACK_DAMAGE
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
}