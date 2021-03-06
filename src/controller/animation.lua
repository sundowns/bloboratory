AnimationController = Class {
    init = function(self)
        self.spriteBank = {}
    end;
    loadSpriteSheet = function(self, spriteName)
        local err, sprite_file
        sprite_file, err = love.filesystem.load('src/animation/'.. string.lower(spriteName) ..'.lua')
        if not sprite_file then
          print('[ERROR] The following error happend: ' .. tostring(err))
          return nil
        end

        self.spriteBank[spriteName] = sprite_file()
        return self.spriteBank[spriteName]
    end;
    createInstance = function(self, spriteName, currentState, size_scale, rotation)
        if spriteName == nil then return nil end

        if self.spriteBank[spriteName] == nil then
            if self:loadSpriteSheet(spriteName) == nil then return nil end
        end

        -- If the specified state does not exist, use the first one
        if self.spriteBank[spriteName].layers[1][currentState] == nil then
            currentState = self.spriteBank[spriteName].animation_names[1] 
        end

        return {
            animations = self:retrieveLayerInstances(spriteName, currentState),
            sprite = self.spriteBank[spriteName],
            currentState = currentState,
            time_scale = 1, --slow-mo?
        }
    end;
    retrieveLayerInstances = function(self, spriteName, currentState)
        local layers = {}

        for i, layer in pairs(self.spriteBank[spriteName].layers) do
            local anim_data = layer[currentState]
            table.insert(layers, {
                animation = anim8.newAnimation(self.spriteBank[spriteName].grid(anim_data.x, anim_data.y), anim_data.frame_duration),
                origin = Vector(anim_data.offset_x, anim_data.offset_y),
                rotation = anim_data.rotation,
                rotateToTarget = anim_data.rotate_to_target,
                manually_rotatable = anim_data.manually_rotatable,
                scale = Vector(anim_data.scale_x or 1, anim_data.scale_y or 1)
            })
        end;

        return layers
    end;
    changeSpriteState = function(self, instance, newState)
        -- If the specified state does not exist, we cooked
        assert(instance.sprite.layers[1][newState], "Tried to change sprite to non-existing state "..newState)

        instance.animations = self:retrieveLayerInstances(instance.sprite.id, newState)
    end;
    updateSpriteInstance = function(self, instance, dt)
        for i, layer in pairs(instance.animations) do
            layer.animation:update(dt)
        end
    end;
    updateInstanceRotation = function(self, instance, rotation)
        for i, layer in pairs(instance.animations) do
            if not layer.rotateToTarget and layer.manually_rotatable then
                layer.rotation = rotation + math.rad(90) --We had 90 because our sprites by default point up (-90 or 270 degrees)
            end
        end
    end;
    drawStructureSpriteInstance = function(self, instance, position, cellsWidth, cellsHeight, targettingAngle)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            if layer.rotateToTarget then
                layer.animation:draw(instance.sprite.image, position.x+cellsWidth*w*layer.scale.x/2, position.y+cellsHeight*h*layer.scale.y/2, targettingAngle, cellsWidth*layer.scale.x, cellsHeight*layer.scale.y, w/2, h/2)
            else
                layer.animation:draw(instance.sprite.image, position.x+cellsWidth*w*layer.scale.x/2, position.y+cellsHeight*h*layer.scale.y/2, layer.rotation, cellsWidth*layer.scale.x, cellsHeight*layer.scale.y, w/2, h/2)
            end
        end
    end;
    drawProjectileSpriteInstance = function(self, instance, position, cellsWidth, cellsHeight, targettingAngle)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            layer.animation:draw(instance.sprite.image, position.x, position.y, targettingAngle, cellsWidth*layer.scale.x, cellsHeight*layer.scale.y, w/2, h/2)
        end
    end;
    drawImpactSpriteInstance = function(self, instance, position, pixelWidth, pixelHeight)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            layer.animation:draw(instance.sprite.image, position.x, position.y, 0, pixelWidth/w*layer.scale.x, pixelHeight/h*layer.scale.y, w/2, h/2)
        end
    end;
    drawEnemySpriteInstance = function(self, instance, position, orientation)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            layer.animation:draw(instance.sprite.image, position.x, position.y, orientation, layer.scale.x, layer.scale.y, w/2, h/2)
        end
    end;
}