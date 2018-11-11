LargeBlobElectric = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEBLOB-ELECTRIC", worldOrigin, constants.ENEMY.LARGEBLOB.HEALTH, constants.ENEMY.LARGEBLOB.SPEED, constants.ENEMY.LARGEBLOB.YIELD, animationController:createInstance("LARGEBLOB-ELECTRIC"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/largeBlobHit.wav', 'static')
        }
        self.deathSound = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobDeathElec.wav', 'static'),
            volume = 0.6
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