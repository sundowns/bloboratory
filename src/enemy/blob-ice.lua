BlobIce = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "BLOB-ICE", worldOrigin, constants.ENEMY.BLOBICE.HEALTH, constants.ENEMY.BLOBICE.SPEED, constants.ENEMY.BLOBICE.YIELD, animationController:createInstance("BLOB-ICE"))
        self.onHit = ripple.newSound{
            source = assets.audio.enemies.blobHitIce,
        }
        self.deathSound = ripple.newSound{
            source = assets.audio.enemies.blobDeathIce,
            volume = 2
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