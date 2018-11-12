require("src.class.currency")
require("src.class.wallet")

local ALL_BLUEPRINTS = {
    ["OBSTACLE"] = Blueprint("OBSTACLE", nil, 1, 1),
    ["SAW"] = Blueprint("SAW", assets.blueprints.saw, 2, 2),
    ["CANNON"] = Blueprint("CANNON", assets.blueprints.cannon, 2, 2)
}

PlayerController = Class {
    init = function(self)
        self.blueprints = {
            ALL_BLUEPRINTS["OBSTACLE"]
        }
        table.insert(self.blueprints, ALL_BLUEPRINTS["SAW"]) -- TODO: will be unlocked, not a default value
        table.insert(self.blueprints, ALL_BLUEPRINTS["CANNON"]) -- TODO: will be unlocked, not a default value
        self.currentBlueprint = nil
        self.currentSelectedStructure = nil
        self.lastSelectedStructure = nil
        self.wallet = Wallet()
    end;
    update = function(self, dt)
        self.wallet:update(dt)
    end;
    setCurrentBlueprint = function(self, index)
        if not self.blueprints[index] then return end
        self:toggleStructureSelection()
        
        if inputController.isPlacingTower and self.currentBlueprint then
            if self.currentBlueprint.name == self.blueprints[index].name then
                inputController:togglePlacingTower() --toggle off the current one
                self.currentBlueprint = nil
            elseif self.wallet:canAfford(self.blueprints[index].cost)  then
                --theyre switching to a different one, check they can afford it
                self.currentBlueprint = self.blueprints[index]
            end
        elseif self.wallet:canAfford(self.blueprints[index].cost) then
            self.currentBlueprint = self.blueprints[index]
            inputController:togglePlacingTower()
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
            self.lastSelectedStructure = structure
            self.currentSelectedStructure = structure
            self.currentSelectedStructure:toggleSelected()
        else
            if structure.gridOrigin.x == self.currentSelectedStructure.gridOrigin.x
            and structure.gridOrigin.y == self.currentSelectedStructure.gridOrigin.y then
                self.currentSelectedStructure:toggleSelected()
                self.currentSelectedStructure = nil
            else
                self.currentSelectedStructure:toggleSelected()
                self.lastSelectedStructure = structure
                self.currentSelectedStructure = structure
                self.currentSelectedStructure:toggleSelected()
            end
        end
    end;
    clearLastSelected = function(self)
        self.lastSelectedStructure = nil
    end;
    refundCurrentStructure = function(self)
        if not self.currentSelectedStructure then
            return 
        end
        self.wallet:refund(self.currentSelectedStructure:getTotalCost(), self.currentSelectedStructure:centre())
        world:removeStructure(self.currentSelectedStructure)
        self:toggleStructureSelection()
        self:clearLastSelected()
    end;
    refundLastStructure = function(self) -- For use in UI when current is unselected by buttons
        if not self.lastSelectedStructure then
            return 
        end
        self.wallet:refund(self.lastSelectedStructure:getTotalCost(), self.lastSelectedStructure:centre())
        world:removeStructure(self.lastSelectedStructure)
        self:clearLastSelected()
    end;
    draw = function(self)
        self.wallet:draw()
    end;
}