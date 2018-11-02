Grid = Class {
    init = function(self, origin, rows, cols)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.goal = nil
        
        self.cells = {}
        for i = 0, self.cols, 1 do
            self.cells[i] = {}
            for j = 0, self.rows, 1 do
                self.cells[i][j] = Cell(i, j)
            end
        end  
    end;
    draw = function(self)
        for i = 0, self.cols do
            for j = 0, self.rows do
                self.cells[i][j]:draw()
            end
        end
    end;
    calculateGridCoordinates = function(self, screenX, screenY)
        return math.floor(self.origin.x + screenX / constants.GRID.CELL_SIZE), math.floor(self.origin.y + screenY / constants.GRID.CELL_SIZE)
    end;
    setGoal = function(self, x, y)
        if self.goal then self.goal.isGoal = false end
        self.goal = self.cells[x][y]
        self.goal:setGoal()
    end;
    toggleObstacle = function(self, x, y)
        self.cells[x][y]:toggleObstacle(x, y)
    end;
    getNeighbours = function(self, target)
        assert(target.x and target.y)
        local neighbours = {}
        if target.x < self.cols and not self.cells[target.x + 1][target.y].isObstacle then
            table.insert(neighbours, self.cells[target.x + 1][target.y])
        end
        if target.x > 0 and not self.cells[target.x - 1][target.y].isObstacle then
            table.insert(neighbours, self.cells[target.x - 1][target.y])
        end
        if target.y < self.rows and not self.cells[target.x][target.y + 1].isObstacle then
            table.insert(neighbours, self.cells[target.x][target.y + 1])
        end
        if target.y > 0 and not self.cells[target.x][target.y - 1].isObstacle then
            table.insert(neighbours, self.cells[target.x][target.y - 1])
        end
        return neighbours
    end;
    --[[
        Calculate best 'next-move' for each cell using breadth-first search.
        Moves outwards from the goal, marking every cell with a direction for entities to follow.
        Handy reference: https://www.redblobgames.com/pathfinding/tower-defense/
    ]]
    calculatePaths = function(self)
        if not self.goal then return end;

        -- clear existing cameFrom records
        for i = 0, self.cols, 1 do
            for j = 0, self.rows, 1 do
                self.cells[i][j].cameFrom = nil
                self.cells[i][j].distanceToGoal = 0
            end
        end
        
        local openSet = {}
        table.insert(openSet, self.goal)
        self.goal.cameFrom = nil
        
        while #openSet > 0 do
            local current = table.remove(openSet)

            for i, next in pairs(self:getNeighbours(current)) do
                if not next.cameFrom or next.distanceToGoal > current.distanceToGoal + 1 then
                    table.insert(openSet, next)
                    next.cameFrom = current
                    next.distanceToGoal = current.distanceToGoal + 1

                end
            end;
        end
    end;
    isOccupied = function(self, x, y)
        return self.cells[x] and self.cells[x][y]
    end;
}