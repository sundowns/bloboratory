assert(assets.towers.cannon)
assert(anim8)

return {
    id = "CANNON",
    image = assets.towers.cannon,
    grid = anim8.newGrid(32, 32, assets.towers.cannon:getWidth(), assets.towers.cannon:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.15,
                x = 1,
                y = 3,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0
            },
        },
        {
            DEFAULT = {
                frame_duration = 0.15,
                x = 1,
                y = 4,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = true,
                rotation = 0
            }
        },
    }
}
