return {
    CANNON = {
        FIRE = {
            DURATION = 2,
            TICK_DURATION = 0.1,
            DAMAGE_PER_TICK = 0.4,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.2, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 3, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 2,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    SAW = {
        FIRE = {
            DURATION = 2,
            TICK_DURATION = 0.1,
            DAMAGE_PER_TICK = 0.4,
        }, 
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 0.1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 4, --total maximum is this + minimum
        }, 
        ICE = {
            DURATION = 2,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    },
    LASERGUN = {
        FIRE = {
            DURATION = 3,
            TICK_DURATION = 0.2,
            DAMAGE_PER_TICK = 1,
        },
        ELECTRIC = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            MINIMUM_DAMAGE = 1, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 5, --total maximum is this + minimum
        },
        ICE = {
            DURATION = 3,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
    }
}