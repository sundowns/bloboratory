Cell = Class {
    init = function(self, gridX, gridY, worldX, worldY)
        self.x = gridX
        self.y = gridY
        self.worldX = worldX
        self.worldY = worldY
        self.occupant = nil
        self.isOccupied = false
        self.isGoal = false
        self.isSpawn = false

        --Used to display blueprint/projected builds
        self.isHovered = false 
        self.isHoveredInvalid = false 
        self.blueprint = false

        --Used for pathfinding
        self.cameFrom = nil
        self.heuristic = nil 
        self.distanceToGoal = 0
    end;
    __tostring = function(self)
        return self.x..","..self.y
    end;
    update = function(self, dt)
        self.isHovered = false
        self.isHoveredInvalid = false
        self.blueprint = false
    end;
    draw = function(self, isSpawning)
        if debug then
            love.graphics.setColor(1,1,1,0.2)
            love.graphics.rectangle('line', self.worldX, self.worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        end
        if self.isGoal then
            love.graphics.setColor(constants.COLOURS.GOAL)
            love.graphics.rectangle('fill', self.worldX, self.worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        elseif self.isSpawn then
            if isSpawning then
                love.graphics.setColor(constants.COLOURS.SPAWN_ACTIVE)
            else
                love.graphics.setColor(constants.COLOURS.SPAWN_INACTIVE)
            end
            love.graphics.rectangle('fill', self.worldX, self.worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE) 
        elseif self.blueprint then
            if self.isHovered then
                love.graphics.setColor(constants.COLOURS.HOVERED)
            elseif self.isHoveredInvalid then
                love.graphics.setColor(constants.COLOURS.HOVERED_INVALID)
            end
            self.blueprint:draw(self.worldX, self.worldY)
        elseif self.isHovered then
            love.graphics.setColor(constants.COLOURS.HOVERED)
            love.graphics.rectangle('fill', self.worldX, self.worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        elseif self.isHoveredInvalid then
            love.graphics.setColor(constants.COLOURS.HOVERED_INVALID)
            love.graphics.rectangle('fill', self.worldX, self.worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        end

        if debug then
            love.graphics.setColor(constants.COLOURS.DEBUG_PRINT)
            love.graphics.print(self.distanceToGoal, self.x*constants.GRID.CELL_SIZE, self.y*constants.GRID.CELL_SIZE)
        end
    end;
    occupy = function(self, occupant)
        if not self.isGoal and not self.isSpawn then
            self.isOccupied = true
            self.occupant = occupant
        end
    end;
    vacate = function(self)
        self.isOccupied = false
        self.occupant = nil
    end;
    setSpawn = function(self)
        self.isGoal = false 
        self.isOccupied = true
        self.isSpawn = true
    end;
    setGoal = function(self)
        self.isSpawn = false
        self.isOccupied = true
        self.isGoal = true
    end;
    reset = function(self)
        self.isOccupied = false
        self.isGoal = false
        self.isSpawn = false
    end;
    isValidPath = function(self)
        return not self.isOccupied or (self.isSpawn or self.isGoal)
    end;
    isSpawnable = function(self)
        return not self.isOccupied or self.isSpawn
    end;
    getCentre = function(self)
        return self.worldX + constants.GRID.CELL_SIZE/2, self.worldY + constants.GRID.CELL_SIZE/2
    end;
    renderBlueprint = function(self, blueprint, valid)
        assert(blueprint and blueprint.image)
        self.blueprint = blueprint
        if valid then
            self.isHovered = true
        else
            self.isHoveredInvalid = true
        end
    end;
}