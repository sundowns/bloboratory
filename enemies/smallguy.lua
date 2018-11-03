SmallGuy = Class {
    __includes = Enemy,
    init = function(self, worldX, worldY)
        Enemy.init(self, worldX, worldY, constants.ENEMIES.SMALLGUY.HEALTH)
    end;
    -- update = function(self, dt)
    --     Enemy.update(self, dt)
    --     --small guy specific logic
    -- end;
}