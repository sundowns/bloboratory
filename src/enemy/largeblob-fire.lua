LargeBlobFire = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEBLOB-FIRE", worldOrigin, constants.ENEMY.LARGEBLOBFIRE.HEALTH, constants.ENEMY.LARGEBLOBFIRE.SPEED, constants.ENEMY.LARGEBLOBFIRE.YIELD, animationController:createInstance("LARGEBLOB-FIRE"))
        self.onHit = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobFireHit.wav', 'static')
        }
        self.deathSound = ripple.newSound{
            source = love.audio.newSource('asset/enemies/sound/blobDeath.wav', 'static')
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