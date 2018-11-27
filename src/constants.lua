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
            WIDTH = 20,
            HEIGHT = 20
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
            TOOLTIP = "Obstacle - Cost: 1 scrap",
        },
        SAW = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            ATTACK_DAMAGE = 3, --damage per tick
            ATTACK_INTERVAL = 0.25, 
            TARGETTING_RADIUS = 1, --additional cell radii
            COST = {
                SCRAP = 25,
            },
            TOOLTIP = "Saw - Cost: 25 scrap",
        },
        CANNON = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 7, --damage per HIT 
            TARGETTING_RADIUS = 4, --additional cell radii
            ATTACK_INTERVAL = 0.6,
            COST = {
                SCRAP = 30,
            },
            TOOLTIP = "Cannon - Cost: 30 scrap",
            ROTATION_TIME = 0.2
        },
        LASERGUN = {
            WIDTH = 2, --cells
            HEIGHT = 2, --cells
            BARREL_LENGTH = 32, --used to offset projectiles
            ATTACK_DAMAGE = 12, --damage per HIT 
            LINE_LENGTH = 16, 
            LINE_WIDTH = 0.5,
            ATTACK_INTERVAL = 1,
            COST = {
                SCRAP = 35,
            },
            TOOLTIP = "Laserbeam - Cost: 35 scrap",
        },
    },
    MUTATIONS = {
        FIRE = {
            COST = {
                FIRE = 40
            }
        },
        ELECTRIC = {
            COST = {
                ELECTRIC = 40
            },
        },
        ICE = {
            COST = {
                ICE = 40
            }
        },
    },
    IMPACTS = {
        BASE_OPACITY = 0.2,
        FADEOUT_DURATION = 0.15,
        ELECTRIC = {
            WIDTH = 80,
            HEIGHT = 80,
        },
        ICE = {
            WIDTH = 100,
            HEIGHT = 100,
        },
        FIRE = {
            WIDTH = 120,
            HEIGHT = 120,
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
        BLOBLARGE = {
            HEALTH = 35,
            SPEED = 150,
            YIELD = {
                SCRAP = 4
            },
        },
        BLOBFIRE = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                FIRE = 1
            },
        },
        BLOBFIRELARGE = {
            HEALTH = 45,
            SPEED = 150,
            YIELD = {
                FIRE = 2
            },
        },
        BLOBICE = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                ICE = 1
            },
        },
        BLOBICELARGE = {
            HEALTH = 45,
            SPEED = 150,
            YIELD = {
                ICE = 2
            },
        },
        BLOBSPARK = {
            HEALTH = 12,
            SPEED = 150,
            YIELD = {
                ELECTRIC = 1
            },
        },
        BLOBSPARKLARGE = {
            HEALTH = 45,
            SPEED = 150,
            YIELD = {
                ELECTRIC = 2
            },
        },
        BLOBSKULL = {
            HEALTH = 100,
            SPEED = 80,
            YIELD = {
                SCRAP = 10,
            },
        },
        BLOBTEETH = {
            HEALTH = 50,
            SPEED = 120,
            YIELD = {
                FIRE = 3,
                ICE = 3,
                ELECTRIC = 3,
            },
        },
    },
    CURRENCY = {
        STARTING_SCRAP = 175,
        STARTING_FIRE = 0, 
        STARTING_ICE = 0,
        STARTING_ELECTRIC = 0,
        GAINS = {
            DRIFT_SPEED = 50,
            TIME_TO_LIVE = 1,
            X_OFFSET = 22.8,
            Y_OFFSET = 24,
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
            LAYOUTROW_HEIGHT = 0.0725,
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
            LAYOUTROW_HEIGHT = 0.0725,
        },
        PICKER = {
            X = 0.15,
            Y = 0.09,
            WIDTH = 0.7,
            HEIGHT = 0.55,
            LAYOUTROW_HEIGHT = 0.075,
            NAME = 'Picker',     
        },
        HELPLOG = {
            X = 0.01,
            Y = 0.83,
        }
    },
    DEBUFF = {
        MAX_PARTICLES = 8,
    },
    MUSIC = { -- index must match musicList index
        0.7,
        0.475,
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
            1.2,
        },
        UPGRADE_ICE = {
            1.2,
        },
        UPGRADE_ELECTRIC = {
            1,
        },
        INSUFFICIENT_FUNDS = {
            0.5,
        },
        CANNON_SHOOT = {
            0.8,
        },
        LASERGUN_SHOOT = {
            0.5,
        },
        BUTTON_PRESS = {
            0.6,
        }
    },
    RECIPE = {
        BONEMEAL = {2,3,2,0,1,0,0,1,0}
    },
    MISC = {
        STARTING_LIVES = 30,
    }
}