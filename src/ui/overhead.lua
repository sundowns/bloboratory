Overhead = Class {
    init = function(self)      
        self.styles = {
            DEFAULT = {
                ['window'] = {
                    ['fixed background'] = assets.ui.menuRight,
                    ['padding'] = {x = 24, y = 10}
                },
                ['button'] = {
                    ['normal'] = assets.ui.button,
                    ['hover'] = assets.ui.buttonHovered,
                    ['active'] = assets.ui.button,
                    ['text background'] = constants.COLOURS.UI.NONE,
                    ['text normal'] = constants.COLOURS.UI.WHITE,
                    ['text hover'] = constants.COLOURS.UI.WHITE,
                }
            },
            ACTIVE = {
                ['button'] = {
                    ['normal'] = assets.ui.buttonDisabled,
                    ['hover'] = assets.ui.buttonDisabled,
                    ['active'] = assets.ui.buttonDisabled,
                }
            }
        }
    end; 
    draw = function(self)
        local count = 1
        for key, currency in pairs(playerController.wallet.currencies) do
            Util.l.resetColour()
            love.graphics.draw(currency.image, love.graphics.getWidth() - (2 * playerController.wallet.totalCurrencies) - (count * 90) - 50, love.graphics.getHeight()/50)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print(currency.value, love.graphics.getWidth() - (2 * playerController.wallet.totalCurrencies) - (count * 90) - 25, love.graphics.getHeight()/50)
            count = count + 1
        end
        love.graphics.setFont(assets.ui.neuropoliticalRg(12))
        love.graphics.print('Round: '.. roundController.roundIndex .. ' / ' .. roundController.totalRounds, love.graphics.getWidth()*0.35, love.graphics.getHeight()*0.02)
        love.graphics.print('Lives: '.. playerController.livesRemaining .. ' / ' .. constants.MISC.STARTING_LIVES, love.graphics.getWidth()*0.48, love.graphics.getHeight()*0.02)
    end;

    display = function(self, windowWidth, windowHeight)
        nk.stylePush(self.styles.DEFAULT)
        if nk.windowBegin('Overhead', constants.UI.OVERHEAD.X*windowWidth, constants.UI.OVERHEAD.Y*windowHeight, constants.UI.OVERHEAD.WIDTH*windowWidth, constants.UI.OVERHEAD.HEIGHT*windowHeight) then
            uiController:handleResize(constants.UI.OVERHEAD.X*windowWidth, constants.UI.OVERHEAD.Y*windowHeight, constants.UI.OVERHEAD.WIDTH*windowWidth, constants.UI.OVERHEAD.HEIGHT*windowHeight)
            nk.layoutRow('dynamic', (constants.UI.OVERHEAD.LAYOUTROW_HEIGHT*windowHeight), {0.1, 0.05, 0.05, 0.01, 0.05, 0.7})
            if nk.windowIsHovered() and not nk.widgetIsHovered() then 
                if not nk.windowHasFocus() then 
                    nk.windowSetFocus('Overhead')
                end
            end
            if nk.button("OPTIONS") then 
                audioController:playAny("BUTTON_PRESS")
                if not nk.windowIsHidden(constants.UI.OPTIONS_MENU.NAME) then
                    nk.windowHide(constants.UI.OPTIONS_MENU.NAME)
                else
                    nk.windowShow(constants.UI.OPTIONS_MENU.NAME)
                end
            end
            nk.spacing(1)
            if playerController:currentDilationIs("NORMAL") then
                nk.stylePush(self.styles.ACTIVE)
            end
            if nk.button("1x") then
                playerController:setTimeDilation("NORMAL")
            end 
            if playerController:currentDilationIs("NORMAL") then
                nk.stylePop()
            end

            nk.spacing(1)

            if playerController:currentDilationIs("FAST") then
                nk.stylePush(self.styles.ACTIVE)
            end
            if nk.button("2x") then 
                playerController:setTimeDilation("FAST")
            end 
            if playerController:currentDilationIs("FAST") then
                nk.stylePop()
            end
            
            nk.spacing(1)
        end
        nk.windowEnd()
        nk.stylePop()
    end;
}