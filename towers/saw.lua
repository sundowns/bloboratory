Saw = Class {
    __includes=Tower,
    init = function(self, gridX, gridY, worldX, worldY, width, height)
        Tower:init(gridX, gridY, worldX, worldY, width, height)
    end;
}