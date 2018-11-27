BlobFireLarge = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-FIRE-LARGE", "FIRE", worldOrigin, constants.ENEMY.BLOBFIRELARGE.HEALTH,
            constants.ENEMY.BLOBFIRELARGE.SPEED, constants.ENEMY.BLOBFIRELARGE.YIELD,
            animationController:createInstance("BLOB-FIRE-LARGE"), 2, 1)
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