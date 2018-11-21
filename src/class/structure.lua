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
    drawAt = function(self, origin)
        -- Util.l.resetColour()
        animationController:drawStructureSpriteInstance(self.animation, origin, self.width, self.height, self.angleToTarget)
    end;
    draw = function(self, blockingPath)
        if self.animation then
            Util.l.resetColour()
            if blockingPath then
                love.graphics.setColor(1,0,0,0.8)
            end
            self:drawAt(self.worldOrigin)
        elseif self.type == "TOWER" then --defaults to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.TOWER)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end

        if self.isSelected then
            love.graphics.setColor(constants.COLOURS.SELECTION)
            love.graphics.setLineWidth(2)
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
            return Util.t.sum(self.cost, self.mutation.cost)
        else 
            return self.cost
        end
    end;
}