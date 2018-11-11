LargeBlob = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEBLOB", worldOrigin, constants.ENEMY.LARGEBLOB.HEALTH, constants.ENEMY.LARGEBLOB.SPEED, constants.ENEMY.LARGEBLOB.YIELD, animationController:createInstance("LARGEBLOB"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/largeBlobHit.wav', 'stream')
        }
        self.deathSound = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobDeathLarge.wav', 'stream')
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