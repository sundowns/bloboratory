Currency = Class{
    init = function(self, name, colour, value)
        self.name = name
        self.colour = colour
        self.value = value
    end;
    draw = function(self, x, y)
        love.graphics.setColor(self.colour)
        love.graphics.print(self.value, x, y)
    end;
    updateValue = function(self, delta)
        self.value = self.value + delta
    end;
}