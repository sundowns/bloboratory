Crucible = Class {
    init = function(self, enemiesPerSlot)
        self.slots = {}
        self.enemiesPerSlot = enemiesPerSlot
        for i=9, 0, -1 do 
            table.insert(self.slots, Slot(i))
        end
    end;
    constructEnemies = function(self)
        local enemies = {}
        for i, slot in pairs(self.slots) do
            for j, slotEnemy in pairs(slot:constructNEnemies(self.enemiesPerSlot, 1)) do
                enemies[#enemies+1] = slotEnemy
            end
        end
        return enemies
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