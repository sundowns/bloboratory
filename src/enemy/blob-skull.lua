BlobSkull = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-SKULL", "NONE", worldOrigin, constants.ENEMY.BLOBSKULL.HEALTH,
            constants.ENEMY.BLOBSKULL.SPEED, constants.ENEMY.BLOBSKULL.YIELD,
            animationController:createInstance("BLOB-SKULL"), 5, 5)
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