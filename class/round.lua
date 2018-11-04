Round = Class{
    init = function(self, id, enemies)
        self.id = id -- For referencing rounds.lua 
        self.enemies = enemies -- Table consisting of instantiated enemy objects
        self.canSpawn = false -- canSpawn true when player is ready to start round, round ends on all enemies dead
        self.enemiesSpawned = 0
        self.maxTowers = 1
        self.towersPlaced = 0
    end;

}