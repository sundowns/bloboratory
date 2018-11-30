assert(assets.projectiles.bouncerprojectile)
assert(anim8)

return {
    id = "BOUNCERPROJECTILE",
    image = assets.projectiles.bouncerprojectile,
    grid = anim8.newGrid(8, 8, assets.projectiles.bouncerprojectile:getWidth(), assets.projectiles.bouncerprojectile:getHeight()),
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
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = true,
                rotation = 0
            },
        },
    }
}
