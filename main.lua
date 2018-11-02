love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/;")
debug = false

local world = {}

function love.load()
    Class = require("lib.class")
    Vector = require("lib.vector")
    Util = require("lib.util")
    constants = require("constants")
    require("class.cell")
    require("class.world")

    world = World(Vector(0,0), constants.ROWS, constants.COLUMNS)
    -- Util.t.print(world)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end

function love.keypressed(key)
    if key == "f1" then
        debug = not debug
    end
end
