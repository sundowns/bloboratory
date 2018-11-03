SmallGuy = Class {
    __includes = Enemy,
    init = function(self, worldX, worldY)
        Enemy.init(self, worldX, worldY, constants.ENEMY.SMALLGUY.HEALTH, constants.ENEMY.SMALLGUY.SPEED)
    end;
    update = function(self, dt, currentCell)
        local destroy =  Enemy.update(self, dt, currentCell)
        --small guy specific logic
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end
}