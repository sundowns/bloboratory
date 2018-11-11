local animation = nil

Obstacle = Class {
    __includes=Structure,
    init = function(self, gridOrigin, worldOrigin, width, height)
        Structure.init(self, animation, gridOrigin, worldOrigin, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT, constants.STRUCTURE.OBSTACLE.COST)
        self.type = "OBSTACLE" 
    end;
    update = function(self, dt)
        Structure.update(self, dt)
    end;
    draw = function(self)
        Structure.draw(self)
    end
}