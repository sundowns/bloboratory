Saw = Class {
    __includes=Tower,
    init = function(self, gridX, gridY, worldX, worldY, width, height)
        Tower:init(gridX, gridY, worldX, worldY, width, height)
        self.attackRange = constants.TOWER.SAW.ATTACK_RANGE
        self.attackDamage = constants.TOWER.SAW.ATTACK_DAMAGE
        self.attackSpeed = constants.TOWER.SAW.ATTACK_SPEED
    end;
}