FloatingText = Class {
    init = function(self, text, origin, tickDelta)
        assert(text)
        assert(origin and origin.x and origin.y)
        assert(tickDelta)
        self.text = love.graphics.newText(love.graphics.getFont(), {constants.COLOURS.GAINS_TEXT, text})
        self.origin = origin
        self.tickDelta = tickDelta --a vector stating positional change per second
    end;
    update = function(self, dt)
        self.origin.x = self.origin.x + self.tickDelta.x*dt*constants.CURRENCY.GAINS.DRIFT_SPEED
        self.origin.y = self.origin.y + self.tickDelta.y*dt*constants.CURRENCY.GAINS.DRIFT_SPEED
    end;
    draw = function(self)
        love.graphics.draw(self.text, self.origin.x, self.origin.y)
    end;
}