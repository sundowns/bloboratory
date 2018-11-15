Impact = Class {
    init = function(self, worldOrigin, width, height, attackFunction)
        self.type = "IMPACT"
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.markedForDeath = false
        self.active = true
        self.opacity = constants.IMPACTS.BASE_OPACITY 
        
        self.deathTimer = Timer.new()
        self.deathTimer:after(constants.IMPACTS.FADEOUT_DURATION, function()
            self.markedForDeath = true
        end)
        self.deathTimer:tween(constants.IMPACTS.FADEOUT_DURATION, self, {opacity = 0})
    end;
    update = function(self, dt)
        self.deathTimer:update(dt)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x-self.width/2, self.worldOrigin.y-self.height/2, self.width, self.height
    end;
    draw = function(self)
        love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.opacity)
        love.graphics.rectangle('fill', self:calculateHitbox())
    end;
    attack = function(self)
        print('[WARNING] base impact attack function triggered. Should be overriden by subclass')
    end;
    deactivate = function(self)
        self.active = false
    end;
}

IceImpact = Class {
    __includes = Impact,
    init = function(self, origin, attackFunction)
        Impact.init(self, origin, constants.IMPACTS.ICE.WIDTH, constants.IMPACTS.ICE.HEIGHT, attackFunction)
        self.colour = {0,0,1,0.5} -- TODO: remove and replace with proper animation/something pretty
    end;
    attack = function(self, other)
        other:applyDebuff(Freeze(other))
    end;
}

ElectricImpact = Class {
    __includes = Impact,
    init = function(self, origin)
        Impact.init(self, origin, constants.IMPACTS.ELECTRIC.WIDTH, constants.IMPACTS.ELECTRIC.HEIGHT, attackFunction)
        self.colour = {1,1,0,0.5} -- TODO: remove and replace with proper animation/something pretty
    end;
    attack = function(self, other)
        other:takeDamage(constants.MUTATIONS.ELECTRIC.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*constants.MUTATIONS.ELECTRIC.MAXIMUM_EXTRA_DAMAGE, 3), false)
        other:applyDebuff(Electrify(other))
    end;
}

FireImpact = Class {
    __includes = Impact,
    init = function(self, origin, attackFunction)
        Impact.init(self, origin, constants.IMPACTS.FIRE.WIDTH, constants.IMPACTS.FIRE.HEIGHT, attackFunction)
        self.colour = {0.8,0.5,0} -- TODO: remove and replace with proper animation/something pretty
    end;
    attack = function(self, other)
        other:applyDebuff(Inflame(other))
    end;
}