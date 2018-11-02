World = Class {
    init = function(self, origin, rows, cols)
        assert(origin.x)
        assert(origin.y)
        self.origin = origin
        self.grid = Grid(self.origin, rows, cols)
        self.goal = nil      
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        self.grid:draw()
    end;
    keypressed = function(self, key)
        --TODO: might not need this. A proper input handler/controller probably a better idea
    end;
    mousepressed = function(self, screen_x, screen_y, button)
        --TODO: same with above, input handler instead?
        local x, y = self.grid:calculateGridCoordinates(screen_x, screen_y)
        if self.grid:isOccupied(x, y) then
            if button == 1 then 
                self.grid:toggleObstacle(x, y)
                self.grid:calculatePaths()
            elseif button == 2 then
                self.grid:setGoal(x, y)
                self.grid:calculatePaths()
            end
        end
    end;
}