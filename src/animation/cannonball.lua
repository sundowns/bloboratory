assert(assets.projectiles.cannonball)
assert(anim8)

return {
    id = "CANNONBALL",
    image = assets.projectiles.cannonball,
    grid = anim8.newGrid(8, 8, assets.projectiles.cannonball:getWidth(), assets.projectiles.cannonball:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 1000,
                x = 1,
                y = 4,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
        },
    }
}
