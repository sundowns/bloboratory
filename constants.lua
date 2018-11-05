return {
    CAMERA = {
        SPEED = 300,
        PANZONES = {
            TOP_BOTTOM = {
                HEIGHT = 0.06,
                WIDTH = 1
            },
            LEFT_RIGHT = {
                HEIGHT = 1,
                WIDTH = 0.06
            }
        },
        MOUSE = {
            WIDTH = 5,
            HEIGHT = 5
        }
    },
    COLOURS = {
        DEBUG_PRINT = {0,1,0}, --debug
        EMPTY = {0,0,0},
        HOVERED = {0,1,0},
        HOVERED_INVALID = {1,0,0},
        OBSTACLE = {1,1,1}, --debug 
        GOAL = {1,1,0},
        SPAWN_ACTIVE = {0,0,1},
        SPAWN_INACTIVE = {1,0,0},
        TOWER = {0.5,0,1}, -- debug
        ENEMY = {1,0,0}, -- debug
        CAMERA_PANZONES = {1,0.5,0}, -- debug,
        PROJECTILE = {0,0.5,1}
    },
    GRID = {
        COLUMNS = 24,
        ROWS = 24,
        CELL_SIZE = 32,
    },
    TOWER = {
        OBSTACLE = {
            WIDTH = 1, --cells
            HEIGHT = 1, --cells
        },
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 5, --damage per second 
            TARGETTING_RADIUS = 1 --additional cell radii
        },
        SPUDGUN = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 1.5, --damage per HIT 
            TARGETTING_RADIUS = 3, --additional cell radii
            ATTACK_INTERVAL = 0.2
        }
    },
    PROJECTILE = {
        RADIUS = 5,
        SPUD = {
            SPEED = 8
        },
    },
    ENEMY = {
        SPAWN_INTERVAL = 1,
        SMALLGUY = {
            HEALTH = 10,
            SPEED = 10,
            RADIUS = 4,
        },
        LARGEGUY = {
            HEALTH = 15,
            SPEED = 10,
            RADIUS = 8,
        }
    }
}