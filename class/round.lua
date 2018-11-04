Round = Class{
    init = function(self, id, enemies)
        self.id = id -- For referencing rounds.lua 
        self.enemies = enemies -- Table consisting of instantiated enemy objects
        self.enemiesSpawned = 0
        self.maxTowers = 5
        self.towersPlaced = 0
    end;

}