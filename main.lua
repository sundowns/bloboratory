love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/;")
debug = false

local world = {}
local cameraController = {}

function love.load()
    Class = require("lib.class")
    Vector = require("lib.vector")

    Util = require("lib.util")
    constants = require("constants")
    require("controller.camera")
    require("class.cell")
    require("class.world")

    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS)
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.ROWS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE))
end

function love.update(dt)
    world:update(dt)

    cameraController:update(dt)
end

function love.draw()
    cameraController:attach()
        world:draw()
    cameraController:detach()
end

function love.keypressed(key)
    if key == "f1" then
        debug = not debug
    elseif key == "escape" then
        love.event.quit()
    elseif key == "space" then
        love.event.quit("restart")
    end

    world:keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    local world_x, world_y = cameraController:getWorldCoordinates(x, y)
    world:mousepressed(world_x, world_y, button)
end