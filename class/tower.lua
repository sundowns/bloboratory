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
            love.graphics.draw(self.image, self.worldOrigin.x, self.worldOrigin.y, 0, self.image:getWidth()*self.width/constants.GRID.CELL_SIZE, self.image:getWidth()*self.height/constants.GRID.CELL_SIZE)
        else --default to make adding new towers not suck
            love.graphics.setColor(constants.COLOURS.TOWER)
            love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
        end
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

TargettedTower = Class {
    __includes = Tower,
    init = function(self, towerType, image, gridOrigin, worldOrigin, width, height)
        Tower.init(self, "TARGETTED", towerType, image, gridOrigin, worldOrigin, width, height)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
    end;
}