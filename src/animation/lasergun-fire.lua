assert(assets.structures.lasergun)
assert(anim8)

return {
    id = "LASERGUN-FIRE",
    image = assets.structures.lasergun,
    grid = anim8.newGrid(32, 32, assets.structures.lasergun:getWidth(), assets.structures.lasergun:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 1000,
                x = 1,
                y = 2,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                manually_rotatable = false,
                rotation = 0
            }
        },
        {
            DEFAULT = {
                frame_duration = 1000,
                x = 2,
                y = 2,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                manually_rotatable = true,
                rotation = 0
            }
        }
    }
}
