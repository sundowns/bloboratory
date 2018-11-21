RoundController = Class {
    init = function(self)
        self.roundIndex = 1
        self.currentRound = Round(1)
        self.totalRounds = 20
        self.crucible = Crucible(3)
        self.ENEMY_BLUEPRINTS = require("src.enemy-blueprints")
    end;
    canSpawn = function(self)
        return self.currentRound.enemiesSpawned < #self.currentRound.enemies
    end;
    nextEnemy = function(self)
        local enemy = self.currentRound:getNextEnemy()
        Timer.after(constants.ENEMY.SPAWN_INTERVAL/2, function() self:updateCauldron() end) 
        return enemy
    end;
    enemyDefeated = function(self)
        self.currentRound.enemiesDefeated = self.currentRound.enemiesDefeated + 1
        if self.currentRound.enemiesDefeated == self.currentRound.totalEnemies then 
            self:nextRound()
        end
    end;
    nextRound = function(self)
        if self.roundIndex + 1 > self.totalRounds then
            playerController:victory()
        else
            self.crucible:reset()
            self.roundIndex = self.roundIndex + 1
            animationController:changeSpriteState(world.spawnAnimation, "DEFAULT")
            self.currentRound = Round(self.roundIndex)
            uiController.firstRun = true
        end
    end;
    startRound = function(self)
        if self:isBuildPhase() then
            -- build the crucible enemies
            local roundEnemies = self.crucible:constructEnemies(self.roundIndex, self.totalRounds) 
            if #roundEnemies > 0 then -- check they make sense
                self.currentRound:setEnemies(roundEnemies)
                world:setupTimers()
                self.currentRound:start()
                -- animationController:changeSpriteState(world.spawnAnimation, "SPAWNING")
                self:updateCauldron()
                audioController:playAny("START_ROUND")
                cameraController:shake(0.5, 3)
            else 
                --TODO: tell em to fuckoff
                print('[ERROR] Add enemies to crucible before starting round')
                return
            end
        end
    end;
    updateCauldron = function(self)
        local nextEnemy = self.currentRound:peekNextEnemy()
        if nextEnemy then
            animationController:changeSpriteState(world.spawnAnimation, "SPAWNING_"..nextEnemy.element)
        end
        --peek next enemy
        --change cauldron state based on a type
    end;
    isBuildPhase = function(self)
        return not self.currentRound.hasStarted
    end;
    isEnemyPhase = function(self)
        return self.currentRound.hasStarted
    end;
}