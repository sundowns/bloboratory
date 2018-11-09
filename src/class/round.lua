Round = Class{
    init = function(self, id, enemies, maxTowers, maxObstacles)
        self.id = id -- For referencing rounds.lua 
        self.enemies = enemies -- Table consisting of instantiated enemy objects
        self.enemiesSpawned = 0
    end;

}