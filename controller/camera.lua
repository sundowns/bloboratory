Camera = require("lib.camera")

CameraController = Class {
    init = function(self, origin)
        self.camera = Camera(origin:unpack())
        self.camera:zoom(1.2)
    end;
    attach = function(self)
        self.camera:attach()
    end;
    detach = function(self)
        self.camera:detach()
    end;
    update = function(self, dt)
        --TODO: Add some clever mouse camera movement
        if love.keyboard.isDown('left') then
            self.camera:move(-dt*constants.CAMERA_SPEED, 0)
        end
        if love.keyboard.isDown('right') then
            self.camera:move(dt*constants.CAMERA_SPEED, 0)
        end
        if love.keyboard.isDown('up') then
            self.camera:move(0, -dt*constants.CAMERA_SPEED)
        end
        if love.keyboard.isDown('down') then
            self.camera:move(0, dt*constants.CAMERA_SPEED)
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
}