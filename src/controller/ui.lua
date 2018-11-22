UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.firstRun = true
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
            if nk.windowBegin('Wallet', constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight) then
                self:handleResize(constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight)
            
                local width, height = nk.windowGetSize()
                nk.layoutRowBegin('dynamic', height*0.6, playerController.wallet.totalCurrencies*2)
                for key, currency in pairs(playerController.wallet.currencies) do
                    nk.layoutRowPush(0.3/playerController.wallet.totalCurrencies)
                    nk.image(currency.image)
                    nk.layoutRowPush(0.7/playerController.wallet.totalCurrencies)
                    nk.label(currency.value, 'centered', nk.colorRGBA(currency:colourRGB()))
                end
                nk.layoutRowEnd()
            end
            nk.windowEnd()

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
        if playerController.hasWon then
            love.graphics.draw(self.victoryText, love.graphics.getWidth()/2 - self.victoryText:getWidth()/2, love.graphics.getHeight()/2)
        elseif playerController.hasLost then
            love.graphics.draw(self.defeatText, love.graphics.getWidth()/2 - self.defeatText:getWidth()/2, love.graphics.getHeight()/2)
        end
    end;
}