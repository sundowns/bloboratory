BlobIceLarge = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ICE-LARGE", "NONE", worldOrigin, constants.ENEMY.BLOBICELARGE.HEALTH,
            constants.ENEMY.BLOBICELARGE.SPEED, constants.ENEMY.BLOBICELARGE.YIELD,
            animationController:createInstance("BLOB-ICE-LARGE"), 1, 1)
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