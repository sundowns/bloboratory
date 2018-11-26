RoundController = Class {
    init = function(self)
        self.roundIndex = 1
        self.readyToStart = false
        self.currentRound = Round(1)
        self.totalRounds = 30
        self.crucible = Crucible(3)
        self.ENEMY_BLUEPRINTS = require("src.enemy-blueprints")
        self.bossRounds = {
            {
                roundIndex = 5,
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
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                }
            },
            {
                roundIndex = 15,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
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
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL"]
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
            {
                roundIndex = 25,
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
            {
                roundIndex = 30,
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
    update = function(self, dt)
        if self.readyToStart then
            roundController:startRound()
            self.readyToStart = false
        end
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

            if self.roundIndex == 2 and not configController.settings.seenMultiSelectTutorial then
                Timer.after(1, function()
                    helpController:addText('Try holding SHIFT to place multiple structures quickly!', 20, {0.2,0.8,0})
                    configController:updateSetting('seenMultiSelectTutorial', true)
                end)
            end

            if self.roundIndex == 3 and not configController.settings.seenUpgradeTutorial then
                Timer.after(1, function()
                    helpController:addText('You can create hybrid towers by spending the currency you gain from defeating elemental blobs!', 20, {0.2,0.8,0})
                    configController:updateSetting('seenUpgradeTutorial', true)
                end)
            end

            if self.roundIndex == 6 then 
                for i, enemy in pairs(self.ENEMY_BLUEPRINTS) do 
                    if enemy.name ~= "BLOB (SKULL)" and enemy.name ~= "BLOB (TEETH)" then 
                        enemy.isUnlocked = true
                    end
                end
                if not configController.settings.seenLargeTutorial then
                    Timer.after(1, function()
                        helpController:addText('Large blobs are now available. Be careful though, they are much tougher than regular blobs!', 20, {0.2,0.8,0})
                        configController:updateSetting('seenLargeTutorial', true)
                    end)
                end
            end
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
                helpController:addText("You must select enemies to send before the round can begin!", nil, {0.8,0.3,0})
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