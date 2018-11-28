assert(assets.structures.beacon)
assert(anim8)

return {
    id = "BEACON",
    image = assets.structures.beacon,
    grid = anim8.newGrid(32, 32, assets.structures.beacon:getWidth(), assets.structures.beacon:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 10000,
                x = 1,
                y = 1,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0
            },
        },
    }
}
