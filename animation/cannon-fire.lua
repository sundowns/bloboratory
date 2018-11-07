assert(assets.towers['cannon-fire'])
assert(anim8)

return {
    id = "CANNON-FIRE",
    image = assets.towers['cannon-fire'],
    grid = anim8.newGrid(32, 32, assets.towers['cannon-fire']:getWidth(), assets.towers['cannon-fire']:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    animations = {
        DEFAULT = {
            frame_duration = 0.15,
            x = '1-3',
            y = 1
        }
    }
}
