Structure = Class {
    init = function(self, animation, gridOrigin, worldOrigin, width, height, cost)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(gridOrigin and gridOrigin.x and gridOrigin.y)
        assert(width)
        assert(height)
        assert(cost)
        self.gridOrigin = gridOrigin
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.animation = animation
        self.isSelected = false
        self.cost = cost
        self.mutable = false
    end;
    update = function(self, dt)
        if self.animation then
            animationController:updateSpriteInstance(self.animation, dt)
        end
    end;
    draw = function(self)
        if self.animation then
            Util.l.resetColour()
            animationController:drawStructureSpriteInstance(self.animation, self.worldOrigin.x, self.worldOrigin.y, self.width, self.height, self.angleToTarget)
        elseif self.type == "TOWER" then --defaults to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.TOWER)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        elseif self.type == "OBSTACLE" then --defaults to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.OBSTACLE)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end

        if self.isSelected then
            love.graphics.setColor(constants.COLOURS.SELECTION)
            love.graphics.rectangle('line', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end
    end;
    changeAnimationState = function(self, newState)
        if self.animation then
            animationController:changeSpriteState(self.animation, newState)
        end
    end;
    toggleSelected = function(self)
        self.isSelected = not self.isSelected
    end;
    centre = function(self)
        return Vector(self.worldOrigin.x + constants.GRID.CELL_SIZE*self.width/2, self.worldOrigin.y + constants.GRID.CELL_SIZE*self.height/2)
    end;
    getTotalCost = function(self)
        if self.mutation then
            return addTables(self.cost, self.mutation.cost)
        else 
            return self.cost
        end
    end;
}

addTables = function(t1, t2)
    local result = {}
    for key, val in pairs(t1) do
        result[key] = (result[key] or 0) + val
    end
    for key, val in pairs(t2) do
        result[key] = (result[key] or 0) + val
    end
    return result
end;