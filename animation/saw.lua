assert(assets.towers.saw)
assert(anim8)

return {
    id = "SAW",
    image = assets.towers.saw,
    grid = anim8.newGrid(32, 32, assets.towers.saw:getWidth(), assets.towers.saw:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.05,
                x = '1-3',
                y = 1,
                offset_x = 0,
                offset_y = 0,
                rotate_to_target = false,
                rotation = 0
            }
        }
    }
}
