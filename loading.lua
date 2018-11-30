loading = {}
local splashDisplaying = false
local splashScreen = nil
local MINIMUM_LOAD_TIME = 0.1
local loadTimer = 0

function loading:init()
    splashScreen = love.graphics.newImage('asset/splashscreen.png')
end

function loading:enter(previous, task, data)
end

function loading:leave()

end

function loading:update(dt)
    if splashDisplaying and loadTimer > MINIMUM_LOAD_TIME then
        loadGame()
    end

    splashDisplaying = true
    loadTimer = loadTimer + dt
end

function loading:draw()
    love.graphics.draw(splashScreen, 0, 0, 0, love.graphics:getWidth()/splashScreen:getWidth(), love.graphics.getHeight()/splashScreen:getHeight())
end

function loadGame()
    assets = require('lib.cargo').init('asset')
    serialize = require("lib.serialize")
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
    require("src.controller.config")
    require("src.controller.help")
    require("src.class.cell")
    require("src.class.grid")
    require("src.class.structureblueprint")
    require("src.class.floatingtext")
    require("src.class.hitbox")
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
    -- TODO: require entire directories instead (ceebs)
    require("src.structure.obstacle")
    require("src.structure.cannon") 
    require("src.structure.saw") 
    require("src.structure.lasergun")
    require("src.structure.beacon")
    require("src.structure.bouncer")
    require("src.enemy.blob")
    require("src.enemy.blob-large")
    require("src.enemy.blob-fire")
    require("src.enemy.blob-fire-large")
    require("src.enemy.blob-ice")
    require("src.enemy.blob-ice-large")
    require("src.enemy.blob-electric")
    require("src.enemy.blob-electric-large")
    require("src.enemy.blob-skull")
    require("src.enemy.blob-skull-dark")
    require("src.enemy.blob-teeth")
    require("src.enemy.blob-teeth-dark")
    require("src.enemy.blob-eye")
    require("src.class.enemyblueprint")
    require("src.ui.crucible")
    require("src.ui.overhead")

    GamestateManager.switch(game)
end;
