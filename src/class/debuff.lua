local PARTICLES_GRID_WIDTH = 8
local ELECTRIC_PARTICLE_QUADS = {
    love.graphics.newQuad(0*PARTICLES_GRID_WIDTH, 3*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(0*PARTICLES_GRID_WIDTH, 0*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(1*PARTICLES_GRID_WIDTH, 3*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(1*PARTICLES_GRID_WIDTH, 0*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(2*PARTICLES_GRID_WIDTH, 3*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(2*PARTICLES_GRID_WIDTH, 0*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
}
local ICE_PARTICLE_QUADS = {
    love.graphics.newQuad(0*PARTICLES_GRID_WIDTH, 1*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(1*PARTICLES_GRID_WIDTH, 1*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(2*PARTICLES_GRID_WIDTH, 1*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
}
local FIRE_PARTICLE_QUADS = {
    love.graphics.newQuad(0*PARTICLES_GRID_WIDTH, 2*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(1*PARTICLES_GRID_WIDTH, 2*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
    love.graphics.newQuad(2*PARTICLES_GRID_WIDTH, 2*PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, PARTICLES_GRID_WIDTH, assets.particles.mutators:getDimensions()),
}

Debuff = Class {
    init = function(self, type, owner, debuffDuration, tickDuration, particleQuads)
        self.type = type
        self.duration = debuffDuration
        self.tickDuration = tickDuration
        self.timer = Timer.new()
        self.alive = true
        self.owner = owner
        if particleQuads then
            self:initialiseParticleSystem(assets.particles.mutators, constants.DEBUFF.MAX_PARTICLES, particleQuads)
        end
        self:apply()
    end;
    initialiseParticleSystem = function(self, particle, maxParticles, quads)
        self.particleSystem = love.graphics.newParticleSystem(particle, maxParticles)
        if quads then
            self.particleSystem:setQuads(quads)
        end
        self.particleSystem:setEmissionRate(6)
        self.particleSystem:setEmissionArea('normal', 5, 3)
        self.particleSystem:setLinearAcceleration(-4, -4, 4, 2)
        self.particleSystem:setSizes(0.5, 1, 0.3)
        self.particleSystem:setRotation(0, math.pi/2)
        self.particleSystem:setParticleLifetime(0.5, 2)
        self.particleSystem:emit(3)
    end;
    update = function(self, dt)
        self.timer:update(dt) 

        if self.particleSystem then
            self.particleSystem:update(dt)
        end
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
    draw = function(self, position)
        if self.particleSystem then
            love.graphics.draw(self.particleSystem, position.x, position.y)
        end
    end;
    activate = function(self)
    end;
    deactivate = function(self)
    end;
}

Inflame = Class {
    __includes = Debuff,
    init = function(self, owner, stats)
        Debuff.init(self, "INFLAME", owner, stats.DURATION, stats.TICK_DURATION, FIRE_PARTICLE_QUADS)
        self.damagePerTick = stats.DAMAGE_PER_TICK
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
        self.owner:takeDamage(self.damagePerTick, false)
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
    init = function(self, owner, stats)
        Debuff.init(self, "FREEZE", owner, stats.DURATION, stats.TICK_DURATION, ICE_PARTICLE_QUADS)
        self.speedModifier = stats.SPEED_MODIFIER
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
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
    init = function(self, owner, stats)
        Debuff.init(self, "ELECTRIFY", owner, stats.DURATION, stats.TICK_DURATION, ELECTRIC_PARTICLE_QUADS)
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
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

Speedy = Class {
    __includes = Debuff,
    init = function(self, owner, stats)
        Debuff.init(self, "SPEEDY", owner, stats.DURATION, stats.TICK_DURATION, ELECTRIC_PARTICLE_QUADS)
        self.speedModifier = stats.SPEED_MODIFIER
    end;
    update = function(self, dt)
        Debuff.update(self, dt)
    end;
    tick = function(self)
    end;
    apply = function(self)
        Debuff.apply(self)
    end;
    activate = function(self)
        Debuff.activate(self)

        if self.owner then
            self.owner.attackInterval = self.owner.attackInterval * self.speedModifier
            self.owner:resetTimers()
        end
    end;
    deactivate = function(self)
        Debuff.deactivate(self)

        if self.owner then
            self.owner.attackInterval = self.owner.attackInterval / self.speedModifier
        end
    end;
}
