Currency = Class{
    init = function(self, name, colour, value, image)
        self.name = name
        self.colour = colour
        self.value = value
        self.image = image
    end;
    draw = function(self, x, y)
        love.graphics.setColor(self.colour)
        love.graphics.print(self.value, x, y)
    end;
    updateValue = function(self, delta)
        self.value = self.value + delta
    end;
    colourRGB = function(self)
        --Helper function to make colours easier to use with nuklear's functions.
        return self.colour[1]*255, self.colour[2]*255, self.colour[3]*255
    end;
}