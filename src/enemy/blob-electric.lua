BlobElectric = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ELECTRIC", worldOrigin, constants.ENEMY.BLOB.HEALTH, constants.ENEMY.BLOB.SPEED, constants.ENEMY.BLOB.YIELD, animationController:createInstance("BLOB-ELECTRIC"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobHit.wav', 'stream')
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