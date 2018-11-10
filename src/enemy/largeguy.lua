LargeGuy = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEGUY", worldOrigin, constants.ENEMY.LARGEGUY.HEALTH, constants.ENEMY.LARGEGUY.SPEED, constants.ENEMY.LARGEGUY.YIELD, animationController:createInstance("BLOB-LARGE"))
    end;
    update = function(self, dt, currentCell)
        local destroy =  Enemy.update(self, dt, currentCell)
        --large guy specific logic
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}