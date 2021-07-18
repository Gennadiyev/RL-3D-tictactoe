local player = {}

function player:init(game, dict)
    local _player = {
        actionHistory = {},
        game = game
    }
    if dict then
        for k, v in pairs(dict) do
            _player[k] = v
        end
    end

    function _player:init(game, dict)
        self.actionHistory = {}
        if game then
            self.game = game
        end
        if dict then
            for k, v in pairs(dict) do
                self[k] = v
            end
        end    
        print("Player: Created player "..json.encode(dict))
    end
    function _player:clearActionHistory()
        self.actionHistory = {}
        -- print("Agent: Action history cleared")
    end
    function _player:act()
        if self.game:shouldContinue() then
            -- print("Agent: The game should continue")
            local actionList = self.game:getPossibleActions(self)
            local validInput = false
            local x, y, z
            while not(validInput) do
                print("Input x y z: ")
                x, y, z = io.read("*n", "*n", "*n")
                for i = 1, #actionList do
                    if actionList[i][1] == x and actionList[i][2] == y and actionList[i][3] == z then
                        print(string.format("Player picked (%d,%d,%d)",x,y,z))
                        self.game:update({x, y, z}, self.playerId)
                        validInput = true
                        break
                    end
                end
            end
            self.actionHistory[#self.actionHistory + 1] = {x, y, z}
            return true
        else
            -- print("Agent: The game should end now")
            self.learn()
        end

    end
    return _player
end

return player