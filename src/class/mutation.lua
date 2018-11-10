Mutation = Class {
    init = function(self, id)
        self.id = id
    end;
    attack = function(self, other, dt)
        assert(other.type == "ENEMY")
    end;
}

FireMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "FIRE")
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Inflame(other))
    end;
}

IceMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ICE")
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        other:applyDebuff(Freeze(other))
    end;
}

ElectricMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "ELECTRIC")
    end;
    attack = function(self, other, dt)
        Mutation.attack(self, other, dt)
        --apply some additional high variance damage
    end;
}