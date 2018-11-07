AnimationController = Class {
    init = function(self)
        self.spriteBank = {}
    end;
    loadSpriteSheet = function(self, spriteName)
        local err, sprite_file
        sprite_file, err = love.filesystem.load('animation/'.. spriteName ..'.lua')
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
        if self.spriteBank[spriteName].animations[currentState] == nil then
            currentState = self.spriteBank[spriteName].animation_names[1] 
        end

        local anim_data = self.spriteBank[spriteName].animations[currentState]

        return {
            animation = anim8.newAnimation(self.spriteBank[spriteName].grid(anim_data.x, anim_data.y), anim_data.frame_duration),
            sprite = self.spriteBank[spriteName],
            currentState = currentState,
            time_scale = 1, --slow-mo?,
            rotation = rotation or 0
        }
    end;
    changeSpriteState = function(self, instance, newState)
        -- If the specified state does not exist, we cooked
        assert(instance.sprite.animations[newState], "Tried to change sprite to non-existing state "..newState)

        instance.animation = anim8.newAnimation(instance.sprite.grid(instance.sprite.animations[newState].x, instance.sprite.animations[newState].y), instance.sprite.animations[newState].frame_duration)
    end;
    updateSpriteInstance = function(self, instance, dt, rotation)
        if rotation then instance.rotation = rotation end

        instance.animation:update(dt)
    end;
    drawSpriteInstance = function(self, instance, x, y, cells_width, cells_height)
        local w, h = instance.animation:getDimensions()
        instance.animation:draw(instance.sprite.image, x, y, instance.rotation, w*cells_width/constants.GRID.CELL_SIZE, h*cells_height/constants.GRID.CELL_SIZE)
    end;
}