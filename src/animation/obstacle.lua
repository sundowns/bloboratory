assert(assets.structures.obstacle)
assert(anim8)

return {
    id = "OBSTACLE",
    image = assets.structures.obstacle,
    grid = anim8.newGrid(16, 16, assets.structures.obstacle:getWidth(), assets.structures.obstacle:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 1000,
                x = 1,
                y = 1,
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
