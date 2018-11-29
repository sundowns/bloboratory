BlobTeethDark = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-TEETH-DARK", "NONE", worldOrigin, constants.ENEMY.BLOBTEETH_DARK.HEALTH,
            constants.ENEMY.BLOBTEETH_DARK.SPEED, constants.ENEMY.BLOBTEETH_DARK.YIELD,
            animationController:createInstance("BLOB-TEETH-DARK"), 7, 3)
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