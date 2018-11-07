assert(assets.towers.saw)
assert(anim8)

return {
    id = "SAW-FIRE",
    image = assets.towers.saw,
    grid = anim8.newGrid(32, 32, assets.towers.saw:getWidth(), assets.towers.saw:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    animations = {
        DEFAULT = {
            frame_duration = 0.05,
            x = '1-3',
            y = 2
        }
    }
}
