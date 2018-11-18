BlobFire = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-FIRE", "FIRE", worldOrigin, constants.ENEMY.BLOBFIRE.HEALTH, constants.ENEMY.BLOBFIRE.SPEED, constants.ENEMY.BLOBFIRE.YIELD, animationController:createInstance("BLOB-FIRE"))
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