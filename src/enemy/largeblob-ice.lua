LargeBlobIce = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEBLOB-ICE", worldOrigin, constants.ENEMY.LARGEBLOBICE.HEALTH, constants.ENEMY.LARGEBLOBICE.SPEED, constants.ENEMY.LARGEBLOBICE.YIELD, animationController:createInstance("LARGEBLOB-ICE"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/largeBlobHit.wav', 'static')
        }
        self.deathSound = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobDeathIce.wav', 'static'),
            volume = 2
        }
    end;
    update = function(self, dt, currentCell)
        local destroy =  Enemy.update(self, dt, currentCell)
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}