-- Class board

local board = {}

function board:init()
    local _board = {
        {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
        {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}},
        {{0, 0, 0}, {0, 0, 0}, {0, 0, 0}}
    }
    function _board:init()
        for x = 1, 3 do
            for y = 1, 3 do
                for z = 1, 3 do
                    self[x][y][z] = 0
                end
            end
        end
        -- print("Board: Board cleared")
        return self
    end
    function _board:update(pos, playerId)
        self[pos[1]][pos[2]][pos[3]] = playerId
        -- print("Assigned:", playerId)
        return true
    end
    function _board:getPossibleActions(agent)
        local possibleActions = {}
        for x = 1, 3 do
            for y = 1, 3 do
                for z = 1, 3 do
                    if self[x][y][z] == 0 then
                        local _action = {x, y, z}
                        local _parent = self
                        function _action:getParent()
                            return _parent
                        end
                        function _action:hash()
                            return 'a' .. tostring(x*100 + y*10 + z)
                        end
                        local _postActionParentHash = 's'
                        for x = 1, 3 do
                            for y = 1, 3 do
                                for z = 1, 3 do
                                    if _action[1] == x and _action[2] == y and _action[3] == z then
                                        _postActionParentHash = _postActionParentHash .. tostring(agent.playerId)
                                    else
                                        _postActionParentHash = _postActionParentHash .. tostring(self[x][y][z])
                                    end
                                end
                            end
                        end
                        function _action:hashWithParent()
                            return _postActionParentHash, self:hash()
                        end
                        function _action:perform(agent)
                            -- print("Performing "..table.concat(_action, ", ").." with "..tostring(agent.playerId))
                            return _parent:update({x, y, z}, agent.playerId)
                        end
                        possibleActions[#possibleActions + 1] = _action
                    end
                end
            end
        end
        return possibleActions
    end
    function _board:getState(agent)
        -- Check win conditions
        -- >0: playerId wins
        -- =0: should continue
        -- =-1: draw
        for x = 1, 3 do
            if self[x][1][1] > 0 and self[x][1][1] == self[x][2][2] and self[x][2][2] == self[x][3][3] then
                return self[x][2][2]
            end
            if self[x][3][1] > 0 and self[x][3][1] == self[x][2][2] and self[x][2][2] == self[x][1][3] then
                return self[x][2][2]
            end            
            for y = 1, 3 do
                if self[x][y][1] > 0 and self[x][y][1] == self[x][y][2] and self[x][y][2] == self[x][y][3] then
                    return self[x][y][1]
                end
            end
        end
        for z = 1, 3 do
            if self[1][1][z] > 0 and self[1][1][z] == self[2][2][z] and self[2][2][z] == self[3][3][z] then
                return self[2][2][z]
            end
            if self[1][3][z] > 0 and self[1][3][z] == self[2][2][z] and self[2][2][z] == self[3][1][z] then
                return self[2][2][z]
            end
            for x = 1, 3 do
                if self[x][1][z] > 0 and self[x][1][z] == self[x][2][z] and self[x][2][z] == self[x][3][z] then
                    return self[x][1][z]
                end
            end
        end
        for y = 1, 3 do
            if self[1][y][1] > 0 and self[1][y][1] == self[2][y][2] and self[2][y][2] == self[3][y][3] then
                return self[2][y][2]
            end
            if self[1][y][3] > 0 and self[1][y][3] == self[2][y][2] and self[2][y][2] == self[3][y][1] then
                return self[2][y][2]
            end
            for z = 1, 3 do
                if self[1][y][z] > 0 and self[1][y][z] == self[2][y][z] and self[2][y][z] == self[3][y][z] then
                    return self[1][y][z]
                end
            end
        end
        
        if self[2][2][2] > 0 and self[1][1][1] == self[2][2][2] and self[2][2][2] == self[3][3][3] then
            return self[2][2][2]
        end
        if self[2][2][2] > 0 and self[1][3][1] == self[2][2][2] and self[2][2][2] == self[3][1][3] then
            return self[2][2][2]
        end
        if self[2][2][2] > 0 and self[3][1][1] == self[2][2][2] and self[2][2][2] == self[1][3][3] then
            return self[2][2][2]
        end
        if self[2][2][2] > 0 and self[1][1][3] == self[2][2][2] and self[2][2][2] == self[3][3][1] then
            return self[2][2][2]
        end
        for x = 1, 3 do
            for y = 1, 3 do
                for z = 1, 3 do
                    if self[x][y][z] == 0 then
                        return 0
                    end
                end
            end
        end
        return -1
    end
    function _board:getReward(agent)
        if self:getState() == agent.playerId then
            return 1
        elseif self:getState() ~= agent.playerId then
            return -1
        elseif self:getState() == -1 then
            return 0
        else
            return false
        end
    end
    function _board:shouldContinue()
        return self:getState() == 0
    end
    function _board:hash()
        local str = 's'
        for x = 1, 3 do
            for y = 1, 3 do
                for z = 1, 3 do
                    str = str .. self[x][y][z]
                end
            end
        end
        return str
    end
    function _board:tostring()
        local str = ""
        for x = 1, 3 do
            for y = 1, 3 do
                for z = 1, 3 do
                    str = str .. self[x][y][z]
                end
                str = str .. "\n"
            end
            str = str .. "\n"
        end
        return str
    end
    return _board
end

return board