Mutation = Class {
    init = function(self, id, cost)
        self.id = id
        self.cost = cost
    end;
    attack = function(self, other, dt)
        assert(other.type == "ENEMY")
    end;
}

FireMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "FIRE", constants.MUTATIONS.FIRE.COST)
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Inflame(other))
    end;
}

IceMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ICE", constants.MUTATIONS.ICE.COST)
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Freeze(other))
    end;
}

ElectricMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ELECTRIC", constants.MUTATIONS.ELECTRIC.COST)
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        --apply some additional high variance damage
        other:applyDebuff(Electrify(other))
    end;
}