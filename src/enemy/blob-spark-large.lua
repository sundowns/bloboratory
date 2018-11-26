BlobSparkLarge = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-SPARK-LARGE", "ELECTRIC", worldOrigin, constants.ENEMY.BLOBSPARKLARGE.HEALTH,
            constants.ENEMY.BLOBSPARKLARGE.SPEED, constants.ENEMY.BLOBSPARKLARGE.YIELD,
            animationController:createInstance("BLOB-SPARK-LARGE"), 2, 1)
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