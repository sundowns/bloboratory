RoundController = Class {
    init = function(self, rounds)
        self.roundIndex = 1
        self.rounds = rounds
        self.currentRound = self.rounds[self.roundIndex]
    end;
    canSpawn = function(self)
        return self.currentRound.enemiesSpawned < #self.currentRound.enemies
    end;
    nextEnemy = function(self)
        return self.currentRound:getNextEnemy()
    end;
    enemyDefeated = function(self)
        self.currentRound.enemiesDefeated = self.currentRound.enemiesDefeated + 1
        if self.currentRound.enemiesDefeated == self.currentRound.totalEnemies then 
            self:nextRound()
        end
    end;
    nextRound = function(self)
        if self.rounds[self.roundIndex + 1] then 
            self.roundIndex = self.roundIndex + 1
            self.currentRound = self.rounds[self.roundIndex]
        end 
        world.crucible:clear()
    end;
    startRound = function(self)
        if self:isBuildPhase() then
            world:toggleSpawning()
            self.currentRound:start()
        end
    end;
    isBuildPhase = function(self)
        return not self.currentRound.hasStarted
    end;
    isEnemyPhase = function(self)
        return self.currentRound.hasStarted
    end;
}