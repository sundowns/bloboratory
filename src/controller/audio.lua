AudioController = Class {
    init = function(self)
        self.music_multiplier = 1
        self.sfx_multiplier = 1
        self.musicList = {
            ripple.newSound {
                source = assets.audio.music.doom2,
                volume = constants.MUSIC[ROUND],
            },
            ripple.newSound {
                source = assets.audio.music.music3,
                volume = constants.MUSIC[BUILD],
            },
        }
        self.musicList[1]:setLooping(true)
        self.musicList[2]:setLooping(true)
        self.music = self.musicList[2]
        self.music:play()
        self.tracklists = { 
            ["PLACE_STRUCTURE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.placing1,
                    volume = constants.AUDIO.PLACE_STRUCTURE[1]
                },
                ripple.newSound {
                    source = assets.audio.structures.placing2,
                    volume = constants.AUDIO.PLACE_STRUCTURE[2]
                },
                ripple.newSound {
                    source = assets.audio.structures.placing3,
                    volume = constants.AUDIO.PLACE_STRUCTURE[3]
                }
            }),
            ["REFUND"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.refund1,
                    volume = constants.AUDIO.REFUND[1]
                },
                ripple.newSound {
                    source = assets.audio.structures.refund2,
                    volume = constants.AUDIO.REFUND[2]
                }
            }),
            ["ENEMY_HIT"] = TrackList({
                ripple.newSound {
                    source = assets.audio.enemies.blobHit1,
                    volume = constants.AUDIO.ENEMY_HIT[1]
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit2,
                    volume = constants.AUDIO.ENEMY_HIT[2]
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit3,
                    volume = constants.AUDIO.ENEMY_HIT[3]
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobHit4,
                    volume = constants.AUDIO.ENEMY_HIT[4]
                },
            }),
            ["ENEMY_DEATH"] = TrackList({
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath1,
                    volume = constants.AUDIO.ENEMY_DEATH[1],
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath2,
                    volume = constants.AUDIO.ENEMY_DEATH[2],
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath3,
                    volume = constants.AUDIO.ENEMY_DEATH[3],
                },
                ripple.newSound {
                    source = assets.audio.enemies.blobDeath4,
                    volume = constants.AUDIO.ENEMY_DEATH[4],
                }, 
            }),
            ["ENEMY_LEAK"] = TrackList({
                ripple.newSound {
                    source = assets.audio.enemies.leak1,
                    volume = constants.AUDIO.ENEMY_LEAK[1],
                },
                ripple.newSound {
                    source = assets.audio.enemies.leak2,
                    volume = constants.AUDIO.ENEMY_LEAK[2],
                },
                ripple.newSound {
                    source = assets.audio.enemies.leak3,
                    volume = constants.AUDIO.ENEMY_LEAK[3],
                },
                ripple.newSound {
                    source = assets.audio.enemies.leak4,
                    volume = constants.AUDIO.ENEMY_LEAK[4],
                }, 
            }),
            ["START_ROUND"] = TrackList({
                ripple.newSound {
                    source = assets.audio.misc.roundStart,
                    volume = constants.AUDIO.START_ROUND[1], 
                },
            }),
            ["WINNER"] = TrackList({
                ripple.newSound {
                    source = assets.audio.misc.winner,
                    volume = constants.AUDIO.WINNER[1],
                },
            }),
            ["YOULOSE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.misc.youlose,
                    volume = constants.AUDIO.YOULOSE.VOLUME,
                    constant = constants.AUDIO.YOULOSE[1]
                },
            }),
            ["UPGRADE_FIRE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.upgradeFire,
                    volume = constants.AUDIO.UPGRADE_FIRE[1],
                },
            }),
            ["UPGRADE_ICE"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.upgradeIce,
                    volume = constants.AUDIO.UPGRADE_ICE[1], 
                },
            }),
            ["UPGRADE_ELECTRIC"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.upgradeElectric,
                    volume = constants.AUDIO.UPGRADE_ELECTRIC[1],
                },
            }),
            ["INSUFFICIENT_FUNDS"] = TrackList({
                ripple.newSound {
                    source = assets.audio.misc.insufficientFunds,
                    volume = constants.AUDIO.INSUFFICIENT_FUNDS[1],
                },
            }),
            ["CANNON_SHOOT"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.cannonShoot,
                    volume = constants.AUDIO.CANNON_SHOOT[1],
                },
            }),
            ["LASERGUN_SHOOT"] = TrackList({
                ripple.newSound {
                    source = assets.audio.structures.lasergunShoot,
                    volume = constants.AUDIO.LASERGUN_SHOOT[1],
                },
            })
        }
    end;
    stopMusic = function(self)
        self.music:stop()
    end;
    playNext = function(self, tracklistId)
        assert(self.tracklists[tracklistId], "[ERROR] Attempted to playNext from non-existent tracklist: " .. tracklistId)
        self.tracklists[tracklistId]:playNext()
    end;
    playAny = function(self, tracklistId)
        assert(self.tracklists[tracklistId], "[ERROR] Attempted to playAny from non-existent tracklist: " .. tracklistId)
        self.tracklists[tracklistId]:playAny()
    end;
    updateMusicVolume = function(self)
        for i, track in pairs(self.musicList) do 
            track.volume = (constants.MUSIC[i] * self.music_multiplier)
            print(self.music_multiplier .. ", " ..track.volume)
        end
    end;
    updateSfxVolume = function(self)
        for i, tracklist in pairs(self.tracklists) do 
            for j, item in pairs(tracklist.tracks) do 
                item.volume = (constants.AUDIO[i][j] * self.sfx_multiplier)
            end
        end
    end;
    toggleRoundMusic = function(self)
        self:stopMusic()
        if roundController:isBuildPhase() then 
            self.music = self.musicList.BUILD
            self.music:play()
        else 
            self.music = self.musicList.ROUND
            self.music:play()
        end
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
        self.tracks[love.math.random(1, #self.tracks)]:play()
    end;
}
