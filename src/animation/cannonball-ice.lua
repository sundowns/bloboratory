assert(assets.projectiles.cannonball)
assert(anim8)

return {
    id = "CANNONBALL-ICE",
    image = assets.projectiles.cannonball,
    grid = anim8.newGrid(8, 8, assets.projectiles.cannonball:getWidth(), assets.projectiles.cannonball:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.05,
                x = '1-3',
                y = 2,
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
