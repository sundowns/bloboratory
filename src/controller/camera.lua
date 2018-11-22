Camera = require("lib.camera")

CameraController = Class {
    init = function(self, origin)
        self.cameraTimer = Timer.new()
        self.camera = Camera(origin:unpack())
        self.camera:zoom(0.8)
    end;
    attach = function(self)
        self.camera:attach()
    end;
    detach = function(self)
        self.camera:detach()
    end;
    update = function(self, dt)
        self.cameraTimer:update(dt)
    end;
    getWorldCoordinates = function(self, screenOrigin)
        return Vector(self.camera:worldCoords(screenOrigin.x, screenOrigin.y))
    end;
    getCameraCoordinates = function(self, worldOrigin)
        return Vector(self.camera:cameraCoords(worldOrigin.x, worldOrigin.y))
    end;
    mousePosition = function(self)
        return self.camera:mousePosition()
    end;
    shake = function(self, duration, jitter)
        assert(duration > 0)
        jitter = jitter or 2
        local orig_x, orig_y = self.camera:position()
        self.cameraTimer:during(duration, function()
            self.camera:lookAt(orig_x + math.random(-jitter,jitter), orig_y + math.random(-jitter,jitter))
        end)
    end;
}

CameraPanZone = Class {
    init = function(self, label, origin, width, height, fast)
        self.label = label
        self.origin = origin
        self.width = width
        self.height = height
        self.fast = fast
    end;
    draw = function(self)
        if self.fast then
            love.graphics.setColor(0,1,0)
        else 
            love.graphics.setColor(constants.COLOURS.CAMERA_PANZONES)
        end
        love.graphics.rectangle('line', self.origin.x, self.origin.y, self.width, self.height)
    end;
}