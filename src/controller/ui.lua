UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.firstRun = true
        self.overhead = Overhead()
        self.options = Options()
        self.tray = Tray()
        self.picker = Picker()
        self.font = assets.ui.neuropoliticalRg(12)
        self.victoryText = love.graphics.newText(assets.ui.neuropoliticalRg(48), {{0,1,0}, "V I C T O R Y"})
        self.defeatText = love.graphics.newText(assets.ui.neuropoliticalRg(48), {{1,0,0}, "D E F E A T"})
    end;
    triggerResize = function(self)
        self.resizeTriggered = true
    end;
    handleResize = function(self, x, y, width, height)
        if self.resizeTriggered then
            nk.windowSetBounds(x, y, width, height)
        end
    end;
    update = function(self, dt)
        local windowWidth = love.graphics.getWidth()
        local windowHeight = love.graphics.getHeight()
        love.graphics.setFont(self.font)
        nk.frameBegin()
            self.overhead:display(windowWidth, windowHeight)
            self.options:display(windowWidth, windowHeight)
            self.tray:display(windowWidth,windowHeight)
            self.picker:display(windowWidth, windowHeight)

            if self.firstRun then
                self.firstRun = false
            end
        nk.frameEnd()
        self.resizeTriggered = false
    end;
    draw = function(self)
        Util.l.resetColour()
        nk.draw()
        Util.l.resetColour()
        self.overhead:draw()


        if playerController.hasWon then
            love.graphics.draw(self.victoryText, love.graphics.getWidth()/2 - self.victoryText:getWidth()/2, love.graphics.getHeight()/2)
        elseif playerController.hasLost then
            love.graphics.draw(self.defeatText, love.graphics.getWidth()/2 - self.defeatText:getWidth()/2, love.graphics.getHeight()/2)
        end
    end;
}