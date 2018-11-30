function love.load()
    GamestateManager = require("lib.gamestate")
    require("loading")
    require("game")
    love.window.setIcon(love.image.newImageData('asset/blueprints/beacon.png'))
    GamestateManager.registerEvents()
    GamestateManager.switch(loading)
end

function love.update(dt)
end

function love.draw()
end