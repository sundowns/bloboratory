EnemyBlueprint = Class {
    init = function(self, name, image, yield, isBoss, buildEnemy)
        self.name = name
        self.image = image
        self.imageHovered = love.graphics.newCanvas(self.image:getWidth(), self.image:getHeight())
        self.imageActive = love.graphics.newCanvas(self.image:getWidth(), self.image:getHeight())

        Util.l.resetColour()
        love.graphics.setCanvas(self.imageHovered)
            love.graphics.setColor(0.8, 0.8, 0.8, 0.4)
            love.graphics.draw(self.image, 0, 0)
        love.graphics.setCanvas()
        self.imageHovered = love.graphics.newImage(self.imageHovered:newImageData())

        Util.l.resetColour()
        love.graphics.setCanvas(self.imageActive)
            love.graphics.setColor(0.5, 1, 0, 0.7)
            love.graphics.draw(self.image, 0, 0)
        love.graphics.setCanvas()
        self.imageActive = love.graphics.newImage(self.imageActive:newImageData())

        self.yield = yield
        self.buildEnemy = buildEnemy
        self.isBoss = isBoss
    end;
    construct = function(self, params, healthMultiplier)
        local enemy = self.buildEnemy(params)
        assert(enemy)
        enemy:scaleHealth(healthMultiplier)
        return enemy
    end;
    draw = function(self, origin)
        love.graphics.draw(self.image, origin.x, origin.y)
    end;
}