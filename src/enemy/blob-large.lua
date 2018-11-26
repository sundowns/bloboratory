BlobLarge = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-LARGE", "NONE", worldOrigin, constants.ENEMY.BLOBLARGE.HEALTH,
            constants.ENEMY.BLOBLARGE.SPEED, constants.ENEMY.BLOBLARGE.YIELD,
            animationController:createInstance("BLOB-LARGE"), 1, 1)
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