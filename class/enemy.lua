Enemy = Class {
    init = function(self, enemyType, worldOrigin, health, speed)
        assert(worldOrigin.x and worldOrigin.y)
        self.worldOrigin = worldOrigin
        self.maxHealth = health
        self.health = health
        self.speed = speed
        self.movingTo = nil
        self.type = "ENEMY" -- used to check for valid collisions
        self.enemyType = enemyType
        self.markedForDeath = false
    end;
    update = function(self, dt, currentCell)
        if not currentCell then
            self.markedForDeath = true
        end
        if currentCell.isGoal then
            --TODO: reduce remaining leakcount somehow
            self.markedForDeath = true
        end
        --decide direction to move based on current grid's came_from value (breadth first search)
        if self.movingTo == nil then
            self.movingTo = currentCell.cameFrom
        else
            local moveToX = self.movingTo.x * constants.GRID.CELL_SIZE + constants.GRID.CELL_SIZE/2
            local moveToY = self.movingTo.y * constants.GRID.CELL_SIZE + constants.GRID.CELL_SIZE/2

            if Util.m.withinVariance(self.worldOrigin.x, moveToX, 5) and Util.m.withinVariance(self.worldOrigin.y, moveToY, 5) then
                --If we are at the centre of the tile
                self.movingTo = nil
            else
                --move towards that centre
                local deltaX = (moveToX - self.worldOrigin.x)*dt
                local deltaY = (moveToY - self.worldOrigin.y)*dt
                self:moveBy(deltaX*self.speed, deltaY*self.speed)
            end
        end 
    end;
    takeDamage = function(self, damage, dt)
        if not dt then dt = 1 end -- allows the function to work with constant attacks (melee) and projectiles
        self.health = self.health - (damage*dt)
        self.markedForDeath = self.health < 0
    end;
    draw = function(self)
        love.graphics.setColor(self.health/self.maxHealth, 0, 0)
    end;
    moveBy = function(self, dx, dy)
        self.worldOrigin = Vector(self.worldOrigin.x + dx, self.worldOrigin.y + dy)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE
    end;
}