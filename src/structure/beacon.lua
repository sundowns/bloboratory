Beacon = Class {
    __includes=MeleeTower,
    init = function(self, gridOrigin, worldOrigin)
        self.towerType = "BEACON"
        MeleeTower.init(self, animationController:createInstance(self.towerType),
            gridOrigin, worldOrigin, constants.STRUCTURE.BEACON.WIDTH,
            constants.STRUCTURE.BEACON.HEIGHT, constants.STRUCTURE.BEACON.COST,
            constants.STRUCTURE.BEACON.ATTACK_DAMAGE, constants.STRUCTURE.BEACON.ATTACK_INTERVAL,
            constants.STRUCTURE.BEACON.TARGETTING_RADIUS
        )
        self.mutable = false
        MeleeTower.resetTimers(self)
    end;
    attack = function(self, other)
        other:applyDebuff(Speedy(other, {DURATION = 10, TICK_DURATION = 10, SPEED_MODIFIER = 0.71}))
    end;
    update = function(self, dt)
        MeleeTower.update(self, dt)
    end;
    addMutation = function(self, mutation)
        assert(mutation and mutation.id)
        MeleeTower.addMutation(self, mutation, animationController:createInstance(self.towerType..'-'..mutation.id))
    end;
    draw = function(self, blockingPath)
        love.graphics.setColor(constants.COLOURS.AURA_RANGE)
        love.graphics.rectangle('fill', self.worldOrigin.x - self.targettingRadius*constants.GRID.CELL_SIZE, self.worldOrigin.y - self.targettingRadius*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.width)*constants.GRID.CELL_SIZE, (2*self.targettingRadius+self.height)*constants.GRID.CELL_SIZE)
        
        MeleeTower.draw(self, blockingPath)
    end;
}