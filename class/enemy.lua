Enemy = Class {
    init = function(self, enemyType, worldOrigin, health, speed)
        assert(worldOrigin.x and worldOrigin.y)
        self.worldOrigin = worldOrigin
        self.health = health
        self.speed = speed
        self.movingTo = nil
        self.type = "ENEMY" -- used to check for valid collisions
        self.enemyType = enemyType
    end;
    update = function(self, dt, currentCell)
        if not currentCell or currentCell.isObstacle then
            return true --destroy this
        end
        if currentCell.isGoal then
            --TODO: do something meaningful
            return true --destroy this
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

        return false
    end;
    takeDamage = function(self, damage, dt)
        self.health = self.health - (damage*dt)
        return self.health > 0
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.ENEMY)
        love.graphics.circle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.ENEMY.RADIUS)
    end;
    moveBy = function(self, dx, dy)
        self.worldOrigin = Vector(self.worldOrigin.x + dx, self.worldOrigin.y + dy)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE
    end;
}