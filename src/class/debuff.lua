Debuff = Class {
    init = function(self, type, owner, debuffDuration, tickDuration)
        self.type = type
        self.duration = debuffDuration
        self.tickDuration = tickDuration
        self.timer = Timer.new()
        self.alive = true
        self.owner = owner

        self:apply()
    end;
    update = function(self, dt)
        self.timer:update(dt) 
    end;
    apply = function(self)
        self.timer:clear()
        local handle = self.timer:every(self.tickDuration, function() 
            self:tick()
        end)

        self.timer:after(self.duration, function()
            self.timer:cancel(handle)
            self.alive = false
            self:remove()
        end)
    end;
    remove = function(self)
        --TODO: some logic to undo a debuff (i.e. speed back up when freeze ends)
    end;
}

Inflame = Class {
    __includes = Debuff,
    init = function(self, owner)
        Debuff.init(self, "INFLAME", owner, constants.DEBUFF.INFLAME.DURATION, constants.DEBUFF.INFLAME.TICK_DURATION)
        self.damagePerTick = constants.DEBUFF.INFLAME.DAMAGE_PER_TICK
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
        self.owner:takeDamage(self.damagePerTick)
        --TODO: emit some particles?
    end;
    apply = function(self)
        Debuff.apply(self)
    end;
    remove = function(self)
        Debuff.remove(self)
    end;
}

Freeze = Class {
    __includes = Debuff,
    init = function(self, owner)
        Debuff.init(self, "FREEZE", owner, constants.DEBUFF.FREEZE.DURATION, constants.DEBUFF.FREEZE.TICK_DURATION)
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
        --TODO: emit some particles?
    end;
    apply = function(self)
        Debuff.apply(self)
    end;
    remove = function(self)
        Debuff.remove(self)
    end;
}
