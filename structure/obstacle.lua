local image = nil
local animationGrid = nil

Obstacle = Class {
    __includes=Structure,
    init = function(self, gridOrigin, worldOrigin, width, height)
        Structure.init(self, image, animationGrid, gridOrigin, worldOrigin, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT)
        self.type = "OBSTACLE" 
    end;
    update = function(self, dt)
        Structure.update(self, dt)
    end;
    draw = function(self)
        Structure.draw(self)
    end
}