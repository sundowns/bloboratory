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
            COST = 1
        },
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 3, --damage per second 
            TARGETTING_RADIUS = 1, --additional cell radii
            COST = 5
        },
        CANNON = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 3, --damage per HIT 
            TARGETTING_RADIUS = 4, --additional cell radii
            ATTACK_INTERVAL = 0.5,
            COST = 10,
            ROTATION_TIME = 0.2
        }
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
        SMALLGUY = {
            HEALTH = 10,
            SPEED = 150,
            YIELD = 1,
        },
        LARGEGUY = {
            HEALTH = 20,
            SPEED = 120,
            YIELD = 2,
        }
    },
    CURRENCY = {
        GAINS = {
            DRIFT_SPEED = 50,
            TIME_TO_LIVE = 1,
            X_OFFSET = 22.8
        }
    },
    UI = {
        CURRENCY_COUNTER = {
            X_OFFSET = 0.766 * love.graphics.getWidth(),
            Y_OFFSET = 0.02 * love.graphics.getHeight()
        }
    },
    DEBUFF = {
        INFLAME = {
            DURATION = 1,
            TICK_DURATION = 0.1,
            DAMAGE_PER_TICK = 0.25,
        },
        FREEZE = {
            DURATION = 3,
            TICK_DURATION = 0.5,
        },
    }
}