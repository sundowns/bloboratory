UiController = Class {
    init = function(self)
        self.resizeTriggered = true
        self.firstRun = true
        self.options = Options()
        self.tray = Tray()
        self.picker = Picker()
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
        nk.frameBegin()
            if nk.windowBegin('Wallet', constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight) then

                self:handleResize(constants.UI.WALLET.X*windowWidth, constants.UI.WALLET.Y*windowHeight, constants.UI.WALLET.WIDTH*windowWidth, constants.UI.WALLET.HEIGHT*windowHeight)
            
                local width, height = nk.windowGetSize()
                nk.layoutRowBegin('dynamic', height*0.6, playerController.wallet.totalCurrencies)
                for key, currency in pairs(playerController.wallet.currencies) do
                    nk.layoutRowPush(1/playerController.wallet.totalCurrencies)
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
        if playerController.currentSelectedStructure then
            playerController.currentSelectedStructure:doThing(Vector(constants.UI.STATS.IMG_X*love.graphics.getWidth(), constants.UI.STATS.IMG_Y*love.graphics.getHeight()))
        end
    end;
}