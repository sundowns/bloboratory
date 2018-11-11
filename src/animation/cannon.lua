assert(assets.structures.cannon)
assert(anim8)

return {
    id = "CANNON",
    image = assets.structures.cannon,
    grid = anim8.newGrid(32, 32, assets.structures.cannon:getWidth(), assets.structures.cannon:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.15,
                x = 1,
                y = 9,
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
                y = 10,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = true,
                rotation = 0
            }
        },
    }
}
