Crucible = Class {
    init = function(self, enemiesPerSlot)
        self.slots = {}
        self.enemiesPerSlot = enemiesPerSlot
        for i=9, 1, -1 do 
            table.insert(self.slots, Slot(i))
        end
        self.currentRecipe = {}
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
            table.insert(self.currentRecipe, slot:getSlotRecipe())
            for j, slotEnemy in pairs(slot:constructNEnemies(self.enemiesPerSlot, healthmodifier)) do
                enemies[#enemies+1] = slotEnemy
            end
        end
        if self.currentRecipe[1] == 2 and self.currentRecipe[2] == 3 then 
            if self.currentRecipe[3] == 2 and self.currentRecipe[4] == 0 then 
                if self.currentRecipe[5] == 1 and self.currentRecipe[6] == 0 then 
                    if self.currentRecipe[7] == 0 and self.currentRecipe[8] == 1 then 
                        if self.currentRecipe[9] == 0 then 
                            table.insert(enemies, BlobSkull(Vector(0,0)))
                            table.insert(enemies, BlobSkull(Vector(0,0)))
                            table.insert(enemies, BlobSkull(Vector(0,0)))
                        end 
                    end 
                end
            end
        end
        self:clearRecipe()
        return enemies
    end;
    calculateHealthScaling = function(self, roundIndex, totalRounds)
        local multiplier = 0.62
        return multiplier * (1 + roundIndex-1/totalRounds)
    end;
    reset = function(self)
        for i, slot in pairs(self.slots) do
            slot:reset()
        end
    end;
    clearRecipe = function(self)
        self.currentRecipe = {}
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
    getSlotRecipe = function(self)
        local recipeIndex 
        if not self.blueprint then return 0 end
        local temp = self.blueprint:construct({origin = Vector(0,0)}, 1)
        recipeIndex = temp.recipeIndex
        print (recipeIndex)
        return recipeIndex
    end;
}