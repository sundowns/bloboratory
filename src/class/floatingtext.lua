FloatingText = Class {
    init = function(self, text, origin, tickDelta, colour, image)
        assert(text)
        assert(origin and origin.x and origin.y)
        assert(tickDelta)
        self.image = image
        self.colour = colour
        self.text = love.graphics.newText(assets.ui.neuropoliticalRg(20), {self.colour, text})
        self.origin = origin
        self.tickDelta = tickDelta --a vector stating positional change per second
    end;
    update = function(self, dt)
        self.origin.x = self.origin.x + self.tickDelta.x*dt*constants.CURRENCY.GAINS.DRIFT_SPEED
        self.origin.y = self.origin.y + self.tickDelta.y*dt*constants.CURRENCY.GAINS.DRIFT_SPEED
    end;
    draw = function(self)
        love.graphics.draw(self.image, self.origin.x - self.text:getWidth() - 10, self.origin.y, 0,  1.4, 1.4)
        love.graphics.draw(self.text, self.origin.x - self.text:getWidth()/2, self.origin.y)
    end;
}