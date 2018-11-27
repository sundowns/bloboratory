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
        love.graphics.draw(self.image, origin.x, origin.y, 0, self.width*self.scaleX, self.height*self.scaleY)

        if self.hitboxType == "RADIUS" then
            if self.hitboxDimensions.radius > 0 then
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_RANGE)
                love.graphics.setLineWidth(5)
                love.graphics.rectangle('line', origin.x - self.hitboxDimensions.radius*constants.GRID.CELL_SIZE, origin.y - self.hitboxDimensions.radius*constants.GRID.CELL_SIZE, (2*self.hitboxDimensions.radius+self.width)*constants.GRID.CELL_SIZE, (2*self.hitboxDimensions.radius+self.height)*constants.GRID.CELL_SIZE)
            end
        elseif self.hitboxType == "LINE" then
            if self.hitboxDimensions.width and self.hitboxDimensions.height then
                -- Hardcoded to face left at the moment
                love.graphics.setColor(constants.COLOURS.BLUEPRINT_RANGE)
                love.graphics.setLineWidth(5)
                love.graphics.rectangle('line', origin.x - self.hitboxDimensions.width*constants.GRID.CELL_SIZE, origin.y + self.hitboxDimensions.height*constants.GRID.CELL_SIZE, self.hitboxDimensions.width*constants.GRID.CELL_SIZE, self.hitboxDimensions.height*constants.GRID.CELL_SIZE*2)
            end
        end
    end;
}