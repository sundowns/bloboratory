function love.conf(t)
    t.console = true
    t.window.title = "Grim Gamers"
    t.window.minwidth = 1280
    t.window.minheight = 960
    t.window.resizable = true
    t.window.fullscreentype = "desktop" 

    t.modules.joystick = false           -- Enable the joystick module (boolean)
    t.modules.thread = false             -- Enable the thread module (boolean)
    t.modules.touch = false              -- Enable the touch module (boolean)
    t.modules.video = false              -- Enable the video module (boolean)
end
