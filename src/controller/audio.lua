AudioController = Class {
    init = function(self)
        -- self.music = ripple.newSound {
        --     source = assets.music.music1,
        --     volume = 0.4,
        -- }
        self.music = assets.music.music1
        self.music:setLooping(true)
        self.music:play()
    end;
    update = function(self, dt)
    end;
}