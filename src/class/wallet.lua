local CURRENCIES = {
    "SCRAP",
    "FIRE",
    "ICE",
    "ELECTRIC",
}

Wallet = Class {
    init = function(self)
        self.currencies = {
            ["SCRAP"] = Currency("SCRAP", {0.7,0.7,0.7}, constants.CURRENCY.STARTING_SCRAP),
            ["FIRE"] = Currency("FIRE", {1,0.6,0}, 0),
            ["ICE"] = Currency("ICE", {0,0.8,0.8}, 0),
            ["ELECTRIC"] = Currency("ELECTRIC", {0.8,0.8,0}, 0),
        }
        self.totalCurrencies = #CURRENCIES
        self.floatingGains = {}
        self.gainTimer = Timer.new()
    end;
    canAfford = function(self, costTable)
        local canAfford = true
        for k, value in pairs(costTable) do
            assert(self.currencies[k], "Tried to compare invalid currency")
            if value > self.currencies[k].value then
                canAfford = false
                break
            end
        end
        return canAfford
    end;
    charge = function(self, costs, position)
        for type, value in pairs(costs) do
            self:updateCurrency(type, -1*value)
            if position then
                self:addFloatingGain('-'..value, position, self.currencies[type].colour)
                position.y = position.y - constants.CURRENCY.GAINS.Y_OFFSET
            end
        end
    end;
    refund = function(self, gains, position)
        for type, value in pairs(gains) do
            self:updateCurrency(type, value)
            if position then
                self:addFloatingGain('+'..value, position, self.currencies[type].colour)
                position.y = position.y - constants.CURRENCY.GAINS.Y_OFFSET
            end
        end
    end;
    updateCurrency = function(self, type, delta)
        assert(self.currencies[type], "Tried to update invalid currency")
        self.currencies[type]:updateValue(delta)
    end;
    addFloatingGain = function(self, amount, position, colour)
        --We deliberately create a new vector here so as to not update the original table
        table.insert(self.floatingGains, FloatingText(amount, Vector(position.x, position.y), Vector(0,-0.5), colour)) 
        self.gainTimer:after(constants.CURRENCY.GAINS.TIME_TO_LIVE, function()
            table.remove(self.floatingGains, 1)
        end)
    end;
    update = function(self, dt)
        self.gainTimer:update(dt)

        for i, gain in pairs(self.floatingGains) do
            gain:update(dt) 
        end
    end;
    draw = function(self)
        Util.l.resetColour()
        for i, gain in pairs(self.floatingGains) do 
            gain:draw()
        end
    end;
}
