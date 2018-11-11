Crucible = Class {
    init = function(self)
        self.isChoosing = 0
        self.enemies = {0,0,0,0,0,0,0,0,0}
    end;

    prepareToSend = function(self)
        local temp = {}
        for i, entry in pairs(self.enemies) do 
            if entry ~= 0 then 
                table.insert(temp, entry)
            end
        end
        self.enemies = temp
    end;

    clear = function(self)
        self.isChoosing = 0
        self.enemies = {0,0,0,0,0,0,0,0,0}
    end;
}