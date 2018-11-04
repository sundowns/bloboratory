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
        DEBUG_PRINT = {0,1,0},
        EMPTY = {0,0,0},
        HOVERED = {0,1,0},
        OBSTACLE = {1,1,1},
        GOAL = {1,1,0},
        SPAWN_ACTIVE = {0,0,1},
        SPAWN_INACTIVE = {1,0,0},
        TOWER = {0.5,0,1},
        ENEMY = {1,0,0},
        CAMERA_PANZONES = {1,0.5,0}
    },
    GRID = {
        COLUMNS = 24,
        ROWS = 24,
        CELL_SIZE = 32,
    },
    TOWER = {
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 5, --damage per second 
            ATTACK_RADIUS = 1 --additional cell radii
        }
    },
    ENEMY = {
        RADIUS = 4,
        SPAWN_INTERVAL = 1,
        SMALLGUY = {
            HEALTH = 10,
            SPEED = 10
        }
    }
}