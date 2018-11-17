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
        animationController:changeSpriteState(world.spawnAnimation, "DEFAULT")
        if self.rounds[self.roundIndex + 1] then 
            self.roundIndex = self.roundIndex + 1
            self.currentRound = self.rounds[self.roundIndex]
        end 
    end;
    startRound = function(self)
        if self:isBuildPhase() then
            self.currentRound:start()
            animationController:changeSpriteState(world.spawnAnimation, "SPAWNING")
        end
    end;
    isBuildPhase = function(self)
        return not self.currentRound.hasStarted
    end;
    isEnemyPhase = function(self)
        return self.currentRound.hasStarted
    end;
}