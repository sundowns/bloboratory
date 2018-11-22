Obstacle = Class {
    __includes=Structure,
    init = function(self, gridOrigin, worldOrigin, width, height)
        self.type = "OBSTACLE" 
        Structure.init(self, animationController:createInstance(self.type), gridOrigin, worldOrigin, constants.STRUCTURE.OBSTACLE.WIDTH, constants.STRUCTURE.OBSTACLE.HEIGHT, constants.STRUCTURE.OBSTACLE.COST)
    end;
    update = function(self, dt)
        Structure.update(self, dt)
    end;
}