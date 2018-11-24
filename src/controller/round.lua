RoundController = Class {
    init = function(self)
        self.roundIndex = 1
        self.currentRound = Round(1)
        self.totalRounds = 20
        self.crucible = Crucible(3)
        self.ENEMY_BLUEPRINTS = require("src.enemy-blueprints")
        self.bossRounds = {
            {
                roundIndex = 2,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                }
            },
            {
                roundIndex = 10,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                }
            },
            {
                roundIndex = 15,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    }
                }
            },
            {
                roundIndex = 20,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    }
                }
            },
        }
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
            for i, bossRound in pairs(self.bossRounds) do
                if bossRound.roundIndex == self.roundIndex then
                    self:prepareBossRound(bossRound)
                end
            end
            audioController:toggleRoundMusic() --TODO: different boss wave music!
        end
    end;
    prepareBossRound = function(self, bossRound)
        for i, slot in ipairs(bossRound.crucibleSlots) do
            self.crucible:setSlot(i, slot.blueprint)
        end
        self.crucible:lock()
    end;
    startRound = function(self)
        if self:isBuildPhase() then
            -- build the crucible enemies
            local roundEnemies = self.crucible:constructEnemies(self.roundIndex, self.totalRounds) 
            if #roundEnemies > 0 then
                self.currentRound:setEnemies(roundEnemies)
                world:setupTimers()
                self.currentRound:start()
                self:updateCauldron()
                audioController:playAny("START_ROUND")
                cameraController:shake(0.5, 3)
                audioController:toggleRoundMusic()
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
    end;
    isBuildPhase = function(self)
        return not self.currentRound.hasStarted
    end;
    isEnemyPhase = function(self)
        return self.currentRound.hasStarted
    end;
}