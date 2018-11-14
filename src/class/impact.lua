Impact = Class {
    init = function(self, worldOrigin, width, height, attackFunction)
        self.type = "IMPACT"
        self.worldOrigin = worldOrigin
        self.width = width
        self.height = height
        self.markedForDeath = false
    end;
    calculateHitbox = function(self)
        return self.worldOrigin.x-self.width/2, self.worldOrigin.y-self.height/2, self.width, self.height
    end;
    attack = function(self)
        print('[WARNING] base impact attack function triggered. Should be overriden by subclass')
    end;
}

IceImpact = Class {
    __includes = Impact,
    init = function(self, origin, attackFunction)
        Impact.init(self, origin, constants.IMPACTS.ICE.WIDTH, constants.IMPACTS.ICE.HEIGHT, attackFunction)
    end;
    attack = function(self, other)
        other:applyDebuff(Freeze(other))
    end;
}

ElectricImpact = Class {
    __includes = Impact,
    init = function(self, origin)
        Impact.init(self, origin, constants.IMPACTS.ELECTRIC.WIDTH, constants.IMPACTS.ELECTRIC.HEIGHT, attackFunction)
    end;
    attack = function(self, other)
        other:takeDamage(constants.MUTATIONS.ELECTRIC.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*constants.MUTATIONS.ELECTRIC.MAXIMUM_EXTRA_DAMAGE, 3), false)
        other:applyDebuff(Electrify(other))
    end;
}