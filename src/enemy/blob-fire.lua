BlobFire = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-FIRE", worldOrigin, constants.ENEMY.BLOB.HEALTH, constants.ENEMY.BLOB.SPEED, constants.ENEMY.BLOB.YIELD, animationController:createInstance("BLOB-FIRE"))
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