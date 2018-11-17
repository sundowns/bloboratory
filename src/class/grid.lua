Grid = Class {
    init = function(self, origin, rows, cols)
        self.origin = origin
        self.rows = rows
        self.cols = cols
        self.goal = nil
        self.spawn = nil
        self.validPath = false
        self.cells = {}

        --used to draw path from spawn to goal
        self.optimalPath = {}

        for i = 0, self.cols-1, 1 do
            self.cells[i] = {}
            for j = 0, self.rows-1, 1 do
                self.cells[i][j] = Cell(Vector(i, j), self:calculateWorldCoordinatesFromGrid(Vector(i, j)))
            end
        end  

        for x = 0, self.cols-1, 1 do
            for y = 0, self.rows-1, 1 do
                self.cells[x][y]:setNeighbours(self:getNeighbours(self.cells[x][y]))
            end
        end  

        self:setSpawn(Vector(0,0), false)
        self:setGoal(Vector(self.cols-1, self.rows-1), false)
        self:calculateHeuristics()
        self:calculatePaths()
    end;
    update = function(self, dt)
        for i = 0, self.cols-1 do
            for j = 0, self.rows-1 do
                self.cells[i][j]:update(dt)
            end
        end
    end;
    draw = function(self, isSpawning)
        love.graphics.setColor(1,1,1,0.8)
        love.graphics.setLineWidth(10)
        love.graphics.rectangle('line', self.origin.x, self.origin.y, (self.cols)*constants.GRID.CELL_SIZE, (self.rows)*constants.GRID.CELL_SIZE)

        for i = 0, self.cols-1 do
            for j = 0, self.rows-1 do
                self.cells[i][j]:draw(isSpawning)
            end
        end

        if self.validPath and roundController:isBuildPhase() then
            love.graphics.setColor(constants.COLOURS.OPTIMAL_PATH)
            love.graphics.setLineWidth(10)
            love.graphics.setLineJoin('bevel')
            love.graphics.line(self.optimalPath)
        end
    end;
    calculateGridCoordinatesFromWorld = function(self, worldOrigin)
        return Vector(math.floor(self.origin.x + worldOrigin.x / constants.GRID.CELL_SIZE), math.floor(self.origin.y + worldOrigin.y / constants.GRID.CELL_SIZE))
    end;
    calculateGridCoordinatesFromScreen = function(self, screenOrigin)
        return self:calculateGridCoordinatesFromWorld(cameraController:getWorldCoordinates(screenOrigin))
    end;
    calculateWorldCoordinatesFromGrid = function(self, gridOrigin)
        return Vector(self.origin.x + (gridOrigin.x * constants.GRID.CELL_SIZE) , self.origin.y + (gridOrigin.y * constants.GRID.CELL_SIZE) )
    end;
    isValidGridCoords = function(self, gridOrigin)
        return self.cells[gridOrigin.x] and self.cells[gridOrigin.x][gridOrigin.y]
    end;
    isSpawnable = function(self, gridOrigin)
        return self:isValidGridCoords(gridOrigin) and self.cells[gridOrigin.x][gridOrigin.y]:isSpawnable()
    end;
    isOccupied = function(self, origin, width, height)
        if not height then height = 1 end
        if not width then width = 1 end
        local x, y = origin.x, origin.y
        
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
    getCell = function(self, gridOrigin)
        if self:isValidGridCoords(gridOrigin) then
            return self.cells[gridOrigin.x][gridOrigin.y]
        end
    end;
    setGoal = function(self, position, calculatePaths)
        if not self:isValidGridCoords(position) then return end
        if self.goal then self.goal:reset() end
        self.goal = self.cells[position.x][position.y]
        self.goal:setGoal()
        if calculatePaths then
            self:calculateHeuristics()
            self:calculatePaths()
        end
    end;
    setSpawn = function(self, position, calculatePaths)
        if not self:isValidGridCoords(position) then return end
        if self.spawn then self.spawn:reset() end
        self.spawn = self.cells[position.x][position.y]
        self.spawn:setSpawn()
        if calculatePaths then
            self:calculatePaths()
        end
    end;
    occupyCell = function(self, position, occupant)
        if not self:isValidGridCoords(position) then return end
        self.cells[position.x][position.y]:occupy(occupant)
    end;
    vacateCell = function(self, position)
        if not self:isValidGridCoords(position) then return end
        self.cells[position.x][position.y]:vacate()
    end;
    getNeighbours = function(self, target)
        assert(target.gridOrigin and target.gridOrigin.x and target.gridOrigin.y)
        local neighbours = {}
        if target.gridOrigin.x < self.cols-1 and self.cells[target.gridOrigin.x + 1][target.gridOrigin.y] then
            table.insert(neighbours, self.cells[target.gridOrigin.x + 1][target.gridOrigin.y])
        end
        if target.gridOrigin.x > 0 and self.cells[target.gridOrigin.x - 1][target.gridOrigin.y] then
            table.insert(neighbours, self.cells[target.gridOrigin.x - 1][target.gridOrigin.y])
        end
        if target.gridOrigin.y < self.rows-1 and self.cells[target.gridOrigin.x][target.gridOrigin.y + 1] then
            table.insert(neighbours, self.cells[target.gridOrigin.x][target.gridOrigin.y + 1])
        end
        if target.gridOrigin.y > 0 and self.cells[target.gridOrigin.x][target.gridOrigin.y - 1] then
            table.insert(neighbours, self.cells[target.gridOrigin.x][target.gridOrigin.y - 1])
        end
        return neighbours
    end;
    --[[
        Calculate heuristic value for all cells. Only needs to happen when the goal is moved.
    ]]
    calculateHeuristics = function(self)
        if not self.goal then return end;
        for i = 0, self.cols-1, 1 do
            for j = 0, self.rows-1, 1 do
                self.cells[i][j].heuristic = self:heuristic(self.cells[i][j])
            end
        end
    end;
    --[[
        Calculate best 'next-move' for each cell using breadth-first search.
        Moves outwards from the goal, marking every cell with a direction for entities to follow.
        Handy reference: https://www.redblobgames.com/pathfinding/tower-defense/
    ]]
    calculatePaths = function(self)
        if not self.goal then return end;
        self.validPath = false
        -- clear existing cameFrom records
        for i = 0, self.cols-1, 1 do
            for j = 0, self.rows-1, 1 do
                self.cells[i][j].cameFrom = nil
                self.cells[i][j].distanceToGoal = 0
            end
        end
        
        local openSet = {}
        table.insert(openSet, self.goal)
        self.goal.cameFrom = nil
        
        while #openSet > 0 do
            local current = table.remove(openSet)

            for i, next in pairs(current.neighbours) do
                if next:isValidPath() then
                    if not next.cameFrom or next.distanceToGoal > current.distanceToGoal + next.heuristic + 1 then
                        table.insert(openSet, next)
                        next.cameFrom = current
                        next.distanceToGoal = math.floor(current.distanceToGoal + current.heuristic + 1)
                    end
                end
            end;
        end

        if self.spawn then
            self.optimalPath = {}
            local current = self.spawn.cameFrom

            while current and not current.isGoal do 
                local centre = current:centre()
                table.insert(self.optimalPath, centre.x)
                table.insert(self.optimalPath, centre.y)
                current = current.cameFrom
            end
            -- Cant draw a line with less than 2 vertices (4 points)
            if #self.optimalPath > 2 then
                self.validPath = true
            end
        else
            self.optimalPath = {}
            self.validPath = false
        end
    end;
    --[[
        Heuristic function to guide our search. Euclidian distance (straight line)
    ]]
    heuristic = function(self, cell)
        return Util.m.distanceBetween(self.goal.gridOrigin.x, self.goal.gridOrigin.y, cell.gridOrigin.x, cell.gridOrigin.y)
    end;
    occupySpaces = function(self, structure)
        for i = structure.gridOrigin.x, structure.gridOrigin.x + structure.width-1 do
            for j = structure.gridOrigin.y, structure.gridOrigin.y + structure.height-1 do
                self:occupyCell(Vector(i, j), structure)
            end
        end
    end;
    vacateSpacesForStructure = function(self, structure)
        for i = structure.gridOrigin.x, structure.gridOrigin.x + structure.width-1 do
            for j = structure.gridOrigin.y, structure.gridOrigin.y + structure.height-1 do
                self:vacateCell(Vector(i, j))
            end
        end
    end;
    displayBlueprint = function(self, blueprint, gridOrigin)
        local cell = self:getCell(gridOrigin)
        if cell then
            if self:isOccupied(gridOrigin, blueprint.width, blueprint.height) then
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_INVALID)
            else
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_VALID)
            end

            blueprint:draw(cell.worldOrigin)
        end
    end;
}