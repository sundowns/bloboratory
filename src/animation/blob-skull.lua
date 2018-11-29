assert(assets.enemies.blob)
assert(anim8)

return {
    id = "BLOB-SKULL",
    image = assets.enemies.blob,
    grid = anim8.newGrid(16, 16, assets.enemies.blob:getWidth(), assets.enemies.blob:getHeight()),
    animation_names = {
        "DEFAULT"
    },
    layers = {
        {
            DEFAULT = {
                frame_duration = 0.1,
                x = '1-4',
                y = 5,
                offset_x = 0,
                offset_y = 0,
                scale_x = 2.2,
                scale_y = 2.2,
                rotation = 0
            }
        }
    }
}
