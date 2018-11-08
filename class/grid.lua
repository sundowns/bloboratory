Grid = Class {
    init = function(self, origin, rows, cols)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.goal = nil
        self.spawn = nil
        self.cells = {}

        --used to draw path from spawn to goal
        self.optimalPath = {}

        for i = 0, self.cols, 1 do
            self.cells[i] = {}
            for j = 0, self.rows, 1 do
                local worldX, worldY = self:calculateWorldCoordinatesFromGrid(i, j)
                self.cells[i][j] = Cell(i, j, worldX, worldY)
            end
        end  
    end;
    update = function(self, dt)
        for i = 0, self.cols do
            for j = 0, self.rows do
                self.cells[i][j]:update(dt)
            end
        end
    end;
    draw = function(self, isSpawning)
        for i = 0, self.cols do
            for j = 0, self.rows do
                self.cells[i][j]:draw(isSpawning)
            end
        end

        -- Cant draw a line with less than 2 vertices (4 points)
        if #self.optimalPath > 4 then
            love.graphics.setColor(0,1,1)
            love.graphics.line(self.optimalPath)
        end
    end;
    displayBlueprint = function(self, mouseX, mouseY, blueprint)
        local gridX, gridY = self:calculateGridCoordinatesFromScreen(love.mouse.getPosition())
        if not self:isOccupied(gridX, gridY, blueprint.width, blueprint.height) then
            self.cells[gridX][gridY]:renderBlueprint(blueprint, true)
        elseif self.cells[gridX] and self.cells[gridX][gridY] then
            self.cells[gridX][gridY]:renderBlueprint(blueprint, false)
        end
    end;
    --TODO: Remove the below function once everything has images weeeee
    highlightCells = function(self, mouseX, mouseY, width, height)
        local gridX, gridY = self:calculateGridCoordinatesFromScreen(love.mouse.getPosition())
        if not self:isOccupied(gridX, gridY, width, height) then
            for i = gridX, gridX + width-1 do
                for j = gridY, gridY + height-1 do
                    self.cells[i][j].isHovered = true
                end
            end
        else
            for i = gridX, gridX + width-1 do
                for j = gridY, gridY + height-1 do
                    if self.cells[i] and self.cells[i][j] then
                        self.cells[i][j].isHoveredInvalid = true
                    end
                end
            end
        end
    end;
    calculateGridCoordinatesFromWorld = function(self, worldX, worldY)
        return math.floor(self.origin.x + worldX / constants.GRID.CELL_SIZE), math.floor(self.origin.y + worldY / constants.GRID.CELL_SIZE)
    end;
    calculateGridCoordinatesFromScreen = function(self, screenX, screenY)
        return self:calculateGridCoordinatesFromWorld(cameraController:getWorldCoordinates(screenX, screenY))
    end;
    calculateWorldCoordinatesFromGrid = function(self, gridX, gridY)
        local worldX = self.origin.x + (gridX * constants.GRID.CELL_SIZE) 
        local worldY = self.origin.y + (gridY * constants.GRID.CELL_SIZE) 
        return worldX, worldY
    end;
    isValidGridCoords = function(self, x, y)
        return self.cells[x] and self.cells[x][y]
    end;
    isSpawnable = function(self, x, y)
        return self.cells[x] and self.cells[x][y] and self.cells[x][y]:isSpawnable()
    end;
    isOccupied = function(self, x, y, width, height)
        if not height then height = 1 end
        if not width then width = 1 end
        
        if width == 1  and height == 1 then
            --treat as 1 cell
            return self.cells[x] and self.cells[x][y] and self.cells[x][y].isOccupied
        else
            --loop over contained cells
            for i = 0, width-1 do
                if self.cells[x+i] == nil then
                    return true 
                end
                for j = 0, height-1 do
                    if self.cells[x+i][y+j] == nil 
                    or self.cells[x+i][y+j].isOccupied then
                        return true
                    end
                end
            end

            return false
        end
    end;
    getCell = function(self, gridX, gridY)
        if self:isValidGridCoords(gridX, gridY) then
            return self.cells[gridX][gridY]
        end
    end;
    setGoal = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        if self.goal then self.goal:reset() end
        self.goal = self.cells[x][y]
        self.goal:setGoal()
        self:calculatePaths()
    end;
    setSpawn = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        if self.spawn then self.spawn:reset() end
        self.spawn = self.cells[x][y]
        self.spawn:setSpawn()
        self:calculatePaths()
    end;
    occupyCell = function(self, x, y, occupant)
        if not self:isValidGridCoords(x, y) then return end
        self.cells[x][y]:occupy(occupant)
    end;
    vacateCell = function(self, x, y)
        if not self:isValidGridCoords(x, y) then return end
        self.cells[x][y]:vacate()
    end;
    getNeighbours = function(self, target)
        assert(target.x and target.y)
        local neighbours = {}
        if target.x < self.cols and self.cells[target.x + 1][target.y]:isValidPath() then
            table.insert(neighbours, self.cells[target.x + 1][target.y])
        end
        if target.x > 0 and self.cells[target.x - 1][target.y]:isValidPath() then
            table.insert(neighbours, self.cells[target.x - 1][target.y])
        end
        if target.y < self.rows and self.cells[target.x][target.y + 1]:isValidPath() then
            table.insert(neighbours, self.cells[target.x][target.y + 1])
        end
        if target.y > 0 and self.cells[target.x][target.y - 1]:isValidPath() then
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
                self.cells[i][j].heuristic = self:heuristic(self.cells[i][j])
            end
        end
        
        local openSet = {}
        table.insert(openSet, self.goal)
        self.goal.cameFrom = nil
        
        while #openSet > 0 do
            local current = table.remove(openSet)

            for i, next in pairs(self:getNeighbours(current)) do
                if not next.cameFrom or next.distanceToGoal > current.distanceToGoal + next.heuristic + 1 then
                    table.insert(openSet, next)
                    next.cameFrom = current
                    next.distanceToGoal = math.floor(current.distanceToGoal + current.heuristic + 1)
                end
            end;
        end

        if self.spawn then
            self.optimalPath = {}
            local current = self.spawn.cameFrom

            while current and not current.isGoal do 
                local cX, cY = current:getCentre()
                table.insert(self.optimalPath, cX)
                table.insert(self.optimalPath, cY)
                current = current.cameFrom
            end
        else
            self.optimalPath = {}
        end
    end;
    --[[
        Heuristic function to guide our search. Euclidian distance (straight line)
    ]]
    heuristic = function(self, cell)
        return Util.m.distanceBetween(self.goal.x, self.goal.y, cell.x, cell.y)
    end;
    occupySpaces = function(self, structure)
        for i = structure.gridOrigin.x, structure.gridOrigin.x + structure.width-1 do
            for j = structure.gridOrigin.y, structure.gridOrigin.y + structure.height-1 do
                self:occupyCell(i, j, structure)
            end
        end
    end;
    vacateSpaces = function(self, structure)
        for i = structure.gridOrigin.x, structure.gridOrigin.x + structure.width-1 do
            for j = structure.gridOrigin.y, structure.gridOrigin.y + structure.height-1 do
                self:vacateCell(i, j)
            end
        end
    end;
}