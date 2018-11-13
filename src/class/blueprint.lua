Blueprint = Class {
    init = function(self, name, image, width, height, scaleX, scaleY)
        self.name = name
        self.image = image
        self.width = width -- width (in cells) of the blueprinted structure
        self.height = height -- height (in cells) of the blueprinted structure
        self.scaleX = scaleX or 1
        self.scaleY = scaleY or 1
        self.cost = constants.STRUCTURE[self.name].COST
    end;
    update = function(self)
    end;
    draw = function(self, x, y)
        love.graphics.draw(self.image, x, y, 0, self.width*self.scaleX, self.height*self.scaleY)
    end;
}