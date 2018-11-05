local image = nil

Obstacle = Class {
    __includes=Structure,
    init = function(self, gridOrigin, worldOrigin, width, height)
        Structure.init(self, image, gridOrigin, worldOrigin, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT)
        self.type = "OBSTACLE" 
    end;
    update = function(self, dt)
        --nothing bruh
    end;
}