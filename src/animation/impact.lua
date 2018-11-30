assert(assets.particles.impact)
assert(anim8)

return {
    id = "IMPACT",
    image = assets.particles.impact,
    grid = anim8.newGrid(32, 32, assets.particles.impact:getWidth(), assets.particles.impact:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.12,
                x = '1-3',
                y = 2,
                offset_x = 0,
                offset_y = 0,
                scale_x = 1,
                scale_y = 1,
                rotation = 0
            }
        }
    }
}
