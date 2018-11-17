assert(assets.terrain.goal)
assert(anim8)

return {
    id = "GOAL",
    image = assets.terrain.goal,
    grid = anim8.newGrid(16, 16, assets.terrain.goal:getWidth(), assets.terrain.goal:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.125,
                x = 1,
                y = 1,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2,
                scale_y = 2,
                rotate_to_target = false,
                rotation = 0
            },
        }
    }
}
