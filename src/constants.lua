return {
    CAMERA = {
        SPEED = 200,
        PAN_RADIUS_RATIO = 0.425,
        MAX_ADDITIONAL_PAN_SPEED = 200,
        MOUSE = {
            WIDTH = 5,
            HEIGHT = 5
        }
    },
    COLOURS = {
        DEBUG_PRINT = {0,1,0}, --debug
        GAINS_TEXT_POSITIVE = {1,1,0},
        GAINS_TEXT_NEGATIVE = {1,0,0},
        EMPTY = {0,0,0},
        HOVERED = {0,1,0},
        HOVERED_INVALID = {1,0,0},
        OBSTACLE = {1,1,1, 0.5}, --debug 
        GOAL = {1,1,0},
        SPAWN_ACTIVE = {0,0,1},
        SPAWN_INACTIVE = {1,0,0},
        TOWER = {0.5,0,0.5}, -- debug
        ENEMY = {1,0,0}, -- debug
        CAMERA_PANZONES = {1,0.5,0}, -- debug,
        PROJECTILE = {0,0.5,1},
        SELECTION = {1,1,0}
    },
    GRID = {
        COLUMNS = 24,
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
            ATTACK_DAMAGE = 3, --damage per second 
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
            TARGETTING_RADIUS = 4, --additional cell radii
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
            }
        },
        ICE = {
            COST = {
                ICE = 10
            }
        },
    },
    PROJECTILE = {
        RADIUS = 6,
        CANNONBALL = {
            SPEED = 250
        },
    },
    ENEMY = {
        SPAWN_INTERVAL = 1,
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
            X = 0,
            Y = 0.86 * love.graphics.getHeight(),
            WIDTH = love.graphics.getWidth(),
            HEIGHT = 0.14 * love.graphics.getHeight(),
        },
        WALLET = {
            X = 0.775 * love.graphics.getWidth(),
            Y = 0.02 * love.graphics.getHeight(),
            WIDTH = 0.2 * love.graphics.getWidth(),
            HEIGHT = 0.03 * love.graphics.getHeight()
        }
    },
    DEBUFF = {
        INFLAME = {
            DURATION = 2,
            TICK_DURATION = 0.5,
            DAMAGE_PER_TICK = 2,
        },
        FREEZE = {
            DURATION = 3,
            TICK_DURATION = 0.5,
        },
    }
}