AudioController = Class {
    init = function(self)
        self.music = ripple.newSound {
            source = assets.audio.music.music1,
            volume = 0.35,
        }
        self.music:setLooping(true)
        -- self.music:play()
        self.tracklists = { 
            ["PLACE_STRUCTURE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structure.placing1,
                    volume = 0.6
                },
                ripple.newSound {
                    source = assets.audio.structure.placing2,
                    volume = 0.6
                }
            }),
            ["REFUND"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structure.refund1,
                    volume = 1.2
                },
                ripple.newSound {
                    source = assets.audio.structure.refund2,
                    volume = 1.2
                }
            }),
        }
    end;
    playNext = function(self, tracklistId)
        assert(self.tracklists[tracklistId], "[ERROR] Attempted to playNext from non-existent tracklist: " .. tracklistId)
        self.tracklists[tracklistId]:playNext()
    end;
    playAny = function(self, tracklistId)
        assert(self.tracklists[tracklistId], "[ERROR] Attempted to playAny from non-existent tracklist: " .. tracklistId)
        self.tracklists[tracklistId]:playAny()
    end;
}

TrackList = Class {
    init = function(self, tracks)
        self.tracks = tracks
        self.trackIndex = 1
    end;
    playNext = function(self)
        self.tracks[self.trackIndex]:play()
        self.trackIndex = self.trackIndex + 1
        if self.trackIndex > #self.tracks then
            self.trackIndex = 1
        end
    end;
    playAny = function(self)
        print(#self.tracks)
        self.tracks[love.math.random(1, #self.tracks)]:play()
    end;
}
