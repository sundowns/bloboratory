Crucible = Class {
    init = function(self, enemiesPerSlot)
        self.slots = {}
        self.enemiesPerSlot = enemiesPerSlot
        for i=9, 1, -1 do 
            table.insert(self.slots, Slot(i))
        end
    end;
    slotIsEmpty = function(self, index)
        assert(self.slots[index])
        return self.slots[index].blueprint == nil
    end;
    resetSlot = function(self, index)
        assert(self.slots[index])
        return self.slots[index]:reset()
    end;
    constructEnemies = function(self, roundIndex, totalRounds)
        local enemies = {}
        local healthmodifier = self:calculateHealthScaling(roundIndex, totalRounds)
        for i, slot in pairs(self.slots) do
            for j, slotEnemy in pairs(slot:constructNEnemies(self.enemiesPerSlot, healthmodifier)) do
                enemies[#enemies+1] = slotEnemy
            end
        end
        return enemies
    end;
    calculateHealthScaling = function(self, roundIndex, totalRounds)
        local multiplier = 0.7
        return multiplier * (1 + roundIndex-1/totalRounds)
    end;
    reset = function(self)
        for i, slot in pairs(self.slots) do
            slot:reset()
        end
    end
}

Slot = Class {
    init = function(self, id)
        self.id = id
        self.blueprint = nil
    end;
    setBlueprint = function(self, blueprint)
        self.blueprint = blueprint
    end;
    reset = function(self)
        self.blueprint = nil
    end;
    constructNEnemies = function(self, n, healthmodifier)
        assert(n)
        healthmodifier = healthmodifier or 1
        local temp = {}
        if not self.blueprint then return temp end
        for i = 1, n do
            temp[i] = self.blueprint:construct({origin = Vector(0,0)}, healthmodifier)
        end
        return temp
    end;
}