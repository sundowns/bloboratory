require("src.class.currency")
require("src.class.wallet")

PlayerController = Class {
    init = function(self)
        self.STRUCTURE_BLUEPRINTS = {
            ["OBSTACLE"] = StructureBlueprint("OBSTACLE", assets.blueprints.obstacle, 1, 1, 2, 2, 0),
            ["SAW"] = StructureBlueprint("SAW", assets.blueprints.saw, 2, 2, 1, 1, constants.STRUCTURE.SAW.TARGETTING_RADIUS),
            ["CANNON"] = StructureBlueprint("CANNON", assets.blueprints.cannon, 2, 2, 1, 1, constants.STRUCTURE.CANNON.TARGETTING_RADIUS)
        }
        self.blueprints = {}
        self:addNewStructureBlueprint("OBSTACLE")
        self:addNewStructureBlueprint("SAW") -- TODO: will be unlocked, not a default valu
        self:addNewStructureBlueprint("CANNON")  -- TODO: will be unlocked, not a default value

        self.livesRemaining = constants.MISC.STARTING_LIVES
        self.currentBlueprint = nil
        self.currentSelectedStructure = nil
        self.wallet = Wallet()
        self.hasWon = false
        self.hasLost = false
        self.lastPlacedStructure = nil
    end;
    update = function(self, dt)
        self.wallet:update(dt)
    end;
    addNewStructureBlueprint = function(self, blueprintKey)
        assert(self.STRUCTURE_BLUEPRINTS[blueprintKey], "Tried to add non-existing structure blueprint: "..blueprintKey)
        local blueprint = self.STRUCTURE_BLUEPRINTS[blueprintKey]:clone()
        local w, h = blueprint.image:getWidth(), blueprint.image:getHeight()
        local canvas = love.graphics.newCanvas(128,128)
        love.graphics.setCanvas(canvas)
            love.graphics.draw(blueprint.image, 0, 0, 0, canvas:getWidth()/w, canvas:getHeight()/h)
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.rectangle('fill', 0, 0, canvas:getWidth()/2, canvas:getWidth()/2)
            Util.l.resetColour()
            local text = love.graphics.newText(assets.ui.neuropoliticalRg(14), { {0.8,1,0}, #self.blueprints+1})
            love.graphics.draw(text, canvas:getWidth()/4 - text:getWidth()*2, -14, 0, 4, 4)
        love.graphics.setCanvas()
        blueprint:setUIImage(love.graphics.newImage(canvas:newImageData()))
        table.insert(self.blueprints, blueprint)
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
            else
                audioController:playAny("INSUFFICIENT_FUNDS")
            end
        elseif self.wallet:canAfford(self.blueprints[index].cost) then
            self.currentBlueprint = self.blueprints[index]
            inputController:togglePlacingTower()
        else
            audioController:playAny("INSUFFICIENT_FUNDS")
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
    draw = function(self)
        self.wallet:draw()

        if inputController.isPlacingTower and self.currentBlueprint then
            world:displayBlueprint(self.currentBlueprint, inputController.mouse.origin)
        end
    end;
    upgradeCurrentStructure = function(self, upgradeType)
        if not self.currentSelectedStructure or not self.currentSelectedStructure.mutable then return false end
        if self.wallet:canAfford(constants.MUTATIONS[upgradeType].COST) then
            local mutation = nil
            if upgradeType == "FIRE" then
                mutation = FireMutation()
            elseif upgradeType == "ICE" then
                mutation = IceMutation()
            elseif upgradeType == "ELECTRIC" then
                mutation = ElectricMutation()
            end
            self.currentSelectedStructure:addMutation(mutation) 
            return true
        else
            audioController:playAny("INSUFFICIENT_FUNDS")
            return false
        end
    end;
    leak = function(self, livesLost)
        self.livesRemaining = self.livesRemaining - livesLost
        if self.livesRemaining <= 0 and not self.hasLost and not self.hasWon then
            self:defeat()
        end
    end;
    defeat = function(self)
        self.hasLost = true
        audioController:stopMusic()
        --TODO: play some bitter defeat music
    end;
    victory = function(self)
        self.hasWon = true
        audioController:stopMusic()
        -- TODO: play some wicked victory music
    end;
    newStructurePlaced = function(self, structure)
        self.wallet:charge(structure:getTotalCost(), Vector(structure.worldOrigin.x + structure.width/2*constants.GRID.CELL_SIZE, structure.worldOrigin.y))
        self:toggleStructureSelection(structure)
        self.lastPlacedStructure = {gridOrigin = structure.gridOrigin:clone()}
    end;
}