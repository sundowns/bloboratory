Cell = Class {
    init = function(self, grid_x, grid_y)
        self.x = grid_x
        self.y = grid_y
    end;
    __tostring = function(self)
        return self.x..","..self.y
    end;
    draw = function(self)
        love.graphics.rectangle('line', self.x*constants.GRID.CELL_SIZE, self.y*constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        -- if debug then
            
        -- end
    end;
}