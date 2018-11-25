UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.firstRun = true
        self.overhead = Overhead()
        self.options = Options()
        self.tray = Tray({
            FIRE = self:constructHotkeyedImage(assets.ui.iconFire, 'F'),
            ICE = self:constructHotkeyedImage(assets.ui.iconIce, 'I'),
            ELECTRIC = self:constructHotkeyedImage(assets.ui.iconElectric, 'E'),
            REFUND = self:constructHotkeyedImage(assets.ui.refund, 'X'),
            ROTATE = self:constructHotkeyedImage(assets.ui.iconScrap, 'R'),
        })
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
    constructHotkeyedImage = function(self, image, key)
        local w, h = image:getWidth(), image:getHeight()
        local canvas = love.graphics.newCanvas(512,512)
        love.graphics.setCanvas(canvas)
            love.graphics.draw(image, 0, 0, 0, canvas:getWidth()/w, canvas:getHeight()/h)
            love.graphics.setColor(0,0,0,0.75)
            love.graphics.rectangle('fill', canvas:getWidth()/2, canvas:getHeight()/2, canvas:getWidth()/2, canvas:getHeight()/2)
            Util.l.resetColour()
            local text = love.graphics.newText(assets.ui.planerRegular(56), { {0.2,1,0}, key})
            love.graphics.draw(text, canvas:getWidth()*3/4 - text:getWidth()*2, canvas:getHeight()/2 - 10, 0, 4, 4)
        love.graphics.setCanvas()
        return love.graphics.newImage(canvas:newImageData())
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
        if self.options.markedForRestart then
            love.event.quit("restart")
        end
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