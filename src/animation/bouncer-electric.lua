assert(assets.structures.bouncer)
assert(anim8)

return {
    id = "BOUNCER-ELECTRIC",
    image = assets.structures.bouncer,
    grid = anim8.newGrid(32, 32, assets.structures.bouncer:getWidth(), assets.structures.bouncer:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.15,
                x = '1-3',
                y = 4,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0
            },
        },
    }
}
