UiController = Class {
    init = function(self)
    end;
    update = function(self, dt)
        nk.frameBegin()
            if not world.currentRound.hasStarted then 
                if nk.windowBegin('Start', constants.UI.START_WAVE.X_OFFSET, constants.UI.START_WAVE.Y_OFFSET, constants.UI.START_WAVE.WIDTH, constants.UI.START_WAVE.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Start Wave') then 
                        world:startRound()
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Saw', constants.UI.SAW_BOX.X_OFFSET, constants.UI.SAW_BOX.Y_OFFSET, constants.UI.SAW_BOX.WIDTH, constants.UI.SAW_BOX.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Saw') then 
                        playerController:setCurrentBlueprint(2)
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Cannon', constants.UI.CANNON_BOX.X_OFFSET, constants.UI.CANNON_BOX.Y_OFFSET, constants.UI.CANNON_BOX.WIDTH, constants.UI.CANNON_BOX.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Cannon') then 
                        playerController:setCurrentBlueprint(3)
                    end
                end
                nk.windowEnd()
            end
        nk.frameEnd()
    end;

    draw = function(self)
        nk.draw()
        love.graphics.setColor(constants.COLOURS.DEBUG_PRINT)
        love.graphics.print("CURRENT MARKET VALUE: " .. playerController.money, constants.UI.CURRENCY_COUNTER.X_OFFSET, constants.UI.CURRENCY_COUNTER.Y_OFFSET)
    end;
}