require("src.class.currency")
require("src.class.wallet")

PlayerController = Class {
    init = function(self)
        self.STRUCTURE_BLUEPRINTS = {
            ["OBSTACLE"] = StructureBlueprint("OBSTACLE", assets.blueprints.obstacle, 1, 1, 2, 2, 0, "NONE"),
            ["SAW"] = StructureBlueprint("SAW", assets.blueprints.saw, 2, 2, 1, 1, {radius = constants.STRUCTURE.SAW.TARGETTING_RADIUS}, "RADIUS"),
            ["CANNON"] = StructureBlueprint("CANNON", assets.blueprints.cannon, 2, 2, 1, 1, {radius = constants.STRUCTURE.CANNON.TARGETTING_RADIUS}, "RADIUS"),
            ["LASERGUN"] = StructureBlueprint("LASERGUN", assets.blueprints.lasergun, 2, 2, 1, 1, {length = constants.STRUCTURE.LASERGUN.LINE_LENGTH, width = constants.STRUCTURE.LASERGUN.LINE_WIDTH}, "LINE"),
            ["BOUNCER"] = StructureBlueprint("BOUNCER", assets.blueprints.bouncer, 2, 2, 1, 1, {radius = constants.STRUCTURE.BOUNCER.TARGETTING_RADIUS}, "RADIUS"),
            ["BEACON"] = StructureBlueprint("BEACON", assets.blueprints.beacon, 2, 2, 1, 1, {radius = constants.STRUCTURE.BEACON.TARGETTING_RADIUS}, "RADIUS"),
        }
        self.blueprints = {}
        self:addNewStructureBlueprint("OBSTACLE")
        self:addNewStructureBlueprint("BEACON") -- TODO: will be unlocked, not a default value
        self:addNewStructureBlueprint("SAW") -- TODO: will be unlocked, not a default value
        self:addNewStructureBlueprint("CANNON")  -- TODO: will be unlocked, not a default value
        self:addNewStructureBlueprint("LASERGUN") -- TODO: will be unlocked, not a default value
        self:addNewStructureBlueprint("BOUNCER") -- TODO: will be unlocked, not a default value

        self.livesRemaining = constants.MISC.STARTING_LIVES
        self.currentBlueprint = nil
        self.currentBlueprintOrientation = constants.ORIENTATIONS.UP
        self.currentSelectedStructure = nil
        self.wallet = Wallet()
        self.hasWon = false
        self.hasLost = false
        self.lastPlacedStructure = nil
        self.SPEED_MULTIPLIERS = {
            NORMAL = 1,
            FAST = 2,
        }
        self.timeDilation = self.SPEED_MULTIPLIERS.NORMAL
    end;
    update = function(self, dt)
        self.wallet:update(dt)
    end;
    currentDilationIs = function(self, speedKey)
        assert(self.SPEED_MULTIPLIERS[speedKey])
        return self.timeDilation == self.SPEED_MULTIPLIERS[speedKey]
    end;
    setTimeDilation = function(self, speedKey)
        assert(self.SPEED_MULTIPLIERS[speedKey])
        if not self:currentDilationIs(speedKey) then
            self.timeDilation = self.SPEED_MULTIPLIERS[speedKey]
            audioController:playAny("BUTTON_PRESS")
        end
    end;
    addNewStructureBlueprint = function(self, blueprintKey)
        assert(self.STRUCTURE_BLUEPRINTS[blueprintKey], "Tried to add non-existing structure blueprint: "..blueprintKey)
        local blueprint = self.STRUCTURE_BLUEPRINTS[blueprintKey]:clone()
        blueprint:setUIImages(uiController:constructHotkeyedImages(blueprint.image, #self.blueprints+1))
        table.insert(self.blueprints, blueprint)
    end;
    setCurrentBlueprint = function(self, index)
        if not self.blueprints[index] then return false end
        self:toggleStructureSelection()
        
        if inputController.isPlacingTower and self.currentBlueprint then
            if self.currentBlueprint.name == self.blueprints[index].name then
                inputController:togglePlacingTower() --toggle off the current one
                self.currentBlueprint = nil
                return true
            elseif self.wallet:canAfford(self.blueprints[index].cost)  then
                --theyre switching to a different one, check they can afford it
                self.currentBlueprint = self.blueprints[index]
                return true
            else
                audioController:playAny("INSUFFICIENT_FUNDS")
                return false
            end
        elseif self.wallet:canAfford(self.blueprints[index].cost) then
            self.currentBlueprint = self.blueprints[index]
            inputController:togglePlacingTower()
            return true
        else
            audioController:playAny("INSUFFICIENT_FUNDS")
            return false
        end
    end;
    toggleStructureSelection = function(self, structure)
        if structure == nil then
            if self.currentSelectedStructure then
                self.currentSelectedStructure:toggleSelected()
                self.currentSelectedStructure = nil
            end
            return
        end
        if not self.currentSelectedStructure then
            self.currentSelectedStructure = structure
            self.currentSelectedStructure:toggleSelected()
        else
            if structure.gridOrigin.x == self.currentSelectedStructure.gridOrigin.x
            and structure.gridOrigin.y == self.currentSelectedStructure.gridOrigin.y then
                self.currentSelectedStructure:toggleSelected()
                self.currentSelectedStructure = nil
            else
                self.currentSelectedStructure:toggleSelected()
                self.currentSelectedStructure = structure
                self.currentSelectedStructure:toggleSelected()
            end
        end
    end;
    refundCurrentStructure = function(self)
        if not self.currentSelectedStructure then
            return 
        end
        self.wallet:refund(self.currentSelectedStructure:getTotalCost(), self.currentSelectedStructure:centre())
        world:removeStructure(self.currentSelectedStructure)
        self:toggleStructureSelection()
        audioController:playAny("REFUND")
    end;
    rotateCurrentStructure = function(self)
        if not self.currentSelectedStructure or not self.currentSelectedStructure.rotatable then
            return 
        end
        self.currentSelectedStructure:rotateClockwise()
        audioController:playAny("BUTTON_PRESS")
        world:updateTowerHitbox(self.currentSelectedStructure)
    end;
    rotateCurrentBlueprint = function(self)
        if self.currentBlueprint.name ~= "LASERGUN" then return end
        self.currentBlueprintOrientation = self.currentBlueprintOrientation + math.rad(90)
        if self.currentBlueprintOrientation >= math.rad(360) then
            self.currentBlueprintOrientation = self.currentBlueprintOrientation - math.rad(360)
        end
        audioController:playAny("BUTTON_PRESS")
    end;
    draw = function(self)
        self.wallet:draw()

        if inputController.isPlacingTower and self.currentBlueprint then
            world:displayBlueprint(self.currentBlueprint, inputController.mouse:centre())
        end
    end;
    upgradeCurrentStructure = function(self, upgradeType)
        if not self.currentSelectedStructure or not self.currentSelectedStructure.mutable then return false end
        local cost = constants.MUTATION_COSTS[upgradeType][self.currentSelectedStructure.towerType]
    
        if self.wallet:canAfford(cost) then
            local mutation = nil
            if upgradeType == "FIRE" then
                mutation = FireMutation(cost)
            elseif upgradeType == "ICE" then
                mutation = IceMutation(cost)
            elseif upgradeType == "ELECTRIC" then
                mutation = ElectricMutation(cost)
            end
            mutation:lookupStats(self.currentSelectedStructure.towerType)
            self.currentSelectedStructure:addMutation(mutation) 
            return true
        else
            audioController:playAny("INSUFFICIENT_FUNDS")
            return false
        end
    end;
    leak = function(self, livesLost)
        self.livesRemaining = self.livesRemaining - livesLost
        audioController:playAny("ENEMY_LEAK")
        cameraController:shake(0.3, 1.5)
        if self.livesRemaining <= 0 and not self.hasLost and not self.hasWon then
            self:defeat()
        end
    end;
    defeat = function(self)
        self.hasLost = true
        audioController:stopMusic()
        audioController:playAny("DEFEAT")
        --TODO: play some bitter defeat music
    end;
    victory = function(self)
        self.hasWon = true
        audioController:stopMusic()
        audioController:playAny("WINNER")
    end;
    newStructurePlaced = function(self, structure)
        self.wallet:charge(structure:getTotalCost(), Vector(structure.worldOrigin.x + structure.width/2*constants.GRID.CELL_SIZE, structure.worldOrigin.y))
        self:toggleStructureSelection(structure)
        self.lastPlacedStructure = {gridOrigin = structure.gridOrigin:clone()}
    end;
}