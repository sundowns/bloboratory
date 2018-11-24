assert(assets.structures.lasergun)
assert(anim8)

return {
    id = "LASERGUN",
    image = assets.structures.lasergun,
    grid = anim8.newGrid(32, 32, assets.structures.lasergun:getWidth(), assets.structures.lasergun:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.07,
                x = 1,
                y = 1,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0
            }
        }
    }
}
