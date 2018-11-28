return {
    CANNON = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.19,
            DAMAGE_PER_TICK = 2,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.2, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 5, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 2,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    SAW = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.12,
            DAMAGE_PER_TICK = 2,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 6, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 4,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    LASERGUN = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.2,
            DAMAGE_PER_TICK = 3,
        },
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 6, --total maximum is this + minimum
        },
        ICE = {
            DURATION = 4,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    BEACON = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.12,
            DAMAGE_PER_TICK = 2,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 6, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 4,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    BOUNCER = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.12,
            DAMAGE_PER_TICK = 2,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 6, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 4,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    }
}