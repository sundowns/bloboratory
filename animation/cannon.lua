assert(assets.towers.cannon)
assert(anim8)

return {
    id = "CANNON",
    image = assets.towers.cannon,
    grid = anim8.newGrid(32, 32, assets.towers.cannon:getWidth(), assets.towers.cannon:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    animations = {
        DEFAULT = {
            frame_duration = 0.05,
            x = 1,
            y = 1
        }
    }
}
