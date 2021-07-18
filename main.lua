-- Reinforcement Learning

-- Game: Tic-tac-toe but on 3x3x3 (but connects 3 still wins)

Board = require("board")
Agent = require("agent")
Optimizer = require("optimizer")
Player = require("player")

-- Initialize the game with 2 agents
local board = Board:init()
local agent1 = Agent:init(Optimizer:init(0.2), board, {playerId = 1, epsilon = 0.1})
local agent2 = Agent:init(Optimizer:init(0.1), board, {playerId = 2, epsilon = 0.5})
local player1 = Player:init(board, {playerId = 1})
local player2 = Player:init(board, {playerId = 2})

function loadModel(agentModelPath1, agentModelPath2)
    local loader1 = io.open(agentModelPath1 or 'agent1.json', 'r')
    agent1 = Agent:init(
        Optimizer:init(0.5),
        board,
        {playerId = 1, epsilon=0.02},
        json.decode(loader1:read("*a"))
    )
    local loader2 = io.open(agentModelPath2 or 'agent2.json', 'r')
    agent2 = Agent:init(
        Optimizer:init(1),
        board,
        {playerId = 2, epsilon=0.05},
        json.decode(loader2:read("*a"))
    )
end

function saveModel(agentModelPath1, agentModelPath2)
    local saver1 = io.open(agentModelPath1 or 'agent1.json', 'w+')
    saver1:write(agent1:modelTostring())
    local saver2 = io.open(agentModelPath2 or 'agent2.json', 'w+')
    saver2:write(agent2:modelTostring())    
end

function train(count)
    -- Play the game
    local stats = {0, 0, 0, 0}
    local gameCount = 0
    while gameCount < count do
        while board:shouldContinue() do
            agent1:act()
            if board:shouldContinue() then
                agent2:act()
            else
                break
            end
        end

        agent1:learn()
        agent2:learn()
        agent1:clearActionHistory()
        agent2:clearActionHistory()
        local state = board:getState() + 2
        stats[state] = stats[state] + 1
    
        if gameCount % 1000 == 0 then
            print(string.format("Main: Game %d completed: Player 1 win rate = %.2f%% ", gameCount, stats[1+2] / gameCount * 100))
        end
    
        board:init()
        gameCount = gameCount + 1
    end
end

function play(shouldLearn)
    while board:shouldContinue() do
        agent1:strictAct()
        print(board:tostring())
        if board:shouldContinue() then
            player2:act()
            print(board:tostring())
        else
            break
        end
    end
    if shouldLearn then
        agent1:learn()
    end
    print(string.format("Main: Game completed with result "..tostring(board:getState())))
end

function pvp()
    while board:shouldContinue() do
        player1:act()
        print(board:tostring())
        if board:shouldContinue() then
            player2:act()
            print(board:tostring())
        else
            break
        end
    end
    if shouldLearn then
        agent1:learn()
    end
    print(string.format("Main: Game completed with result "..tostring(board:getState())))    
end

math.randomseed(os.time())

-- print("Loading model...")
-- loadModel("agent1-snapshot@900000.json", "agent2-snapshot@250000.json")
-- play(false)

-- print("Training...")
-- train(1000000)
-- print("Training completed")
-- saveModel("agent1-snapshot@900000.json", "agent2-snapshot@100000.json")
-- print("Model saved")

print("You need to edit main.lua and train your own model!")
