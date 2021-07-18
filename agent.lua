-- Class agent (for reinforcement learning)

local agent = {}
local json = require("json")

function agent:init(optimizer, game, dict, model)
    local _model = {data = {}}
    if model then _model.data = model end
    function _model:query(h1, h2)
        local m = self.data
        if not(h2) then
            if m[h1] then
                return m[h1]
            else
                return false
            end
        else
            if m[h1] and m[h1][h2] then
                return m[h1][h2]
            else
                return false
            end
        end
    end
    function _model:update(h1, h2, value)
        local m = self.data
        if self:query(h1, h2) then
            m[h1][h2] = value
        else
            if self:query(h1) then
                m[h1][h2] = value
            else
                m[h1] = {
                    [h2] = value
                }
            end
        end
    end
    function _model:tostring()
        return json.encode(self.data)
    end
    local _agent = {
        model = _model,
        defaultValue = 1,
        actionHistory = {},
        optimizer = optimizer,
        game = game,
        epsilon = 0.1
    }
    if dict then
        for k, v in pairs(dict) do
            _agent[k] = v
        end
    end
    function _agent:init(optimizer, game, dict)
        self.model = {}
        self.actionHistory = {}
        if optimizer then
            self.optimizer = optimizer
        end
        if game then
            self.game = game
        end
        if dict then
            for k, v in pairs(dict) do
                self[k] = v
            end
        end    
        print("Agent: Created agent "..json.encode(dict))
    end
    function _agent:clearActionHistory()
        self.actionHistory = {}
        -- print("Agent: Action history cleared")
    end
    -- The core ability of agent is to store a mapping from tuple(STATE, ACTION) to VALUE
    function _agent:learn()
        self.optimizer:learn(self, self.game:getReward(self))
    end
    function _agent:act()
        -- print("Acting from agent " .. self.playerId)
        if self.game:shouldContinue() then
            -- print("Agent: The game should continue")
            local actionList = self.game:getPossibleActions(self)
            -- Pick with argmax
            local actionDecisions = {}
            for i = 1, #actionList do
                actionDecisions[#actionDecisions + 1] = {
                    action = actionList[i],
                    value = self.model:query(actionList[i]:hashWithParent()) or self.defaultValue
                }
            end
            table.sort(actionDecisions, function(a, b) return a.value > b.value end)
            -- for i = 1, #actionDecisions do
            --     print(string.format("Action %d%d%d Value %.4f", actionDecisions[i]['action'][1], actionDecisions[i]['action'][2], actionDecisions[i]['action'][3], actionDecisions[i]['value']))
            -- end

            local action = actionDecisions[1].action
            -- print(self.playerId.." Decision made "..actionDecisions[1].value)
            if math.random(0, 1000)/1000 < self.epsilon then
                action = actionDecisions[math.random(1, #actionDecisions)].action
            end
            -- Save action
            self.actionHistory[#self.actionHistory + 1] = action
            -- Perform action
            action:perform(self)
            return true
        else
            -- print("Agent: The game should end now")
            self.learn()
        end
    end
    function _agent:strictAct()
        if self.game:shouldContinue() then
            -- print("Agent: The game should continue")
            local actionList = self.game:getPossibleActions(self)
            -- Pick with argmax
            local actionDecisions = {}
            for i = 1, #actionList do
                actionDecisions[#actionDecisions + 1] = {
                    action = actionList[i],
                    value = self.model:query(actionList[i]:hashWithParent()) or 0
                }
            end
            table.sort(actionDecisions, function(a, b) return a.value > b.value end)
            local action = actionDecisions[1].action
            -- Save action
            self.actionHistory[#self.actionHistory + 1] = action
            -- Perform action
            action:perform(self)
            return true
        else
            -- print("Agent: The game should end now")
            self.learn()
        end
    end
    function _agent:modelTostring()
        return self.model:tostring()
    end
    return _agent
end

return agent
