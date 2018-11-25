game = {}

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
configController = {}
world = {}
TOWER_STATS = {}

local paused = false

function game:init()
    love.graphics.setFont(assets.ui.neuropoliticalRg(12))
    love.graphics.setDefaultFilter('nearest')
    love.keyboard.setKeyRepeat(true) -- For nuklear

    nk.init()
    TOWER_STATS = require("src.tower-stats")
    configController = ConfigController()
    configController:fetchUserSettings()
    uiController = UiController()
    audioController = AudioController(settings)
    inputController = InputController()
    playerController = PlayerController()
    animationController = AnimationController()
    roundController = RoundController()
    world = World(Vector(0,0), constants.GRID.ROWS, constants.GRID.COLUMNS)
    cameraController = CameraController(Vector(world.origin.x + constants.GRID.COLUMNS/2*constants.GRID.CELL_SIZE, world.origin.y + constants.GRID.ROWS/1.5*constants.GRID.CELL_SIZE))
end

function game:update(dt)
    if not paused then
        world:update(dt)
        Timer.update(dt) --the global version is used mostly for tweening/small use-cases

        if not playerController.hasWon and not playerController.hasLost then
            uiController:update(dt)
            roundController:update(dt)
            inputController:update(dt)
            cameraController:update(dt)
        end
        playerController:update(dt)
    end
end

function game:draw()
    Util.l.resetColour()
    cameraController:attach()
        world:draw()
        playerController:draw()
    cameraController:detach()

    uiController:draw()

    if debug then
        inputController:draw()
        Util.l.resetColour()
        Util.l.renderStats()
    end
    if paused then
        love.graphics.setColor(1,0,0)
        love.graphics.print("PAUSED", 0, 0)
    end
end

function game:keypressed(key, scancode, isrepeat)
    if key == "f1" then
        debug = not debug
    elseif key == "f5" then
        love.event.quit("restart")
    elseif key == "space" then
        paused = not paused
    end

    inputController:keypressed(key)
    nk.keypressed(key, scancode, isrepeat)
end

function game:resize(w, h)
    uiController:triggerResize()
end

function game:keyreleased(key, scancode)
    nk.keyreleased(key, scancode)
end

function game:mousepressed(x, y, button, istouch, presses)
    nk.mousepressed(x, y, button, istouch)
    inputController:mousepressed(Vector(x, y), button)
end

function game:mousereleased(x, y, button, istouch)
    nk.mousereleased(x, y, button, istouch)
end

function game:mousemoved(x, y, dx, dy, istouch)
    nk.mousemoved(x, y, dx, dy, istouch)
end

function game:textinput(text)
    nk.textinput(text)
end

function game:wheelmoved(x, y)
    nk.wheelmoved(x, y)
end
