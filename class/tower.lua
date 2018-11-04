Tower = Class {
    init = function(self, towerArchetype, towerType, image, gridOrigin, worldOrigin, width, height)
        assert(gridOrigin.x and gridOrigin.y)
        assert(worldOrigin.x and worldOrigin.y)
        self.gridOrigin = gridOrigin -- grid index
        self.worldOrigin = worldOrigin -- world coords
        self.width = width
        self.height = height
        self.type = "TOWER" -- used to check for valid collisions
        self.archetype = towerArchetype
        self.towerType = towerType
        self.image = image
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        if self.image then
            Util.l.resetColour()
            love.graphics.draw(self.image, self.worldOrigin.x, self.worldOrigin.y, 0, self.image:getWidth()*self.width/constants.GRID.CELL_SIZE, self.image:getWidth()*self.height/constants.GRID.CELL_SIZE)
        else --default to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.TOWER)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end
    end;
    calculateHitbox = function(self)
        -- calculate a rectangle for the hitbox, where x, y are the origin (top-left).
        local x = self.worldOrigin.x - self.targettingRadius * constants.GRID.CELL_SIZE
        local y = self.worldOrigin.y - self.targettingRadius * constants.GRID.CELL_SIZE
        local width = (self.width + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        local height = (self.height + 2*(self.targettingRadius)) *constants.GRID.CELL_SIZE
        return x, y, width, height
    end;
}

MeleeTower = Class {
    __includes = Tower,
    init = function(self, towerType, image, gridOrigin, worldOrigin, width, height)
        Tower.init(self, "MELEE", towerType, image, gridOrigin, worldOrigin, width, height)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
    end;
}

TargetedTower = Class {
    __includes = Tower,
    init = function(self, towerType, image, gridOrigin, worldOrigin, width, height)
        Tower.init(self, "TARGETTED", towerType, image, gridOrigin, worldOrigin, width, height)
        self.currentTarget = nil
        self.projectiles = {}
    end;
    spottedEnemy = function(self, enemy)
        if not self.currentTarget then
            self.currentTarget = enemy
        end
    end;
    update = function(self, dt)
        Tower.update(self, dt)

        if self.currentTarget and (not self:inRange(self.currentTarget) or self.currentTarget.markedForDeath)  then 
            self.currentTarget = nil
        end

        for i = #self.projectiles, 1, -1 do
            self.projectiles[i]:update(dt)
            if self.projectiles[i].markedForDeath then
                table.remove(self.projectiles, i)
            end
        end
    end;
    draw = function(self)
        Tower.draw(self)

        for i, projectile in pairs(self.projectiles) do
            projectile:draw()
        end
    end;
    inRange = function(self, enemy)
        assert(enemy and enemy.worldOrigin)
        local x, y, width, height = Tower.calculateHitbox(self)
        return enemy.worldOrigin.x > x and 
            enemy.worldOrigin.x < x + width and
            enemy.worldOrigin.y > y and
            enemy.worldOrigin.y < y + height
    end
}