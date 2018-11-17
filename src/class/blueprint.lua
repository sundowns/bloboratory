Blueprint = Class {
    init = function(self, name, image, width, height, scaleX, scaleY, hitboxRadius)
        self.name = name
        self.image = image
        self.width = width -- width (in cells) of the blueprinted structure
        self.height = height -- height (in cells) of the blueprinted structure
        self.scaleX = scaleX or 1
        self.scaleY = scaleY or 1
        self.cost = constants.STRUCTURE[self.name].COST
        self.hitboxRadius = hitboxRadius
    end;
    update = function(self)
    end;
    draw = function(self, origin)
        love.graphics.draw(self.image, origin.x, origin.y, 0, self.width*self.scaleX, self.height*self.scaleY)

        if self.hitboxRadius > 0 then
            love.graphics.setColor(constants.COLOURS.BLUEPRINT_RANGE)
            love.graphics.setLineWidth(5)
            love.graphics.rectangle('line', origin.x - self.hitboxRadius*constants.GRID.CELL_SIZE, origin.y - self.hitboxRadius*constants.GRID.CELL_SIZE, (2*self.hitboxRadius+self.width)*constants.GRID.CELL_SIZE, (2*self.hitboxRadius+self.height)*constants.GRID.CELL_SIZE)
        end
    end;
}