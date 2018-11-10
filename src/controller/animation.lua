AnimationController = Class {
    init = function(self)
        self.spriteBank = {}
    end;
    loadSpriteSheet = function(self, spriteName)
        local err, sprite_file
        sprite_file, err = love.filesystem.load('src/animation/'.. spriteName ..'.lua')
        if not sprite_file then
          print('[ERROR] The following error happend: ' .. tostring(err))
          return nil
        end

        self.spriteBank[spriteName] = sprite_file()
        -- Util.t.print(self.spriteBank[spriteName])
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
    drawStructureSpriteInstance = function(self, instance, x, y, cellsWidth, cellsHeight, targettingAngle)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            if layer.rotateToTarget then
                layer.animation:draw(instance.sprite.image, x+cellsWidth*w/2, y+cellsHeight*h/2, targettingAngle, w*cellsWidth/constants.GRID.CELL_SIZE, h*cellsHeight/constants.GRID.CELL_SIZE, w/2, w/2)
            else
                layer.animation:draw(instance.sprite.image, x+cellsWidth*w/2, y+cellsHeight*h/2, layer.rotation, w*cellsWidth/constants.GRID.CELL_SIZE, h*cellsHeight/constants.GRID.CELL_SIZE, w/2, w/2)
            end
        end
    end;
    drawEnemySpriteInstance = function(self, instance, x, y)
        for i, layer in pairs(instance.animations) do
            local w, h = layer.animation:getDimensions()
            layer.animation:draw(instance.sprite.image, x - w/2*layer.scale.x, y - h/2*layer.scale.y, layer.rotation, layer.scale.x, layer.scale.y)
        end
    end;
}