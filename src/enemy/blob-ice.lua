BlobIce = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ICE", "ICE", worldOrigin, constants.ENEMY.BLOBICE.HEALTH,
            constants.ENEMY.BLOBICE.SPEED, constants.ENEMY.BLOBICE.YIELD,
            animationController:createInstance("BLOB-ICE"), 3, 1)
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