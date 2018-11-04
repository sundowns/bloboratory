love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/;")

-- Globals (yikes)
debug = false
cameraController = {}
inputController = {}
world = {}

function love.load()
    assets = require('lib.cargo').init('asset')
    Class = require("lib.class")
    Vector = require("lib.vector")
    Timer = require("lib.timer")
    Util = require("lib.util")
    constants = require("constants")
    bump = require("lib.bump")
    require("controller.camera")
    require("controller.input")
    require("class.cell")
    require("class.grid")
    require("class.tower")
    require("class.enemy")
    require("class.round")
    require("class.world")
    require("towers.spudgun") 
    require("towers.saw") 
    require("enemies.smallguy")
    require("enemies.largeguy")
    
    love.graphics.setDefaultFilter('nearest')
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS, require("rounds"))
    inputController = InputController()
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.ROWS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE))
end

function love.update(dt)
    world:update(dt, isPlacingTower)

    inputController:update(dt)
    cameraController:update(dt)
end

function love.draw()
    cameraController:attach()
        world:draw()
    cameraController:detach()

    if debug then
        cameraController:draw()
        Util.l.resetColour()
        Util.l.renderStats()
    end
end

function love.keypressed(key)
    if key == "f1" then
        debug = not debug
    elseif key == "escape" then
        love.event.quit()
    elseif key == "f5" then
        love.event.quit("restart")
    end

    inputController:keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
    inputController:mousepressed(x, y, button)
end