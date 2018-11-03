SmallGuy = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "SMALLGUY", worldOrigin, constants.ENEMY.SMALLGUY.HEALTH, constants.ENEMY.SMALLGUY.SPEED)
    end;
    update = function(self, dt, currentCell)
        local destroy =  Enemy.update(self, dt, currentCell)
        --small guy specific logic
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}