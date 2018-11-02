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
    getNeighbours = function(self, target)
        assert(target.x and target.y)
        local neighbours = {}
        if target.x < self.cols - 1 and not self.grid[target.x + 1][target.y].isObstacle then
            table.insert(neighbours, self.grid[target.x + 1][target.y])
        end
        if target.x > 0 and not self.grid[target.x - 1][target.y].isObstacle then
            table.insert(neighbours, self.grid[target.x - 1][target.y])
        end
        if target.y < self.rows - 1 and not self.grid[target.x][target.y + 1].isObstacle then
            table.insert(neighbours, self.grid[target.x][target.y + 1])
        end
        if target.y > 0 and not self.grid[target.x][target.y - 1].isObstacle then
            table.insert(neighbours, self.grid[target.x][target.y - 1])
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
                self.grid[i][j].cameFrom = nil
                self.grid[i][j].distanceToGoal = 0
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
    keypressed = function(self, key)
        --TODO: might not need this. A proper input handler/controller probably a better idea
    end;
    mousepressed = function(self, screen_x, screen_y, button)
        --TODO: same with above, input handler instead?
        local x, y = self:calculateGridCoordinates(screen_x, screen_y)
        if self.grid[x] and self.grid[x][y] then
            if button == 1 then 
                self.grid[x][y]:toggleObstacle(x, y)
                self:calculatePaths()
            elseif button == 2 then
                self:setGoal(x, y)
                self:calculatePaths()
            end
        end
    end;
}