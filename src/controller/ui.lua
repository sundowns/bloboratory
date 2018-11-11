UiController = Class {
    init = function(self)
    end;
    update = function(self, dt)
        nk.frameBegin()
            if not world.currentRound.hasStarted then 
                if world.grid.validPath then
                    --TODO: show some sort of disabled/greyed out state instead of hiding it (when this is false)
                    if nk.windowBegin('Start', constants.UI.BUTTON.START_WAVE.X, constants.UI.BUTTON.START_WAVE.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                        nk.layoutRow('dynamic', 32, 1)
                        if nk.button('Start Wave') then 
                            world:startRound()
                        end
                    end
                    
                    nk.windowEnd()
                end

                if nk.windowBegin('Obstacle', constants.UI.BUTTON.OBSTACLE.X, constants.UI.BUTTON.OBSTACLE.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Obstacle') then 
                        playerController:setCurrentBlueprint(1)
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Saw', constants.UI.BUTTON.SAW.X, constants.UI.BUTTON.SAW.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
                    nk.layoutRow('dynamic', 32, 1)
                    if nk.button('Place Saw') then 
                        playerController:setCurrentBlueprint(2)
                    end
                end
                nk.windowEnd()
                if nk.windowBegin('Cannon', constants.UI.BUTTON.CANNON.X, constants.UI.BUTTON.CANNON.Y, constants.UI.BUTTON.WIDTH, constants.UI.BUTTON.HEIGHT) then
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