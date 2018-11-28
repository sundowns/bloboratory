Mutation = Class {
    init = function(self, id, cost)
        self.id = id
        self.cost = cost
        self.areaOfEffect = false
        self.stats = nil
    end;
    lookupStats = function(self, towerType)
        assert(towerType)
        self.stats = TOWER_STATS[towerType][self.id]
        assert(self.stats)
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
    init = function(self, cost)
        Mutation.init(self, "FIRE", cost)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Inflame(other, self.stats))
    end;
    createImpact = function(self, origin)
        return FireImpact(origin, self.stats)
    end;
}

IceMutation = Class {
    __includes = Mutation,
    init = function(self, cost)
        Mutation.init(self, "ICE", cost)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Freeze(other, self.stats))
    end;
    createImpact = function(self, origin)
        return IceImpact(origin, self.stats)
    end;
}

ElectricMutation = Class {
    __includes = Mutation,
    init = function(self, cost)
        Mutation.init(self, "ELECTRIC", cost)
        self.areaOfEffect = true
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:takeDamage(self.stats.MINIMUM_DAMAGE + Util.m.roundToNthDecimal(love.math.random()*self.stats.MAXIMUM_EXTRA_DAMAGE, 3), false, dt)
        other:applyDebuff(Electrify(other, self.stats))
    end;
    createImpact = function(self, origin)
        return ElectricImpact(origin, self.stats)
    end;
}