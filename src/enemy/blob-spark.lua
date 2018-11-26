BlobSpark = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-SPARK", "ELECTRIC", worldOrigin, constants.ENEMY.BLOBSPARK.HEALTH,
            constants.ENEMY.BLOBSPARK.SPEED, constants.ENEMY.BLOBSPARK.YIELD,
            animationController:createInstance("BLOB-SPARK"), 4, 1)
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