Saw = Class {
    __includes=Tower,
    init = function(self, gridOrigin, worldOrigin)
        Tower.init(self, "SAW", gridOrigin, worldOrigin, constants.TOWER.SAW.WIDTH, constants.TOWER.SAW.HEIGHT)
        self.attackRadius = constants.TOWER.SAW.ATTACK_RADIUS
        self.attackDamage = constants.TOWER.SAW.ATTACK_DAMAGE
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.attackRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.attackRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.attackRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.attackRadius)) *constants.GRID.CELL_SIZE
        -- return worldX, worldY, newSaw.width*constants.GRID.CELL_SIZE, newSaw.height*constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
}