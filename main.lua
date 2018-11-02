love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/;")
debug = false

local world = {}
local cam = {}

function love.load()
    Class = require("lib.class")
    Vector = require("lib.vector")
    Camera = require("lib.camera")
    Util = require("lib.util")
    constants = require("constants")
    require("class.cell")
    require("class.world")

    cam = Camera(0,0)
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS)
    -- Util.t.print(world)
end

function love.update(dt)
    world:update(dt)

    -- cam movement logic
    if love.keyboard.isDown('left', 'a') then
        cam:move(-dt*constants.CAMERA_SPEED, 0)
    end
    if love.keyboard.isDown('right', 'd') then
        cam:move(dt*constants.CAMERA_SPEED, 0)
    end
    if love.keyboard.isDown('up', 'w') then
        cam:move(0, -dt*constants.CAMERA_SPEED)
    end
    if love.keyboard.isDown('down', 's') then
        cam:move(0, dt*constants.CAMERA_SPEED)
    end
end

function love.draw()
    cam:attach()
        world:draw()
    cam:detach()
end

function love.keypressed(key)
    if key == "f1" then
        debug = not debug
    elseif key == "escape" then
        love.event.quit()
    elseif key == "space" then
        love.event.quit("restart")
    end
end
