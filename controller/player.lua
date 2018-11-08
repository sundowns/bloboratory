local ALL_BLUEPRINTS = {
    ["OBSTACLE"] = Blueprint("OBSTACLE", nil, 1, 1),
    ["SAW"] = Blueprint("SAW", assets.blueprints.saw, 2, 2),
    ["CANNON"] = Blueprint("CANNON", assets.blueprints.cannon, 2, 2)
}

PlayerController = Class {
    init = function(self)
        self.money = 20
        self.blueprints = {
            ALL_BLUEPRINTS["OBSTACLE"]
        }
        table.insert(self.blueprints, ALL_BLUEPRINTS["SAW"]) -- TODO: will be unlocked, not a default value
        table.insert(self.blueprints, ALL_BLUEPRINTS["CANNON"]) -- TODO: will be unlocked, not a default value
        self.currentBlueprint = nil
        self.currentSelectedStructure = nil
    end;
    setCurrentBlueprint = function(self, index)
        if not self.blueprints[index] then return end
        if not inputController.isPlacingTower or self.currentBlueprint.name == self.blueprints[index].name then
            inputController:togglePlacingTower()
        end
        self.currentBlueprint = self.blueprints[index]
    end;
    updateMoney = function(self, delta)
        self.money = self.money + delta
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
        self:updateMoney(self.currentSelectedStructure.cost)
        world:addFloatingGain("+"..self.currentSelectedStructure.cost, self.currentSelectedStructure.worldOrigin.x + constants.CURRENCY.GAINS.X_OFFSET, self.currentSelectedStructure.worldOrigin.y, true)
        world:removeStructure(self.currentSelectedStructure)
        self:toggleStructureSelection()
    end;
}