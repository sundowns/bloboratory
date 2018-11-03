Enemy = Class {
    init = function(self, worldX, worldY, health, speed)
        self.worldX = worldX
        self.worldY = worldY
        self.health = health
        self.speed = speed
        self.movingTo = nil
        --world.collsionWorld:add(self, worldX, worldY, constants.GRID.CELL_SIZE, constants.GRID.CELL_SIZE)
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

            if Util.m.withinVariance(self.worldX, moveToX, 5) and Util.m.withinVariance(self.worldY, moveToY, 5) then
                --If we are at the centre of the tile
                self.movingTo = nil
            else
                --move towards that centre
                local deltaX = (moveToX - self.worldX)*dt
                local deltaY = (moveToY - self.worldY)*dt
                self:moveBy(deltaX*self.speed, deltaY*self.speed)
            end
        end 

        return false
    end;
    processAttack = function(self, damage)
        local alive = true
        self.health = self.health - damage
        if self.health <= 0 then 
            alive = false
        end 
        return alive
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.ENEMY)
        love.graphics.circle('fill', self.worldX, self.worldY, constants.ENEMY.RADIUS)
    end;
    moveBy = function(self, dx, dy)
        self.worldX = self.worldX + dx
        self.worldY = self.worldY + dy
    end;
}