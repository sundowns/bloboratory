BlobElectric = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ELECTRIC", worldOrigin, constants.ENEMY.BLOBELECTRIC.HEALTH, constants.ENEMY.BLOBELECTRIC.SPEED, constants.ENEMY.BLOBELECTRIC.YIELD, animationController:createInstance("BLOB-ELECTRIC"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobHit.wav', 'static'),
            volume = 0.8
        }
        self.deathSound = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobDeathElec.wav', 'static'),
            volume = 0.6
        }
    end;
    update = function(self, dt, currentCell)
        local destroy = Enemy.update(self, dt, currentCell)
        return destroy
    end;
    draw = function(self)
        Enemy.draw(self)
    end;
    calculateHitbox = function(self)
        return Enemy.calculateHitbox(self)
    end;
}