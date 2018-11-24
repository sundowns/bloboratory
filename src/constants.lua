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
        STRUCTURE_RANGE = {0.8,0.5,0,0.3},
        TOWER = {0.5,0,0.5}, -- debug
        CAMERA_PANZONES = {1,0.5,0}, -- debug,
        PROJECTILE = {0,0.5,1},
        SELECTION = {1,1,0},
        OPTIMAL_PATH = {0,1,0.2,0.5},
        UI = {
            NONE = nk.colorRGBA(0,0,0,0),
            BLACK = nk.colorRGBA(0,0,0,255),
            DISABLED = nk.colorRGBA(32,32,32,255),
            WHITE = nk.colorRGBA(255,255,255,255),
            PANEL = nk.colorRGBA(48, 31, 17, 255),
            PANEL_LIGHT = nk.colorRGBA(147,96,51,255),
            PANEL_DARK = nk.colorRGBA(108,70,37,255),
            PANEL_TRANSPARENT = nk.colorRGBA(48, 31, 17, 128),
            PANEL_TRANSPARENT_LIGHT = nk.colorRGBA(147,96,51,128),
            PANEL_TRANSPARENT_DARK = nk.colorRGBA(108,70,37,128),
        },
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
            },
            TOOLTIP = "Obstacle: Cost = 1 scrap",
        },
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 1, --damage per tick
            ATTACK_INTERVAL = 0.3, 
            TARGETTING_RADIUS = 1, --additional cell radii
            COST = {
                SCRAP = 30,
            },
            TOOLTIP = "Saw: Cost = 30 scrap",
        },
        CANNON = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 6, --damage per HIT 
            TARGETTING_RADIUS = 5, --additional cell radii
            ATTACK_INTERVAL = 0.5,
            COST = {
                SCRAP = 30,
            },
            TOOLTIP = "Cannon: Cost = 30 scrap",
            ROTATION_TIME = 0.2
        },
        LASERGUN = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 4, --damage per HIT 
            LINE_LENGTH = 16, 
            LINE_WIDTH = -0.5,
            ATTACK_INTERVAL = 1.5,
            COST = {
                SCRAP = 30,
            },
            TOOLTIP = "Laserbeam: Cost = 30 scrap",
        },
    },
    MUTATIONS = {
        FIRE = {
            COST = {
                FIRE = 30
            }
        },
        ELECTRIC = {
            COST = {
                ELECTRIC = 30
            },
        },
        ICE = {
            COST = {
                ICE = 30
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
            WIDTH = 150,
            HEIGHT = 150,
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
            HEALTH = 8,
            SPEED = 150,
            YIELD = {
                SCRAP = 2
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
        BLOBSKULL = {
            HEALTH = 50,
            SPEED = 110,
            YIELD = {
                SCRAP = 10,
            },
        },
        BLOBTEETH = {
            HEALTH = 60,
            SPEED = 100,
            YIELD = {
                FIRE = 5,
                ICE = 5,
                ELECTRIC = 5,
            },
        },
    },
    CURRENCY = {
        STARTING_SCRAP = 75,
        STARTING_FIRE = 0, 
        STARTING_ICE = 0,
        STARTING_ELECTRIC = 0,
        GAINS = {
            DRIFT_SPEED = 50,
            TIME_TO_LIVE = 1,
            X_OFFSET = 22.8,
            Y_OFFSET = 12,
        }
    },
    UI = {
        OPTIONS_MENU = {
            X = 0.4,
            Y = 0.33,
            WIDTH = 0.2,
            HEIGHT = 0.4,
            LAYOUTROW_HEIGHT = 0.055,
            NAME = 'OptionsMenu'
        },
        OPTIONS_BUTTON = {
            X = 0.01,
            Y = 0.01,
            WIDTH = 0.075,
            HEIGHT = 0.04,
            LAYOUTROW_HEIGHT = 0.036,
            NAME = 'OptionsButton'
        },
        OPTIONS_SOUND = {
            X = 0.4,
            Y = 0.3,
            WIDTH = 0.2,
            HEIGHT = 0.3,
            LAYOUTROW_HEIGHT = 0.06,
            NAME = 'OptionsSound'
        },
        OVERHEAD = {
            X = 0,
            Y = 0,
            WIDTH = 1,
            HEIGHT = 0.055,
            LAYOUTROW_HEIGHT = 0.035
        },
        MENU = {
            X = 0,
            Y = 0.88,
            WIDTH = 0.4,
            HEIGHT = 0.125,
            LAYOUTROW_HEIGHT = 0.0775,
        },
        CRUCIBLE = {
            X = 0.4,
            Y = 0.76,
            WIDTH = 0.2,
            HEIGHT = 0.24,
            LAYOUTROW_HEIGHT = 0.064,
        },
        SELECTED = {
            X = 0.6,
            Y = 0.88,
            WIDTH = 0.4,
            HEIGHT = 0.125,
            LAYOUTROW_HEIGHT = 0.0775,
        },
        PICKER = {
            X = 0.25,
            Y = 0.18,
            WIDTH = 0.5,
            HEIGHT = 0.525,
            LAYOUTROW_HEIGHT = 0.1,
            NAME = 'Picker'
        },
    },
    DEBUFF = {
        MAX_PARTICLES = 8,
    },
    MUSIC = { -- index must match musicList index
        ROUND = 0.7,
        BUILD = 0.375,
    },
    AUDIO = { -- constant index must match tracklist index
        PLACE_STRUCTURE = {
            0.5,
            0.5,
            0.3,
        },
        REFUND = {
            10,
            10,
        },
        ENEMY_HIT = {
            0.8,
            1,
            0.8,
            1,
        },
        ENEMY_DEATH = {
            0.8,
            0.3,
            1.8,
            1.3,
        },
        ENEMY_LEAK = {
            4,
            4,
            4,
            4,
        },
        START_ROUND = {
            0.5,
        },
        WINNER = {
            1,
        },
        YOULOSE = {
            1,
        },
        UPGRADE_FIRE = {
            1.5,
        },
        UPGRADE_ICE = {
            1.5,
        },
        UPGRADE_ELECTRIC = {
            1,
        },
        INSUFFICIENT_FUNDS = {
            0.5,
        },
        CANNON_SHOOT = {
            5,
        },
        LASER_SHOOT = {
            1,
        },
    },
    RECIPE = {
        BONEMEAL = {2,3,2,0,1,0,0,1,0}
    },
    MISC = {
        STARTING_LIVES = 30,
    }
}