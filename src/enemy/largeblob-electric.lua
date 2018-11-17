LargeBlobElectric = Class {
    __includes = Enemy,
    init = function(self, worldOrigin)
        Enemy.init(self, "LARGEBLOB-ELECTRIC", worldOrigin, constants.ENEMY.LARGEBLOBELECTRIC.HEALTH, constants.ENEMY.LARGEBLOBELECTRIC.SPEED, constants.ENEMY.LARGEBLOBELECTRIC.YIELD, animationController:createInstance("LARGEBLOB-ELECTRIC"))
        self.onHit = ripple.newSound{
            source = assets.audio.enemies.largeBlobHit,
        }
        self.deathSound = ripple.newSound{
            source = assets.audio.enemies.blobDeathElec,
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