Catapult = Class {
    __includes=TargettedTower,
    init = function(self, gridOrigin, worldOrigin)
        Catapult.init(self, "CATAPULT", gridOrigin, worldOrigin, constants.TOWER.CATAPULT.WIDTH, constants.TOWER.CATAPULT.HEIGHT)
        self.targettingRadius = constants.TOWER.CATAPULT.TARGETTING_RADIUS
        self.attackDamage = constants.TOWER.CATAPULT.ATTACK_DAMAGE
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.attackRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.attackRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.attackRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.attackRadius)) *constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
}