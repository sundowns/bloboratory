--[[
    Thoughts:
        * These are ok, but consider a 2D lookup table of BASE + MUTATION to return a collection of functions
        * Bare minimum this should include an update function that is called along the with the tower's normal update (or replace it entirely??)
]]

Mutation = Class {
    init = function(self, id)
        self.id = id
    end;
}

FireMutation = Class {
    __includes = Mutation,
    init = function(self)
        Mutation.init(self, "FIRE")
    end;
}
