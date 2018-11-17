return {
    CAMERA = {
        SPEED = 250,
        ADDITIONAL_SPEED_MODIFIER = 1.6,
        PANZONES = {
            TOP_BOTTOM = {
                HEIGHT = 0.04,
                WIDTH = 1
            },
            LEFT_RIGHT = {
                HEIGHT = 1,
                WIDTH = 0.04
            }
        },
        MOUSE = {
            WIDTH = 5,
            HEIGHT = 5
        }
    },
    COLOURS = {
        DEBUG_PRINT = {0,1,0}, --debug
        DEBUG_HITBOX = {1,0,0},
        BLUEPRINT_VALID = {0,1,0, 0.7},
        BLUEPRINT_INVALID = {1,0,0, 0.7},
        BLUEPRINT_RANGE = {0.8,0.5,0},
        TOWER = {0.5,0,0.5}, -- debug
        CAMERA_PANZONES = {1,0.5,0}, -- debug,
        PROJECTILE = {0,0.5,1},
        SELECTION = {1,1,0},
        OPTIMAL_PATH = {0,1,0.2,0.5}
    },
    GRID = {
        COLUMNS = 36,
        ROWS = 24,
        CELL_SIZE = 32,
    },
    STRUCTURE = {
        OBSTACLE = {
            WIDTH = 1, --cells
            HEIGHT = 1, --cells
            COST = {
                SCRAP = 1,
            }
        },
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 1, --damage per tick
            ATTACK_INTERVAL = 0.3, 
            TARGETTING_RADIUS = 1, --additional cell radii
            COST = {
                SCRAP = 5,
            }
        },
        CANNON = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 3, --damage per HIT 
            TARGETTING_RADIUS = 5, --additional cell radii
            ATTACK_INTERVAL = 0.5,
            COST = {
                SCRAP = 10,
            },
            ROTATION_TIME = 0.2
        }
    },
    MUTATIONS = {
        FIRE = {
            COST = {
                FIRE = 10
            }
        },
        ELECTRIC = {
            COST = {
                ELECTRIC = 10
            },
            MINIMUM_DAMAGE = 0.25, -- always applied! see below
            MAXIMUM_EXTRA_DAMAGE = 2, --total maximum is this + minimum
        },
        ICE = {
            COST = {
                ICE = 10
            }
        },
    },
    IMPACTS = {
        BASE_OPACITY = 0.3,
        FADEOUT_DURATION = 1.5,
        ELECTRIC = {
            WIDTH = 150,
            HEIGHT = 150,
        },
        ICE = {
            WIDTH = 200,
            HEIGHT = 200,
        },
        FIRE = {
            WIDTH = 150,
            HEIGHT = 150,
        },
    },
    PROJECTILE = {
        RADIUS = 6,
        CANNONBALL = {
            SPEED = 250,
            WIDTH = 12,
            HEIGHT = 12,
        },
    },
    ENEMY = {
        SPAWN_INTERVAL = 0.5,
        ORIENTATION_CHANGE_TIME = 0.15,
        HEALTHBAR = {
            TIMEOUT = 1,
            WIDTH = 32,
            HEIGHT = 3
        },
        BLOB = {
            HEALTH = 10,
            SPEED = 150,
            YIELD = {
                SCRAP = 1
            },
        },
        BLOBFIRE = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                FIRE = 1
            },
        },
        BLOBICE = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                ICE = 1
            },
        },
        BLOBELECTRIC = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                ELECTRIC = 1
            },
        },
        LARGEBLOB = {
            HEALTH = 20,
            SPEED = 120,
            YIELD = {
                SCRAP = 3
            },
        },
        LARGEBLOBFIRE = {
            HEALTH = 20,
            SPEED = 120,
            YIELD = {
                FIRE = 3
            },
        },
        LARGEBLOBICE = {
            HEALTH = 20,
            SPEED = 120,
            YIELD = {
                ICE = 3
            },
        },
        LARGEBLOBELECTRIC = {
            HEALTH = 20,
            SPEED = 120,
            YIELD = {
                ELECTRIC = 3
            },
        },
    },
    CURRENCY = {
        STARTING_SCRAP = 100,
        GAINS = {
            DRIFT_SPEED = 50,
            TIME_TO_LIVE = 1,
            X_OFFSET = 22.8,
            Y_OFFSET = 12,
        }
    },
    UI = {
        MENU = {
            X = 0.15,
            Y = 0.88,
            WIDTH = 0.25,
            HEIGHT = 0.125,
            LAYOUTROW_HEIGHT = 0.055,
        },
        WALLET = {
            X = 0.775,
            Y = 0.02,
            WIDTH = 0.2,
            HEIGHT = 0.03,
        },
        CRUCIBLE = {
            X = 0.4,
            Y = 0.755,
            WIDTH = 0.2,
            HEIGHT = 0.25,
            LAYOUTROW_HEIGHT = 0.075,
        },
        SELECTED = {
            X = 0.6,
            Y = 0.88,
            WIDTH = 0.25,
            HEIGHT = 0.125,
            LAYOUTROW_HEIGHT = 0.055,
        },
        STATS = {
            X = 0.85,
            Y = 0.88,
            WIDTH = 0.15,
            HEIGHT = 0.125,
            LAYOUTROW_HEIGHT = 0.1
        },
        PICKER = {
            X = 0.25,
            Y = 0.25,
            WIDTH = 0.5,
            HEIGHT = 0.5,
            LAYOUTROW_HEIGHT = 0.1,
        },
    },
    DEBUFF = {
        MAX_PARTICLES = 8,
        INFLAME = {
            DURATION = 2,
            TICK_DURATION = 0.1,
            DAMAGE_PER_TICK = 0.4,
        },
        FREEZE = {
            DURATION = 2,
            TICK_DURATION = 0.25,
            SPEED_MODIFIER = 0.5, -- 50% total speed
        },
        ELECTRIFY = {
            DURATION = 3,
            TICK_DURATION = 0.25,
        },
    }
}