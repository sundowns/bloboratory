Structure = Class {
    init = function(self, image, gridOrigin, worldOrigin, width, height)
        assert(worldOrigin and worldOrigin.x and worldOrigin.y)
        assert(gridOrigin and gridOrigin.x and gridOrigin.y)
        assert(width)
        assert(height)
        self.gridOrigin = gridOrigin
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.image = image
    end;
    draw = function(self)
        if self.image then
            Util.l.resetColour()
            love.graphics.draw(self.image, self.worldOrigin.x, self.worldOrigin.y, 0, self.image:getWidth()*self.width/constants.GRID.CELL_SIZE, self.image:getWidth()*self.height/constants.GRID.CELL_SIZE)
        elseif self.type == "TOWER" then --defaults to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.TOWER)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        elseif self.type == "OBSTACLE" then --defaults to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.OBSTACLE)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end
    end;
}