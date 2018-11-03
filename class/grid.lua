Grid = Class {
    init = function(self, origin, rows, cols)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.goal = nil
        self.spawns = {}
        self.cells = {}

        for i = 0, self.cols, 1 do
            self.cells[i] = {}
            for j = 0, self.rows, 1 do
                self.cells[i][j] = Cell(i, j)
            end
        end  
    end;
    update = function(self, dt, isPlacingTower)
        for i = 0, self.cols do
            for j = 0, self.rows do
                self.cells[i][j]:update(dt)
            end
        end
    end;
    highlightCells = function(self, mouseX, mouseY)
        --highlight 2x2 with selected block as top left
        local gridX, gridY = self:calculateGridCoordinates(love.mouse.getPosition())
        if not self:isOccupied(gridX, gridY, 2, 2) then --TODO: highlight based on width of tower being currently placed (hardcoded to 2 for now)
            self.cells[gridX][gridY].isHovered = true
            self.cells[gridX+1][gridY].isHovered = true
            self.cells[gridX][gridY+1].isHovered = true
            self.cells[gridX+1][gridY+1].isHovered = true
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
        local worldX, worldY = cameraController:getWorldCoordinates(screenX, screenY)
        return math.floor(self.origin.x + worldX / constants.GRID.CELL_SIZE), math.floor(self.origin.y + worldY / constants.GRID.CELL_SIZE)
    end;
    calculateWorldCoordinates = function(self, gridX, gridY)
        local worldX = self.origin.x + (gridX * constants.GRID.CELL_SIZE) 
        local worldY = self.origin.y + (gridY * constants.GRID.CELL_SIZE) 
        return worldX, worldY
    end;
    isValidGridCoords = function(self, x, y)
        return self.cells[x] and self.cells[x][y]
    end;
    isOccupied = function(self, x, y, width, height)
        if not height then height = 1 end
        if not width then width = 1 end
        
        if width == 1  and height == 1 then
            --treat as 1 cell
            return self.cells[x] and self.cells[x][y] and self.cells[x][y]:isOccupied()
        else
            --loop over contained cells
            for i = 0, width-1 do
                if self.cells[x+i] == nil then
                    return true 
                end
                for j = 0, height-1 do
                    if self.cells[x+i][y+j] == nil 
                    or self.cells[x+i][y+j]:isOccupied() then
                        return true
                    end
                end
            end

            return false
        end
    end;
    setGoal = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        if self.goal then self.goal.isGoal = false end
        self.goal = self.cells[x][y]
        self.goal:setGoal()
        self:calculatePaths()
    end;
    toggleSpawn = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        if self.spawns[self.cells[x][y]:__tostring()] then
            self.spawns[self.cells[x][y]:__tostring()] = nil
        else
            self.spawns[self.cells[x][y]:__tostring()] = self.cells[x][y]
        end
        self.cells[x][y]:toggleSpawn()
        world.grid:calculatePaths()
    end;
    toggleObstacle = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        self.cells[x][y]:toggleObstacle(x, y)
        self:calculatePaths()
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
}