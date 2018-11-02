Tower = Class {
    init = function(self, gridX, gridY, worldX, worldY, width, height)
        self.origin = Vector(gridX, gridY)
        self.world_pos = Vector(worldX, worldY)
        self.width = width
        self.height = height
    end;
    update = function(dt)
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.TOWER)
        love.graphics.rectangle('fill', self.world_pos.x, self.world_pos.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
    end;
}