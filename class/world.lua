World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.grid = {}

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
}