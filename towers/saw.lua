Saw = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        MeleeTower.init(self, "SAW", gridOrigin, worldOrigin, constants.TOWER.SAW.WIDTH, constants.TOWER.SAW.HEIGHT)
        self.targettingRadius = constants.TOWER.SAW.TARGETTING_RADIUS
        self.attackDamage = constants.TOWER.SAW.ATTACK_DAMAGE
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.targettingRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.targettingRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
}