Camera = require("lib.camera")

CameraController = Class {
    init = function(self, origin)
        self.camera = Camera(origin:unpack())
        self.camera:zoom(1)
        self.panRadius = constants.CAMERA.PAN_RADIUS_RATIO*love.graphics.getWidth()
        self.maxPanDifference = (0.5 - constants.CAMERA.PAN_RADIUS_RATIO)*love.graphics.getWidth()

    end;
    attach = function(self)
        self.camera:attach()
    end;
    detach = function(self)
        self.camera:detach()
    end;
    update = function(self, dt)
        if love.keyboard.isDown('left') then
            self.camera:move(-dt*constants.CAMERA.SPEED, 0)
        end
        if love.keyboard.isDown('right') then
            self.camera:move(dt*constants.CAMERA.SPEED, 0)
        end
        if love.keyboard.isDown('up') then
            self.camera:move(0, -dt*constants.CAMERA.SPEED)
        end
        if love.keyboard.isDown('down') then
            self.camera:move(0, dt*constants.CAMERA.SPEED)
        end

        if love.window.hasMouseFocus() then
            local delta = Vector(inputController.mouse.origin.x - love.graphics.getWidth()/2, inputController.mouse.origin.y - love.graphics.getHeight()/2)
            if delta:len() > self.panRadius then
                local additionalVelocity = (delta:len() - self.panRadius)/self.maxPanDifference * constants.CAMERA.MAX_ADDITIONAL_PAN_SPEED
                local direction = delta:normalized()
                self.camera:move(dt*(constants.CAMERA.SPEED + additionalVelocity)*direction.x, dt*(constants.CAMERA.SPEED + additionalVelocity)*direction.y)
            end
        end
    end;
    getWorldCoordinates = function(self, x, y)
        return self.camera:worldCoords(x, y)
    end;
    getCameraCoordinates = function(self, x, y)
        return self.camera:cameraCoords(x, y)
    end;
    mousePosition = function(self)
        return self.camera:mousePosition()
    end;
    draw = function(self)
        if debug then
            love.graphics.setColor(0,1,0,0.3)
            love.graphics.circle('line', love.graphics.getWidth()/2, love.graphics.getHeight()/2, self.panRadius)
        end
    end;
}
