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
        end)
    end;
    activate = function(self)
    end;
    deactivate = function(self)
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
        self.owner:takeDamage(self.damagePerTick, false) --TODO: pass in a mutator specific sound (zap, sizzle, freeze?)
        --TODO: emit some particles?
    end;
    apply = function(self)
        Debuff.apply(self)
    end;
    activate = function(self)
        Debuff.activate(self)
    end;
    deactivate = function(self)
        Debuff.deactivate(self)
    end;
}

Freeze = Class {
    __includes = Debuff,
    init = function(self, owner)
        Debuff.init(self, "FREEZE", owner, constants.DEBUFF.FREEZE.DURATION, constants.DEBUFF.FREEZE.TICK_DURATION)
        self.speedModifier = constants.DEBUFF.FREEZE.SPEED_MODIFIER
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
    activate = function(self)
        Debuff.activate(self)

        if self.owner and not self.owner.markedForDeath then
            self.owner.speed = self.owner.speed * self.speedModifier
        end
    end;
    deactivate = function(self)
        Debuff.deactivate(self)
        
        if self.owner and not self.owner.markedForDeath then
            self.owner.speed = self.owner.speed / self.speedModifier
        end
    end;
}

Electrify = Class {
    __includes = Debuff,
    init = function(self, owner)
        Debuff.init(self, "ELECTRIFY", owner, constants.DEBUFF.ELECTRIFY.DURATION, constants.DEBUFF.ELECTRIFY.TICK_DURATION)
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
    activate = function(self)
        Debuff.activate(self)
    end;
    deactivate = function(self)
        Debuff.deactivate(self)
    end;
}
