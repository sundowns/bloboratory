Overhead = Class {
    init = function(self)      
        self.style = {
                ['window'] = {
                    ['fixed background'] = assets.ui.menuRight,
                    ['padding'] = {x = 20, y = 20}
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.PANEL_TRANSPARENT_LIGHT,
                    ['text normal'] = constants.COLOURS.UI.BLACK,
                    ['text hovered'] = constants.COLOURS.UI.WHITE,
                    ['text active'] = constants.COLOURS.UI.BLACK,
                },
        }
    end; 

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.style)
        if nk.windowBegin('Overhead', constants.UI.OVERHEAD.X*windowWidth, constants.UI.OVERHEAD.Y*windowHeight, constants.UI.OVERHEAD.WIDTH*windowWidth, constants.UI.OVERHEAD.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.OVERHEAD.X*windowWidth, constants.UI.OVERHEAD.Y*windowHeight, constants.UI.OVERHEAD.WIDTH*windowWidth, constants.UI.OVERHEAD.HEIGHT*windowHeight)
            nk.layoutRowBegin('dynamic', constants.UI.OVERHEAD.LAYOUTROW_HEIGHT, (2 + playerController.wallet.totalCurrencies*2))
            nk.layoutRowPush(0.1)
            if nk.button("OPTIONS") then 
                nk.windowShow(constants.UI.OPTIONS_MENU.NAME)
            end 
            nk.layoutRowPush(0.6)
            nk.spacing(1)
            for key, currency in pairs(playerController.wallet.currencies) do
                nk.layoutRowPush(0.06/playerController.wallet.totalCurrencies)
                nk.image(currency.image)
                nk.layoutRowPush(0.14/playerController.wallet.totalCurrencies)
                nk.label(currency.value, 'centered', nk.colorRGBA(currency:colourRGB()))
            end
            nk.layoutRowEnd()
        end
        nk.windowEnd()
        nk.stylePop()
    end;
}