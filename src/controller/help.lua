HelpController = Class {
    init = function(self, textLogOrigin)
        self.textLogOrigin = textLogOrigin
        self.textLog = {}
        self.fontSize = 16
        self.textTimer = Timer.new()
        self.defaultTTL = 5
        self.maxEntriesToShow = 6
    end;
    update = function(self, dt)
        self.textTimer:update(dt)
    end;
    addText = function(self, message, timeToLive, colour)
        if #self.textLog >= self.maxEntriesToShow then return end
        local timeToLive = timeToLive or self.defaultTTL
        local colour = colour or {1,1,1}
        local text = love.graphics.newText(assets.ui.planerRegular(self.fontSize))
        text:setf(message, constants.UI.CRUCIBLE.X*love.graphics.getWidth()*0.975, 'left')
        local helpText = HelpText(text, colour)
        self.textTimer:after(timeToLive, function()
            table.remove(self.textLog, 1)
        end)
        self.textTimer:tween(timeToLive, helpText, {opacity = 0}, 'in-quart')

        table.insert(self.textLog, helpText)
    end;
    draw = function(self)
        local offset = 0
        for i, entry in ipairs(self.textLog) do
            if i <= self.maxEntriesToShow then
                love.graphics.setColor(entry.colour[1], entry.colour[2], entry.colour[3], entry.opacity)
                love.graphics.draw(entry.text, self.textLogOrigin.x, self.textLogOrigin.y - offset)
                offset = offset + entry.text:getHeight()
            end
        end
    end;
}

HelpText = Class {
    init = function(self, text, colour)
        self.text = text
        self.colour = colour
        self.opacity = 1
    end;
}