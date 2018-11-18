Crucible = Class {
    init = function(self)
        self.slots = {}
        for i=9, 0, -1 do 
            table.insert(self.slots, Slot(i))
        end
    end;

    prepareToSend = function(self)
        local temp = {}
        for i, slot in pairs(self.slots) do 
            for j, enemy in pairs(slot.enemies) do 
                if enemy ~= 0 then 
                    table.insert(temp, enemy)
                end
            end
        end
        self.slots.enemies = temp
    end;
}

Slot = Class {
    init = function(self, id)
        self.id = id
        self.enemies = {}
    end;    
}