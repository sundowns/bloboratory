World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.grid = {}
        self.goal = nil

        for i = 0, cols do
            self.grid[i] = {}
            for j = 0, rows do
                self.grid[i][j] = Cell(i, j)
            end
        end        
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        for i = 0, self.cols do
            for j = 0, self.rows do
                self.grid[i][j]:draw()
            end
        end
    end;
    calculateGridCoordinates = function(self, screenX, screenY)
        return math.floor(self.origin.x + screenX / constants.GRID.CELL_SIZE), math.floor(self.origin.y + screenY / constants.GRID.CELL_SIZE)
    end;
    setGoal = function(self, x, y)
        if self.goal then self.goal.isGoal = false end
        self.goal = self.grid[x][y]
        self.goal:setGoal()
    end;
    keypressed = function(self, key)
        --TODO: might not need this. A proper input handler/controller probably a better idea
    end;
    mousepressed = function(self, screen_x, screen_y, button)
        --TODO: same with above, input handler instead?
        local x, y = self:calculateGridCoordinates(screen_x, screen_y)
        if self.grid[x] and self.grid[x][y] then
            if button == 1 then 
                self.grid[x][y]:toggleObstacle(x, y)
            elseif button == 2 then
                self:setGoal(x, y)
            end
        end
    end;
}