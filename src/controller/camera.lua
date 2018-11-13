Camera = require("lib.camera")

CameraController = Class {
    init = function(self, origin)
        self.camera = Camera(origin:unpack())
        self.camera:zoom(1)
        self:calculateCameraBounds()
    end;
    calculateCameraBounds = function(self)
        self.cameraPanZones = {
            CameraPanZone("TOP", Vector(love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH,love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH - love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH*2, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT, false),
            CameraPanZone("RIGHT", Vector(love.graphics.getWidth()*(1-constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH*2),love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT - love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT*2, false),
            CameraPanZone("BOTTOM", Vector(love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH,love.graphics.getHeight()*(1-constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT*2)), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH - love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH*2, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT, false),
            CameraPanZone("LEFT", Vector(love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH,love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT - love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT*2, false),
            CameraPanZone("FASTTOP", Vector(0,0), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT, true),
            CameraPanZone("FASTRIGHT", Vector(love.graphics.getWidth()*(1-constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH),0), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT, true),
            CameraPanZone("FASTBOTTOM", Vector(0,love.graphics.getHeight()*(1-constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT)), love.graphics.getWidth()*constants.CAMERA.PANZONES.TOP_BOTTOM.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.TOP_BOTTOM.HEIGHT, true),
            CameraPanZone("FASTLEFT", Vector(0,0), love.graphics.getWidth()*constants.CAMERA.PANZONES.LEFT_RIGHT.WIDTH, love.graphics.getHeight()*constants.CAMERA.PANZONES.LEFT_RIGHT.HEIGHT, true),
        }
        self.collisionWorld = bump.newWorld(love.graphics.getWidth()/100)
        for i, zone in pairs(self.cameraPanZones) do
            self.collisionWorld:add(zone, zone.origin.x, zone.origin.y, zone.width, zone.height)
        end

        self.collisionWorld:add(inputController.mouse, inputController.mouse.origin.x, inputController.mouse.origin.y, inputController.mouse.width, inputController.mouse.height)
    end;
    attach = function(self)
        self.camera:attach()
    end;
    detach = function(self)
        self.camera:detach()
    end;
    update = function(self, dt)
        if love.window.hasMouseFocus() then
            local actualX, actualY, cols, len = self.collisionWorld:move(inputController.mouse, inputController.mouse.origin.x, inputController.mouse.origin.y, function() return "cross" end)
    
            local collided = #cols > 0
            local accelerated = false
            for i = 1, #cols do 
                if cols[i].other.fast then
                    accelerated = true
                end
    
            end
    
            if collided then
                local direction = Vector(inputController.mouse.origin.x - love.graphics.getWidth()/2, inputController.mouse.origin.y - love.graphics.getHeight()/2):normalizeInplace()
                if accelerated then
                    self.camera:move(dt*constants.CAMERA.SPEED*constants.CAMERA.ADDITIONAL_SPEED_MODIFIER*direction.x, dt*constants.CAMERA.SPEED*constants.CAMERA.ADDITIONAL_SPEED_MODIFIER*direction.y) --TODO: yeah but faster idiot
                else
                    self.camera:move(dt*constants.CAMERA.SPEED*direction.x, dt*constants.CAMERA.SPEED*direction.y)
                end
            end
        end
       
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
        end
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