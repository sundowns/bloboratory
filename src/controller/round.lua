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
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH"]
                    },
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
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
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
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    }
                }
            },
            {
                roundIndex = 30,
                crucibleSlots = {
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-SKULL-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-TEETH-DARK"]
                    },
                    {
                        blueprint = self.ENEMY_BLUEPRINTS["BLOB-EYE"]
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
            self:unlockEnemies()
            self:lockEnemies()
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

            if self.roundIndex == 4 and not configController.settings.seenRefundTutorial then
                Timer.after(1, function()
                    helpController:addText('You can refund any existing towers for the full cost (including upgrades)', 20, {0.2,0.8,0})
                    configController:updateSetting('seenRefundTutorial', true)
                end)
            end

            if self.roundIndex == 5 and not configController.settings.seenBossTutorial then
                Timer.after(1, function()
                    helpController:addText('Steady now! Every 5th wave your maze will be tested by powerful boss monsters.', 20, {0.8,0.3,0})
                    configController:updateSetting('seenBossTutorial', true)
                end)
            end

            if self.roundIndex == 6 then 
                if not configController.settings.seenLargeTutorialOne then
                    Timer.after(1, function()
                        helpController:addText('Large blobs are now available. Be careful though, they are MUCH tougher than regular blobs!', 20, {0.2,0.8,0})
                        configController:updateSetting('seenLargeTutorial', true)
                    end)
                end
            end

            if self.roundIndex == 7 and not configController.settings.seenBeaconTutorial then
                Timer.after(1, function()
                    helpController:addText('Beacons can speed up the damage output of any nearby towers.', 20, {0.2,0.8,0})
                    configController:updateSetting('seenBeaconTutorial', true)
                end)
            end

            if self.roundIndex == 11 then 
                if not configController.settings.seenLargeTutorialTwo then
                    Timer.after(1, function()
                        helpController:addText('Large elemental enemies are now available! Be careful though, they are MUCH tougher than regular blobs!', 20, {0.2,0.8,0})
                        configController:updateSetting('seenLargeTutorial', true)
                    end)
                end
            end
            if self.roundIndex == 16 or self.roundIndex == 21 or self.roundIndex == 26 then 
                Timer.after(1, function()
                    helpController:addText('Enemies just got tougher. Don\'t get cocky! ', 20, {0.2,0.8,0})
                end)
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
    unlockEnemies = function(self)
        for i, enemy in pairs(self.ENEMY_BLUEPRINTS) do 
            if self.roundIndex == enemy.roundLocks[1] then 
                enemy.isUnlocked = true
            end
        end
    end;
    lockEnemies = function(self)
        for i, enemy in pairs(self.ENEMY_BLUEPRINTS) do 
            if self.roundIndex == enemy.roundLocks[2] then 
                enemy.isUnlocked = false
            end
        end
    end;
}