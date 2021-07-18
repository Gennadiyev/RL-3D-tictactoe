-- Class optimizer (for reinforcement learning)

local optimizer = {}

function optimizer:init(learningRate)
    local _optimizer = {
        learningRate = learningRate
    }
    function _optimizer:learn(agent, reward)
        for i=1, #agent.actionHistory do
            local action = agent.actionHistory[i]
            local h1, h2 = action:hashWithParent()
            local c = agent.model:query(h1, h2)
            if c then
                agent.model:update(h1, h2, reward * self.learningRate * i / #agent.actionHistory + c)
            else
                agent.model:update(h1, h2, reward * self.learningRate * i / #agent.actionHistory + agent.defaultValue)
            end
        end
        -- print("Optimizer: Learning completed")
        return true
    end
    return _optimizer
end

return optimizer