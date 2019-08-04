
-- Importing required libraries

push = require 'Libraries/push'
math = require 'math'
Class = require 'Libraries/class'

-- Importing classes defined

require 'Classes/Ball'
require 'Classes/Paddle'

-- Defining screen constants
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Variables required
countdownInterval = 0.7
countdownTime = 0
winner = "none"

PADDLE_HEIGHT = 40
PADDLE_WIDTH = 5
PADDLE_SPEED = 250

function love.load()

    -- Initializing game state to start
    GAME_STATE = 'start'

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

    -- Initializing ball, left and right player
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    leftPlayer = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)
    rightPlayer = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)

    -- Randomizing seed
    math.randomseed(os.time())

    -- Resetting ball to center
    ball:reset()

end

function love.keypressed(key)

    -- Quitting application on escape
    if key == 'escape' then
        love.event.quit()
    end

    -- Rematch on pressing enter on end game state
    if GAME_STATE == "end" and key == 'return' then
        GAME_STATE = "start"

        -- Resetting ball, left and right player
        ball:reset()
        leftPlayer:reset(10, 30)
        rightPlayer:reset(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50)
    end

end

function love.update(dt)

    -- Updating ball on each frame
    if GAME_STATE == "play" then
        ball:update(dt)

        -- Continuous keyboard moves for left player
        if love.keyboard.isDown('w') then
            leftPlayer:update('moveUp', dt)
        elseif love.keyboard.isDown('s') then
            leftPlayer:update('moveDown', dt)
        end

        -- Continuous keyboard moves for right player
        if love.keyboard.isDown('up') then
            rightPlayer:update('moveUp', dt)
        elseif love.keyboard.isDown('down') then
            rightPlayer:update('moveDown', dt)
        end

    -- Incrementing countdownTime by required amount
    elseif GAME_STATE == "countdown" then
        countdownTime = countdownTime + dt
    end

    -- Changing to countdown state on pressing space when in start or serve state
    if love.keyboard.isDown('space') and (GAME_STATE == "start" or GAME_STATE == "serve") then

        -- Initializing variables required
        GAME_STATE = "countdown"
        countdown = 3
        countdownTime = countdownTime + dt

    end

end

function love.draw()

    push:start()

    -- Kind of gray color background
    love.graphics.clear(104 / 255, 118 / 255, 140 / 255, 255 / 255)

    if GAME_STATE == "start" then

        -- Printing messages specific to start state
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('WELCOME  TO  PONG', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Space to Start', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')

    elseif GAME_STATE == "serve" then

        -- Printing messages specific to serve state, displaying scores
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('SCORE', 0, 5, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(biggestFont)
        love.graphics.printf(tostring(leftPlayer.score), 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.printf(tostring(rightPlayer.score), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 'center')

        -- Vertical partition in the middle of the screen
        love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 6, 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Space to Continue', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
        ball:reset()

    elseif GAME_STATE == "countdown" then

        -- Countdown algorithm with interval as countdownInterval
        if countdownTime > countdownInterval then
            countdown = countdown - 1
            countdownTime = countdownTime % countdownInterval
        end

        -- Printing countdown
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(biggestFont)
        love.graphics.printf(tostring(countdown), 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')

        -- Starting game when countdown is over
        if countdown == 0 then
            GAME_STATE = "play"
        end

    elseif GAME_STATE == "play" then

        -- White color for ball and paddles
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)

        -- Incrementing right player score when ball goes to the left of screen
        if ball.x < 0 then

          rightPlayer.score = rightPlayer.score + 1

          -- Game ends when scores reaches 5
          if rightPlayer.score == 5 then
              GAME_STATE = "end"
              winner = "Right"
          else
              GAME_STATE = "serve"
          end

        -- Incrementing left player score when ball goes to the right of screen
        elseif ball.x > VIRTUAL_WIDTH then

            leftPlayer.score = leftPlayer.score + 1

            -- Game ends when scores reaches 5
            if leftPlayer.score == 5 then
                GAME_STATE = "end"
                winner = "Left"
            else
                GAME_STATE = "serve"
            end

        end

        -- Updating ball if it collides with left player
        if ball:hasCollided(leftPlayer) then
            ball:updateOnCollision('left', leftPlayer)
        end

        -- Updating ball if it collides with right player
        if ball:hasCollided(rightPlayer) then
            ball:updateOnCollision('right', rightPlayer)
        end

        -- Drawing updated ball, left and right player
        love.graphics.rectangle('fill', 10, leftPlayer.y, leftPlayer.width, leftPlayer.height)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayer.y, rightPlayer.width, rightPlayer.height)
        love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)

    elseif GAME_STATE == "end" then

        -- Printing messages specific to end state
        love.graphics.clear(104 / 255, 118 / 255, 140 / 255, 255 / 255)
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('GAME END', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf(winner .. " Player wins the game!", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter for Rematch', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')

    end

    push:finish()

end

function love.resize(w, h)

    -- Resizing screen
    push:resize(w, h)

end
