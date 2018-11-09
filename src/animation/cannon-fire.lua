assert(assets.towers.cannon)
assert(anim8)

return {
    id = "CANNON-FIRE",
    image = assets.towers.cannon,
    grid = anim8.newGrid(32, 32, assets.towers.cannon:getWidth(), assets.towers.cannon:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.15,
                x = '1-3',
                y = 1,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0,
            }
        },
        {
            DEFAULT = {
                frame_duration = 1,
                x = 1,
                y = 2,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = true,
                rotation = 0
            }
        },
    },

}