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
    constants = require("src.constants")
    bump = require("lib.bump")
    anim8 = require("lib.anim8")
    require("src.controller.animation")
    require("src.controller.camera")
    require("src.controller.input")
    require("src.class.blueprint")
    require("src.controller.player")
    require("src.controller.ui")
    require("src.class.cell")
    require("src.class.grid")
    require("src.class.floatingtext")
    require("src.class.projectile")
    require("src.class.structure")
    require("src.class.tower")
    require("src.class.mutation")
    require("src.class.enemy")
    require("src.class.round")
    require("src.class.world")
    require("src.structure.obstacle")
    require("src.structure.cannon") 
    require("src.structure.saw") 
    require("src.enemy.smallguy")
    require("src.enemy.largeguy")
    
    love.graphics.setDefaultFilter('nearest')
    uiController = UiController()
    inputController = InputController()
    playerController = PlayerController()
    animationController = AnimationController()
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS, require("src.rounds"))
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.ROWS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE))
end

function love.update(dt)
    world:update(dt)

    inputController:update(dt)
    cameraController:update(dt)
end

function love.draw()
    cameraController:attach()
        world:draw()
    cameraController:detach()

    uiController:draw()

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