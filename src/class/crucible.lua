Crucible = Class {
    init = function(self, enemiesPerSlot)
        self.slots = {}
        self.enemiesPerSlot = enemiesPerSlot
        for i=9, 1, -1 do 
            table.insert(self.slots, Slot(i))
        end
        self.isLocked = false
        -- self.currentRecipe = {}
        -- self.isRecipe = true
    end;
    lock = function(self)
        self.isLocked = true
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
            -- table.insert(self.currentRecipe, slot:getSlotRecipe())
            for j, slotEnemy in pairs(slot:constructNEnemies(self.enemiesPerSlot, healthmodifier)) do
                enemies[#enemies+1] = slotEnemy
            end
        end

        -- if self:compareRecipe() then 
        --     for i=1, 3 do 
        --         table.insert(enemies, BlobSkull(Vector(0,0)))
        --     end
        -- end
        -- self:clearRecipe()
        return enemies
    end;
    calculateHealthScaling = function(self, roundIndex, totalRounds)
        local multiplier = 0.6
        if roundIndex > 10 then 
            multiplier = 0.8
        elseif roundIndex > 15 then 
            multiplier = 1
        elseif roundIndex > 20 then 
            multiplier = 1.6
        elseif roundIndex > 25 then 
            multiplier = 2.7
        end
        return multiplier * (1 + roundIndex-3/totalRounds)
    end;
    reset = function(self)
        for i, slot in pairs(self.slots) do
            slot:reset()
        end
        self.isLocked = false
    end;
    setSlot = function(self, slotIndex, blueprint)
        -- assert(self.slots[slotIndex])
        if self.slots[slotIndex] then
            self.slots[slotIndex]:setBlueprint(blueprint)
        end
    end;
    -- compareRecipe = function(self)
    --     for i, entry in pairs(self.currentRecipe) do 
    --         for j, recipe in pairs(constants.RECIPE) do 
    --             for k, entry in pairs(recipe) do 
    --                 if recipe[i] ~= self.currentRecipe[i] then return false end
    --             end
    --         end
    --     end
    --     return true
    -- end;
    -- clearRecipe = function(self)
    --     self.currentRecipe = {}
    --     self.isRecipe = false
    -- end
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
    -- getSlotRecipe = function(self)
    --     local recipeIndex 
    --     if not self.blueprint then return 0 end
    --     local temp = self.blueprint:construct({origin = Vector(0,0)}, 1)
    --     recipeIndex = temp.recipeIndex
    --     print (recipeIndex)
    --     return recipeIndex
    -- end;
}