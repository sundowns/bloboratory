local image = nil

Obstacle = Class {
    __includes=Structure,
    init = function(self, gridOrigin, worldOrigin, width, height)
        Structure.init(self, image, gridOrigin, worldOrigin, constants.TOWER.OBSTACLE.WIDTH, constants.TOWER.OBSTACLE.HEIGHT)
        self.type = "OBSTACLE" 
    end;
    update = function(self, dt)
        --nothing bruh
    end;
}