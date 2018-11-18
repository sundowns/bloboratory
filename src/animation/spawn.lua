assert(assets.terrain.spawn)
assert(anim8)

return {
    id = "SPAWN",
    image = assets.terrain.spawn,
    grid = anim8.newGrid(16, 16, assets.terrain.spawn:getWidth(), assets.terrain.spawn:getHeight()),
    animation_names = {
        "DEFAULT",
        "SPAWNING_NONE",
        "SPAWNING_FIRE",
        "SPAWNING_ICE",
        "SPAWNING_ELECTRIC",
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.175,
                x = '1-3',
                y = 2,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
            SPAWNING_NONE = {
                frame_duration = 0.125,
                x = '1-3',
                y = 1,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
            SPAWNING_FIRE = {
                frame_duration = 0.125,
                x = '1-3',
                y = 3,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
            SPAWNING_ICE = {
                frame_duration = 0.125,
                x = '1-3',
                y = 4,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
            SPAWNING_ELECTRIC = {
                frame_duration = 0.125,
                x = '1-3',
                y = 5,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
        }
    }
}
