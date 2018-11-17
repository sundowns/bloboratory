AudioController = Class {
    init = function(self)
        self.music = ripple.newSound {
            source = assets.audio.music.doom,
            volume = 0.375,
        }
        self.music:setLooping(true)
        self.music:play()
        self.tracklists = { 
            ["PLACE_STRUCTURE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.placing1,
                    volume = 0.5
                },
                ripple.newSound {
                    source = assets.audio.structures.placing2,
                    volume = 0.5
                }
            }),
            ["REFUND"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.refund1,
                    volume = 3
                },
                ripple.newSound {
                    source = assets.audio.structures.refund2,
                    volume = 3
                }
            }),
            ["ENEMY_HIT"] = TrackList({
                ripple.newSound {
                    source = assets.audio.enemies.blobHit1,
                    volume = 0.8
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit2,
                    volume = 1
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit3,
                    volume = 0.8
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit4,
                    volume = 1 
                },
            }),
            ["ENEMY_DEATH"] = TrackList({
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath1,
                    volume = 0.8
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath2,
                    volume = 0.3
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath3,
                    volume = 1.8
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath4,
                    volume = 1.3
                },
                
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
