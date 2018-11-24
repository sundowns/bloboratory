BlobTeeth = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-TEETH", "NONE", worldOrigin, constants.ENEMY.BLOBTEETH.HEALTH,
            constants.ENEMY.BLOBTEETH.SPEED, constants.ENEMY.BLOBTEETH.YIELD,
            animationController:createInstance("BLOB-TEETH"), 6, 5)
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