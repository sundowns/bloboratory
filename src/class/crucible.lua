Crucible = Class {
    init = function(self, enemiesPerSlot)
        self.slots = {}
        self.enemiesPerSlot = enemiesPerSlot
        for i=9, 0, -1 do 
            table.insert(self.slots, Slot(i))
        end
    end;
    prepareToSend = function(self)
        local enemies = {}
        for i, slot in pairs(self.slots) do
            Util.t.concat(enemies, slot:constructNEnemies(self.enemiesPerSlot))
        end
        return enemies
    end;
}

Slot = Class {
    init = function(self, id)
        self.id = id
        self.blueprint = nil
    end;
    setBlueprint = function(self, blueprint)
        self.blueprint = blueprint
    end;
    constructNEnemies = function(self, n)
        assert(n)
        local temp = {}
        if not self.blueprint then return temp end
        for i = 1, n do
            temp[#temp + 1] = self.blueprint:construct(Vector(0,0))
        end
        return temp
    end;
}