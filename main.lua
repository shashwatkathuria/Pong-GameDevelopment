-- Importing required libraries

push = require 'Libraries/push'
math = require 'math'
Class = require 'Libraries/class'

-- Importing classes defined

require 'Classes/Ball'
require 'Classes/Paddle'
require 'Classes/StateMachine'

-- Importing states defined
require 'States/BaseState'
require 'States/StartState'
require 'States/PlayState'
require 'States/ServeState'
require 'States/CountDownState'
require 'States/EndState'

-- Defining screen constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Variables required for scoring
winner = nil
leftPlayerScore = 0
rightPlayerScore = 0

function love.load()

    -- Filter to be nearest
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Defining fonts
    biggestFont = love.graphics.newFont("Fonts/font.ttf", 48)
    bigFont = love.graphics.newFont("Fonts/font.ttf", 32)
    smallFont = love.graphics.newFont("Fonts/font.ttf", 16)

    -- Setting window title
    love.window.setTitle("Pong")

    -- Setting up screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- Defining state machine with all states
    stateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['countdown'] = function() return CountDownState() end,
        ['end'] = function() return EndState() end
    }

    -- Initializing state machine with start state
    stateMachine:change('start')

    -- Initializing keys pressed
    love.keyboard.keysPressed = {}

end

function love.keypressed(key)

    -- Keeping track of keys pressed in each frame
    love.keyboard.keysPressed[key] = true

    -- Quitting application on escape
    if key == 'escape' then
        love.event.quit()
    end

end

function love.keyboard.wasPressed(key)

    -- Returning whether or not the key was pressed in current frame
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    -- Updating state machine
    stateMachine:update(dt)

    -- Resetting keys pressed
    love.keyboard.keysPressed = {}

end

function love.draw()

    push:start()

    -- Clearing with kind of gray color background
    love.graphics.clear(104 / 255, 118 / 255, 140 / 255, 255 / 255)

    -- Rendering appropriate state in state machine
    stateMachine:render()

    push:finish()

end

function love.resize(w, h)

    -- Resizing screen
    push:resize(w, h)

end
