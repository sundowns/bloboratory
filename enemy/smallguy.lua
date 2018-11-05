SmallGuy = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "SMALLGUY", worldOrigin, constants.ENEMY.SMALLGUY.HEALTH, constants.ENEMY.SMALLGUY.SPEED)
    end;
    update = function(self, dt, currentCell)
        local destroy = Enemy.update(self, dt, currentCell)
        --small guy specific logic
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
        love.graphics.circle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.ENEMY.SMALLGUY.RADIUS)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}