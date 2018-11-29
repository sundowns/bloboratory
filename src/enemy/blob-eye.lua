BlobEye = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-EYE", "NONE", worldOrigin, constants.ENEMY.BLOBEYE.HEALTH,
            constants.ENEMY.BLOBEYE.SPEED, constants.ENEMY.BLOBEYE.YIELD,
            animationController:createInstance("BLOB-EYE"), 6, 3)
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