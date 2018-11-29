BlobSkullDark = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-SKULL-DARK", "NONE", worldOrigin, constants.ENEMY.BLOBSKULL_DARK.HEALTH,
            constants.ENEMY.BLOBSKULL_DARK.SPEED, constants.ENEMY.BLOBSKULL_DARK.YIELD,
            animationController:createInstance("BLOB-SKULL-DARK"), 5, 5)
    end;
    update = function(self, dt, currentCell)
        local destroy = Enemy.update(self, dt, currentCell)
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}