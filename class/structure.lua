Structure = Class {
    init = function(self, animations, gridOrigin, worldOrigin, width, height)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(gridOrigin and gridOrigin.x and gridOrigin.y)
        assert(width)
        assert(height)
        self.gridOrigin = gridOrigin
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.animations = animations or {}
        self.isSelected = false
    end;
    update = function(self, dt)
        if self.animations then
            for i, animation in pairs(self.animations) do
                animationController:updateSpriteInstance(animation, dt)
            end
        end
    end;
    draw = function(self)
        if #self.animations > 0 then
            Util.l.resetColour()
            for i, animation in pairs(self.animations) do
                animationController:drawSpriteInstance(animation, self.worldOrigin.x, self.worldOrigin.y, self.width, self.height)
            end
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
        if self.animations then
            for i, animation in pairs(self.animations) do -- this is perhaps not the best solution, but is probably sufficient for now
                animationController:changeSpriteState(animation, newState)
            end
        end
    end;
    toggleSelected = function(self)
        self.isSelected = not self.isSelected
    end;
}