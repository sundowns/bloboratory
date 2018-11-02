Cell = Class {
    init = function(self, grid_x, grid_y)
        self.x = grid_x
        self.y = grid_y
        self.screen_x = self.x * constants.GRID.CELL_SIZE
        self.screen_y = self.y * constants.GRID.CELL_SIZE
        self.isObstacle = false
        self.isGoal = false
        self.isSpawn = false
    end;
    __tostring = function(self)
        return self.x..","..self.y
    end;
    draw = function(self)
        Util.l.resetColour()
        love.graphics.rectangle('line', self.screen_x, self.screen_y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        if self.isObstacle then
            love.graphics.setColor(constants.COLOURS.OBSTACLE)
            love.graphics.rectangle('fill', self.screen_x, self.screen_y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        elseif self.isGoal then
            love.graphics.setColor(constants.COLOURS.GOAL)
            love.graphics.rectangle('fill', self.screen_x, self.screen_y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)    
        end
    end;
    toggleObstacle = function(self)
        if not self.isGoal and not self.spawn then
            self.isObstacle = not self.isObstacle
        end
    end;
    setSpawn = function(self)
        self.isGoal = false
        self.isObstacle = false
        self.isSpawn = true
    end;
    setGoal = function(self)
        self.isSpawn = false
        self.isObstacle = false
        self.isGoal = true
    end;
}