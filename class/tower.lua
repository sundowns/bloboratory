Tower = Class {
    init = function(self, towerType, gridOrigin, worldOrigin, width, height)
        assert(gridOrigin.x and gridOrigin.y)
        assert(worldOrigin.x and worldOrigin.y)
        self.gridOrigin = gridOrigin -- grid index
        self.worldOrigin = worldOrigin -- world coords
        self.width = width
        self.height = height
        self.type = "TOWER" -- used to check for valid collisions
        self.towerType = towerType
    end;
    update = function(dt)
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.TOWER)
        love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
    end;
}