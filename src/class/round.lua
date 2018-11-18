Round = Class{
    init = function(self, id)
        self.id = id -- For referencing rounds.lua 
        self.enemies = nil -- Table consisting of instantiated enemy objects
        self.totalEnemies = 0
        self.enemiesDefeated = 0
        self.enemiesSpawned = 0
        self.hasStarted = false
    end;
    getNextEnemy = function(self)
        local enemy = self.enemies[self.enemiesSpawned + 1]
        assert(enemy)
        self.enemiesSpawned = self.enemiesSpawned + 1
        return enemy
    end;
    peekNextEnemy = function(self) --use for enemy look-ahead (colouring spawner!)
        if self.enemies[self.enemiesSpawned + 1] then
            return self.enemies[self.enemiesSpawned + 1]
        end
    end;
    setEnemies = function(self, enemies)
        self.enemies = enemies
        self.totalEnemies = #self.enemies
    end;
    start = function(self)
        self.hasStarted = true
    end;
}