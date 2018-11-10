Camera = require("lib.camera")

CameraController = Class {
    init = function(self, origin)
        self.camera = Camera(origin:unpack())
        self.camera:zoom(1)
        self.cameraPanZones = {
            CameraPanZone("TOP", Vector(0,0), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT),
            CameraPanZone("RIGHT", Vector(love.graphics.getWidth()*(1-constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH),0), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT),
            CameraPanZone("BOTTOM", Vector(0,love.graphics.getHeight()*(1-constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT)), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT),
            CameraPanZone("LEFT", Vector(0,0), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT),
        }
        self.collisionWorld = bump.newWorld(love.graphics.getWidth()/100)
        for i, zone in pairs(self.cameraPanZones) do
            self.collisionWorld:add(zone, zone.origin.x, zone.origin.y, zone.width, zone.height)
        end

        self.mouse = Mouse(Vector(love.mouse.getPosition()))
        self.collisionWorld:add(self.mouse, self.mouse.origin.x, self.mouse.origin.y, self.mouse.width, self.mouse.height)
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

        self.mouse:update(dt)

        if love.window.hasMouseFocus() then
            local actualX, actualY, cols, len = self.collisionWorld:move(self.mouse, self.mouse.origin.x, self.mouse.origin.y, function() return "cross" end)

            --TODO: I think this would be a little more intuitive if the trigger area/hitbox was circular, not square

            if #cols > 0 then
                local direction = Vector(self.mouse.origin.x - love.graphics.getWidth()/2, self.mouse.origin.y - love.graphics.getHeight()/2):normalizeInplace()
                self.camera:move(dt*constants.CAMERA.SPEED*direction.x, dt*constants.CAMERA.SPEED*direction.y)
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
            for i, zone in pairs(self.cameraPanZones) do
                zone:draw()
            end
            self.mouse:draw()
        end
    end;
}

Mouse = Class {
    init = function(self, origin)
        self.origin = origin
        self.width = constants.CAMERA.MOUSE.WIDTH
        self.height = constants.CAMERA.MOUSE.HEIGHT
    end;
    update = function(self, dt)
        self.origin = Vector(love.mouse.getPosition())
    end;
    draw = function(self)
        love.graphics.rectangle('line', self.origin.x, self.origin.y, self.width, self.height)
    end;
}

CameraPanZone = Class {
    init = function(self, label, origin, width, height)
        self.label = label
        self.origin = origin
        self.width = width
        self.height = height
    end;
    draw = function(self)
        love.graphics.setColor(constants.COLOURS.CAMERA_PANZONES)
        love.graphics.rectangle('line', self.origin.x, self.origin.y, self.width, self.height)
    end;
}