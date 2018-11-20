love.filesystem.setRequirePath(love.filesystem.getRequirePath()..";lib/?.lua;lib/")
love.filesystem.setCRequirePath(love.filesystem.getCRequirePath()..";lib/?.dll;lib/?/?.dll;lib/?/?.so")

-- Globals (yikes)
debug = false
cameraController = {}
inputController = {}
uiController = {}
animationController = {}
roundController = {}
audioController = {}
world = {}

local paused = false

function love.load()
    assets = require('lib.cargo').init('asset')
    Class = require("lib.class")
    nk = require("nuklear")
    Vector = require("lib.vector")
    Timer = require("lib.timer")
    Util = require("lib.util")
    bump = require("lib.bump")
    anim8 = require("lib.anim8")
    ripple = require("lib.ripple")
    constants = require("src.constants")
    require("src.ui.crucible")
    require("src.ui.options")
    require("src.ui.tray")
    require("src.controller.animation")
    require("src.controller.camera")
    require("src.controller.input")
    require('src.controller.round')
    require("src.controller.player")
    require("src.controller.ui")
    require("src.controller.audio")
    require("src.class.cell")
    require("src.class.grid")
    require("src.class.structureblueprint")
    require("src.class.floatingtext")
    require("src.class.projectile")
    require("src.class.impact")
    require("src.class.structure")
    require("src.class.tower")
    require("src.class.debuff")
    require("src.class.mutation")
    require("src.class.enemy")
    require("src.class.round")
    require("src.class.world")
    require("src.class.crucible")
    -- TODO: require entire directories instead
    require("src.structure.obstacle")
    require("src.structure.cannon") 
    require("src.structure.saw") 
    require("src.enemy.blob")
    require("src.enemy.blob-fire")
    require("src.enemy.blob-ice")
    require("src.enemy.blob-electric")
    require("src.class.enemyblueprint")
    require("src.ui.crucible")
    
    love.graphics.setDefaultFilter('nearest')
    love.keyboard.setKeyRepeat(true) -- For nuklear
    nk.init()
    uiController = UiController()
    audioController = AudioController()
    inputController = InputController()
    playerController = PlayerController()
    animationController = AnimationController()
    roundController = RoundController()
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS)
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.ROWS/1.7*constants.GRID.CELL_SIZE))
end

function love.update(dt)
    if not paused then
        world:update(dt)
        Timer.update(dt) --the global version is used mostly for tweening/small use-cases
        uiController:update(dt)
        inputController:update(dt)
        cameraController:update(dt)
        playerController:update(dt)
    end
end

function love.draw()
    Util.l.resetColour()
    cameraController:attach()
        world:draw()
        playerController:draw()
    cameraController:detach()

    uiController:draw()

    if debug then
        cameraController:draw()
        inputController:draw()
        Util.l.resetColour()
        Util.l.renderStats()
    end
    if paused then
        love.graphics.setColor(1,0,0)
        love.graphics.print("PAUSED", 0, 0)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then
        debug = not debug
    elseif key == "f5" then
        love.event.quit("restart")
    elseif key == "space" then
        paused = not paused
    elseif key == "return" and love.keyboard.isDown("lalt", "ralt") then
        love.window.setFullscreen(not love.window.getFullscreen())
    end

    inputController:keypressed(key)
    nk.keypressed(key, scancode, isrepeat)
end

function love.resize(w, h)
    uiController:triggerResize()
end

function love.keyreleased(key, scancode)
    nk.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    nk.mousepressed(x, y, button, istouch)
    inputController:mousepressed(Vector(x, y), button)
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

