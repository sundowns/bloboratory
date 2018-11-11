love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/")
love.filesystem.setCRequirePath(love.filesystem.getRequirePath()..";lib/?.dll;lib/?/?.dll")

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
    nk = require("nuklear")
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
    require("src.class.debuff")
    require("src.class.mutation")
    require("src.class.enemy")
    require("src.class.round")
    require("src.class.world")
    -- TODO: require entire directories instead
    require("src.structure.obstacle")
    require("src.structure.cannon") 
    require("src.structure.saw") 
    require("src.enemy.blob")
    require("src.enemy.blob-fire")
    require("src.enemy.blob-ice")
    require("src.enemy.blob-electric")
    require("src.enemy.largeblob")
    require("src.enemy.largeblob-fire")
    require("src.enemy.largeblob-ice")
    require("src.enemy.largeblob-electric")
    
    love.graphics.setDefaultFilter('nearest')
    love.keyboard.setKeyRepeat(true) -- For nuklear
    nk.init()
    uiController = UiController()
    inputController = InputController()
    playerController = PlayerController()
    animationController = AnimationController()
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS, require("src.rounds"))
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.ROWS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE))
end

function love.update(dt)
    world:update(dt)
    Timer.update(dt) --the global version is used mostly for tweening/small use-cases
    uiController.update(dt)
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

function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        debug = not debug
    elseif key == "f5" then
        love.event.quit("restart")
    end

    inputController:keypressed(key)
    nk.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    nk.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    inputController:mousepressed(x, y, button)
    nk.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
    nk.mousereleased(x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy, istouch)
    nk.mousemoved(x, y, dx, dy, istouch)
end

function love.textinput(text)
    nk.textinput(text)
end

function love.wheelmoved(x, y)
    nk.wheelmoved(x, y)
end

