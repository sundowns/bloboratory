Impact = Class {
    init = function(self, worldOrigin, width, height)
        self.type = "IMPACT"
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.markedForDeath = false
        self.active = true
        self.collides = true
        self.opacity = constants.IMPACTS.BASE_OPACITY 
        
        self.deathTimer = Timer.new()
        self.deathTimer:after(constants.IMPACTS.FADEOUT_DURATION, function()
            self.markedForDeath = true
        end)
        self.deathTimer:tween(constants.IMPACTS.FADEOUT_DURATION, self, {opacity = 0})
    end;
    update = function(self, dt)
        self.deathTimer:update(dt)
        if self.animation then 
            animationController:updateSpriteInstance(self.animation, dt)
        end
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x-self.width/2, self.worldOrigin.y-self.height/2, self.width, self.height
    end;
    draw = function(self)
        if self.animation then
            Util.l.resetColour()
            local x, y, width, height = self:calculateHitbox()
            animationController:drawImpactSpriteInstance(self.animation, self.worldOrigin, width, height)
        end
    end;
    attack = function(self)
        print('[WARNING] base impact attack function triggered. Should be overriden by subclass')
    end;
    deactivate = function(self)
        self.active = false
    end;
}

DefaultImpact = Class {
    __includes = Impact,
    init = function(self, origin)
        Impact.init(self, origin, constants.IMPACTS.DEFAULT.WIDTH, constants.IMPACTS.DEFAULT.HEIGHT)
        self.animation = animationController:createInstance("IMPACT")
        self.collides = false
    end;
    attack = function(self, other)
    end;
}

DefaultWhiteImpact = Class {
    __includes = Impact,
    init = function(self, origin)
        Impact.init(self, origin, constants.IMPACTS.DEFAULT.WIDTH, constants.IMPACTS.DEFAULT.HEIGHT)
        self.animation = animationController:createInstance("IMPACT-WHITE")
        self.collides = false
    end;
    attack = function(self, other)
    end;
}

IceImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats)
        Impact.init(self, origin, constants.IMPACTS.ICE.WIDTH, constants.IMPACTS.ICE.HEIGHT)
        self.colour = {0,0,1,0.5} 
        self.stats = stats
        self.animation = animationController:createInstance("IMPACT-ICE")
    end;
    attack = function(self, other)
        other:applyDebuff(Freeze(other, self.stats))
    end;
}

ElectricImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats)
        Impact.init(self, origin, constants.IMPACTS.ELECTRIC.WIDTH, constants.IMPACTS.ELECTRIC.HEIGHT)
        self.colour = {1,1,0,0.5}
        self.stats = stats
        self.animation = animationController:createInstance("IMPACT-ELECTRIC")
    end;
    attack = function(self, other)
        other:takeDamage(self.stats.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*self.stats.MAXIMUM_EXTRA_DAMAGE, 3), false)
        other:applyDebuff(Electrify(other, self.stats))
    end;
}

FireImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats)
        Impact.init(self, origin, constants.IMPACTS.FIRE.WIDTH, constants.IMPACTS.FIRE.HEIGHT)
        self.colour = {0.8,0.5,0}
        self.stats = stats
        self.animation = animationController:createInstance("IMPACT-FIRE")
    end;
    attack = function(self, other)
        other:applyDebuff(Inflame(other, self.stats))
    end;
}

LaserImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats, dimensions)
        Impact.init(self, origin, dimensions.width, dimensions.height)
        self.colour = {0.7,0,0.7} -- TODO: remove and replace with proper animation/something pretty
        self.stats = stats
    end;
    attack = function(self, other)
        other:takeDamage(self.stats.BASE_DAMAGE, true, 1)
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, self.width, self.height
    end;
    draw = function(self)
        love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.opacity)
        love.graphics.rectangle('fill', self:calculateHitbox())
    end;
}

LaserFireImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats, dimensions)
        Impact.init(self, origin, dimensions.width, dimensions.height)
        self.colour = {1,0,0} -- TODO: remove and replace with proper animation/something pretty
        self.stats = stats
    end;
    attack = function(self, other)
        other:takeDamage(self.stats.BASE_DAMAGE, true, 1)
        other:applyDebuff(Inflame(other, self.stats))
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, self.width, self.height
    end;
    draw = function(self)
        love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.opacity)
        love.graphics.rectangle('fill', self:calculateHitbox())
    end;
}

LaserElectricImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats, dimensions)
        Impact.init(self, origin, dimensions.width, dimensions.height)
        self.colour = {1,1,0} -- TODO: remove and replace with proper animation/something pretty
        self.stats = stats
    end;
    attack = function(self, other)
        other:takeDamage(self.stats.BASE_DAMAGE + self.stats.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*self.stats.MAXIMUM_EXTRA_DAMAGE, 3), true, 1)
        other:applyDebuff(Electrify(other, self.stats))
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, self.width, self.height
    end;
    draw = function(self)
        love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.opacity)
        love.graphics.rectangle('fill', self:calculateHitbox())
    end;
}

LaserIceImpact = Class {
    __includes = Impact,
    init = function(self, origin, stats, dimensions)
        Impact.init(self, origin, dimensions.width, dimensions.height)
        self.colour = {0,0,1} -- TODO: remove and replace with proper animation/something pretty
        self.stats = stats
    end;
    attack = function(self, other)
        other:takeDamage(self.stats.BASE_DAMAGE, true, 1)
        other:applyDebuff(Freeze(other, self.stats))
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x, self.worldOrigin.y, self.width, self.height
    end;
    draw = function(self)
        love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.opacity)
        love.graphics.rectangle('fill', self:calculateHitbox())
    end;
}