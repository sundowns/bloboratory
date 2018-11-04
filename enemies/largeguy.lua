LargeGuy = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEGUY", worldOrigin, constants.ENEMY.LARGEGUY.HEALTH, constants.ENEMY.LARGEGUY.SPEED)
    end;
    update = function(self, dt, currentCell)
        local destroy =  Enemy.update(self, dt, currentCell)
        --large guy specific logic
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
        love.graphics.circle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.ENEMY.LARGEGUY.RADIUS)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}