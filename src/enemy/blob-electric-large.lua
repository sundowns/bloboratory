BlobElectricLarge = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ELECTRIC-LARGE", "ELECTRIC", worldOrigin, constants.ENEMY.BLOBELECTRICLARGE.HEALTH,
            constants.ENEMY.BLOBELECTRICLARGE.SPEED, constants.ENEMY.BLOBELECTRICLARGE.YIELD,
            animationController:createInstance("BLOB-ELECTRIC-LARGE"), 2, 1)
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