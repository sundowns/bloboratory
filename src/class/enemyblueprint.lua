EnemyBlueprint = Class {
    init = function(self, name, image, yield, buildEnemy)
        self.name = name
        self.image = image --TODO: create hovered/active versions of the images
        self.yield = yield
        self.yieldText = self:stringifyYieldTable(self.yield)
        self.buildEnemy = buildEnemy
    end;
    construct = function(self, params, healthMultiplier)
        local enemy = self.buildEnemy(params)
        assert(enemy)
        -- enemy:scaleHealth(healthMultiplier)
        return enemy
    end;
    stringifyYieldTable = function(self, yieldTable)
        
    end;
    draw = function(self, origin)
        love.graphics.draw(self.image, origin.x, origin.y)
    end;
}