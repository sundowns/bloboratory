Cell = Class {
    init = function(self, gridOrigin, worldOrigin)
        self.gridOrigin = gridOrigin
        self.worldOrigin = worldOrigin
        self.occupant = nil
        self.isOccupied = false
        self.isGoal = false
        self.isSpawn = false

        --Used for pathfinding
        self.cameFrom = nil
        self.heuristic = nil 
        self.distanceToGoal = 0
    end;
    __tostring = function(self)
        return self.gridOrigin.x..","..self.gridOrigin.y
    end;
    update = function(self, dt)
        self.isHovered = false
        self.isHoveredInvalid = false
        self.blueprint = false
    end;
    draw = function(self, isSpawning)
        Util.l.resetColour()

        if self.gridOrigin.x % 2 == 0 and self.gridOrigin.y % 2 == 0 then
            love.graphics.draw(assets.terrain.floor, self.worldOrigin.x, self.worldOrigin.y, 0, constants.GRID.CELL_SIZE/assets.terrain.floor:getWidth()*2, constants.GRID.CELL_SIZE/assets.terrain.floor:getHeight()*2)
        end

        if self.isGoal then
            love.graphics.setColor(constants.COLOURS.GOAL)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
        elseif self.isSpawn then
            if isSpawning then
                love.graphics.setColor(constants.COLOURS.SPAWN_ACTIVE)
            else
                love.graphics.setColor(constants.COLOURS.SPAWN_INACTIVE)
            end
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE) 
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
    centre = function(self)
        return Vector(self.worldOrigin.x + constants.GRID.CELL_SIZE/2, self.worldOrigin.y + constants.GRID.CELL_SIZE/2)
    end;
}