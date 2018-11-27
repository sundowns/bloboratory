
StructureBlueprint = Class {
    init = function(self, name, image, width, height, scaleX, scaleY, hitboxDimensions, hitboxType)
        self.name = name
        self.image = image
        self.uiImages = {}
        self.width = width -- width (in cells) of the blueprinted structure
        self.height = height -- height (in cells) of the blueprinted structure
        self.scaleX = scaleX or 1
        self.scaleY = scaleY or 1
        self.cost = constants.STRUCTURE[self.name].COST
        self.hitboxDimensions = hitboxDimensions
        self.costToolTip = constants.STRUCTURE[self.name].TOOLTIP
        self.hitboxType = hitboxType
    end;
    setUIImages = function(self, imagesTable)
        self.uiImages = imagesTable
    end;
    update = function(self)
    end;
    draw = function(self, origin)
        if self.hitboxType == "RADIUS" then
            if self.hitboxDimensions.radius > 0 then
                love.graphics.draw(self.image, origin.x, origin.y, 0, self.width*self.scaleX, self.height*self.scaleY)
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_RANGE)
                love.graphics.setLineWidth(5)
                love.graphics.rectangle('line', origin.x - self.hitboxDimensions.radius*constants.GRID.CELL_SIZE, origin.y - self.hitboxDimensions.radius*constants.GRID.CELL_SIZE, (2*self.hitboxDimensions.radius+self.width)*constants.GRID.CELL_SIZE, (2*self.hitboxDimensions.radius+self.height)*constants.GRID.CELL_SIZE)
            end
        elseif self.hitboxType == "LINE" then
            if self.hitboxDimensions.length and self.hitboxDimensions.width then

                love.graphics.draw(self.image, origin.x + self.width/2*constants.GRID.CELL_SIZE, origin.y + self.height/2*constants.GRID.CELL_SIZE, playerController.currentBlueprintOrientation + math.rad(90), self.width*self.scaleX, self.height*self.scaleY, self.image:getWidth()/2*self.scaleX, self.image:getHeight()/2*self.scaleY)
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_RANGE)
                love.graphics.setLineWidth(5)
                local x, y, width, height
                if playerController.currentBlueprintOrientation == constants.ORIENTATIONS.LEFT then
                    x = origin.x - self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                    y = origin.y + self.hitboxDimensions.width * constants.GRID.CELL_SIZE
                    width = self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                    height = self.hitboxDimensions.width * constants.GRID.CELL_SIZE * 2 
                elseif playerController.currentBlueprintOrientation == constants.ORIENTATIONS.UP then
                    x = origin.x + self.hitboxDimensions.width * constants.GRID.CELL_SIZE
                    y = origin.y - self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                    width = self.hitboxDimensions.width * constants.GRID.CELL_SIZE * 2
                    height = self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                elseif playerController.currentBlueprintOrientation == constants.ORIENTATIONS.RIGHT then
                    x = origin.x + self.width * constants.GRID.CELL_SIZE
                    y = origin.y + self.hitboxDimensions.width * constants.GRID.CELL_SIZE
                    width = self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                    height = self.hitboxDimensions.width * constants.GRID.CELL_SIZE * 2 
                elseif playerController.currentBlueprintOrientation == constants.ORIENTATIONS.DOWN then
                    x = origin.x + self.hitboxDimensions.width * constants.GRID.CELL_SIZE
                    y = origin.y + self.height * constants.GRID.CELL_SIZE
                    width = self.hitboxDimensions.width * constants.GRID.CELL_SIZE * 2
                    height = self.hitboxDimensions.length * constants.GRID.CELL_SIZE
                end
                
                love.graphics.rectangle('line', x, y, width, height)
            end
        else
            --draw obstacle
            love.graphics.draw(self.image, origin.x, origin.y, 0, self.width*self.scaleX, self.height*self.scaleY)
        end
    end;
}