Mutation = Class {
    init = function(self, id, cost)
        self.id = id
        self.cost = cost
        self.areaOfEffect = false
    end;
    attack = function(self, other, dt)
        assert(other.type == "ENEMY")
    end;
    createImpact = function(self)
        --fallback function
        print("[WARNING] base mutation createImpact function called. Should be overriden by base class or mutation should not be area of effect")
    end;
}

FireMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "FIRE", constants.MUTATIONS.FIRE.COST)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Inflame(other))
    end;
    createImpact = function(self, origin)
        return FireImpact(origin)
    end;
}

IceMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ICE", constants.MUTATIONS.ICE.COST)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Freeze(other))
    end;
    createImpact = function(self, origin)
        return IceImpact(origin)
    end;
}

ElectricMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ELECTRIC", constants.MUTATIONS.ELECTRIC.COST)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:takeDamage(constants.MUTATIONS.ELECTRIC.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*constants.MUTATIONS.ELECTRIC.MAXIMUM_EXTRA_DAMAGE, 3), false, dt)
        other:applyDebuff(Electrify(other))
    end;
    createImpact = function(self, origin)
        return ElectricImpact(origin)
    end;
}