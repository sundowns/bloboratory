PlayerController = Class {
    init = function(self)
        self.money = 0
        self.blueprints = {
            "OBSTACLE"
        }
        table.insert(self.blueprints, "SAW") -- TODO: will be unlocked, not a default value
        table.insert(self.blueprints, "SPUDGUN") -- TODO: will be unlocked, not a default value
        self.currentBlueprint = nil
        self.currentSelectedStructure = nil
    end;
    setCurrentBlueprint = function(self, index)
        if not self.blueprints[index] then return end
        if not inputController.isPlacingTower or self.currentBlueprint == self.blueprints[index] then
            inputController:togglePlacingTower()
        end
        self.currentBlueprint = self.blueprints[index]
    end;
    updateMoney = function(self, delta)
        self.money = self.money + delta
    end;
    selectStructure = function(self, structure)
    end;
}