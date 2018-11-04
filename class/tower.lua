Tower = Class {
    init = function(self, towerArchetype, towerType, gridOrigin, worldOrigin, width, height)
        assert(gridOrigin.x and gridOrigin.y)
        assert(worldOrigin.x and worldOrigin.y)
        self.gridOrigin = gridOrigin -- grid index
        self.worldOrigin = worldOrigin -- world coords
        self.width = width
        self.height = height
        self.type = "TOWER" -- used to check for valid collisions
        self.archetype = archetype
        self.towerType = towerType
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.TOWER)
        love.graphics.rectangle('fill', self.worldOrigin.x, self.worldOrigin.y, constants.GRID.CELL_SIZE*self.width, constants.GRID.CELL_SIZE*self.height)
    end;
}

MeleeTower = Class {
    __includes = Tower,
    init = function(self, towerType, gridOrigin, worldOrigin, width, height)
        Tower.init(self, "MELEE", towerType, gridOrigin, worldOrigin, width, height)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
    end;
}

TargettedTower = Class {
    __includes = Tower,
    init = function(self, towerType, gridOrigin, worldOrigin, width, height)
        Tower.init(self, "TARGETTED", towerType, gridOrigin, worldOrigin, width, height)
    end;
    update = function(self, dt)
        Tower.update(self, dt)
    end;
}