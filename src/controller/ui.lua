UiController = Class {
    init = function(self)
    end;
    update = function(self, dt)
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.DEBUG_PRINT)
        love.graphics.print("CURRENT MARKET VALUE: " .. playerController.money, constants.UI.CURRENCY_COUNTER.X_OFFSET, constants.UI.CURRENCY_COUNTER.Y_OFFSET)
    end;
}