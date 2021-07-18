# Reinforcement Learning applied to 3D Tic-tac-toe

## Introduction

This project is a simple (yet **standalone**) implementation of basic reinforcement learning model. It is simple in the following terms:

- Back propagation simplified to linear
- $\varepsilon$-greedy with a constant $\varepsilon$

Features of the project:

- The project focuses on extensibility: to modify the game or use the model on another game, the only file to edit is `board.lua`. (You may also need to modify `main.lua`, which is the driver file of the process.)
- The project also has `player.lua`, which defines the human player's action towards the game, making the behaviors fully-customizable.
- Pure Lua implementation, which means the project can be easily migrated to other applications or called from C / C++.
- No dependencies at all!

The project is developed under Lua 5.4, but is tested on Lua 5.2 and 5.3 as well.

### Rules of the game

3D Tic-tac-toe is generally all about 2 players taking turns to place `O` and `X` respectively onto a $3 \times 3 \times 3$ cube, until three `O` or `X`'s form a line, whether straight, surface-diagonal or cube-diagonal. The first player who makes 3 in a line wins the game.

## Usage

### Training

**The project does not come with a pre-trained model! This means you have to train on your own.**

First, navigate to `main.lua` and scroll to the end.

You usually want two agents to play against each other and learn from their games. To train the two agents (`agent1` and `agent2` by default in `main.lua`), simply run:

```lua
train(count)
```

| Parameter | Type | Description |
| :-: | :-: | :-- |
| `count` | `number` | The number of games that the two agents should play. |

A good starting value for `count` is `100000`, where the `agent1` will usually be able to learn to play the first chess on the center of the cube.

### Saving models

**Always remember to save the model** or your trained progress will be lost forever.

To save the model, run:

```lua
saveModel(agentModelPath1, agentModelPath2)
```

| Parameter | Type | Description |
| :-: | :-: | :-- |
| `agentModelPath1` | `string` | The name of the file to save the first agent's trained model. |
| `agentModelPath2` | `string` | The name of the file to save the second agent's trained model. |

- If the file does not exist, a new file with the given name will be created.
- If a relative path or absolute path is given, but a folder does not exist already, an error will be raised.

The model is saved in JSON format, so you may wish to change the suffix of the file path to `.json`.

Typical usage:

```lua
saveModel("agent1-snapshot@100000.json", "agent2-snapshot@100000.json")
```

### Loading saved models

To load the models, use:

```lua
loadModel(agentModelPath1, agentModelPath2)
```

| Parameter | Type | Description |
| :-: | :-: | :-- |
| `agentModelPath1` | `string` | The name of the file which stores the first agent's trained model. |
| `agentModelPath2` | `string` | The name of the file which stores the second agent's trained model. |

If the model is not valid, or the file does not exist, an error will be raised.

Note that as you run this function, `agent1` and `agent2` will be overwritten by the new trained models (as defined in `loadModel()`). You may want to modify the parameters inside `loadModel()`, such as the `epsilon` and `learningRate` of the agents.

### Play with the model

To play the game with the model, simply run `play()` with no argument after loading the model you'd like to use to `agent1`. `agent1` is the first player, and the user (human) is the second. To play before the agent, you need to modify `play()` yourself, and make sure you use `agent2` instead of `agent1` (otherwise the model will be of no use at all, it makes no sense for `agent1` to play second).

If you wish to play while training the agent, use `play(true)` instead.

### PVP

Thanks to OOP, implementing PVP is no big task once you finished the coding part in `player.lua`. `pvp()` function provides a player-against-player game under command-line interface. No agents will be monitoring you, so feel free to play any way you like!

### More modifications

The model is very simple with merely several hundred lines of Lua code. It's easy to dive in and modify a bit on your own! If you don't know where to begin, refer to the table below.

| File | Description |
| :-- | :-- |
| `board.lua` | Defines game rules. |
| `main.lua` | The driver file. |
| `json.lua` | A json library written in pure lua. You usually shouldn't bother to edit this. |
| `agent.lua` | Defines the behavior of an agent. The model is a parameter of agent, also defined in this file. |
| `optimizer.lua` | The optimizer function which handles the learning process (or back-propagation). |

If you simply want to modify the game rules, you must bear in mind that all functions in class `board` should be implemented. Notably, this includes `board:getPossibleActions(agent)`, where a table of possible `action`'s is returned. Each `action` (class) must contain a `perform` method which interacts with the board, and **both** `hash`, `hashWithParent` method to hash the action at current board state.

Wish you good luck in venturing through the codes!

## License

The codes here are licensed under [Apache-2.0](http://www.apache.org/licenses/LICENSE-2.0).
