push = require 'push'
math = require 'math'
Class = require 'class'

require 'Ball'
require 'Paddle'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

leftPlayerX = 10
leftPlayerY = 30
leftPlayerScore = 0
rightPlayerX = VIRTUAL_WIDTH - 10
rightPlayerY = VIRTUAL_HEIGHT - 50
rightPlayerScore = 0

countdownInterval = 0.4

winner = "none"
countdownTime = 0
PADDLE_HEIGHT = 40
PADDLE_WIDTH = 5
-- rightPlayerCenter = VIRTUAL_HEIGHT - 50 - PADDLE_HEIGHT / 2
-- leftPlayerCenter = 30 + PADDLE_HEIGHT / 2

collisionNearness = 3

GAME_STATE = 'start'

PADDLE_SPEED = 250

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')


    bigFont = love.graphics.newFont("font.ttf", 32)
    smallFont = love.graphics.newFont("font.ttf", 16)

    love.window.setTitle("Pong")

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    leftPlayer = Paddle(leftPlayerX, leftPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)
    rightPlayer = Paddle(rightPlayerX, rightPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)
    math.randomseed(os.time())
    ball:reset()
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end

end

function love.update(dt)

    if GAME_STATE == "play" then
        ball:update(dt)

        if love.keyboard.isDown('w') then
            leftPlayer:update('moveUp', dt)
        elseif love.keyboard.isDown('s') then
            leftPlayer:update('moveDown', dt)
        end

        if love.keyboard.isDown('up') then
            rightPlayer:update('moveUp', dt)
        elseif love.keyboard.isDown('down') then
            rightPlayer:update('moveDown', dt)
        end
    end

    if love.keyboard.isDown('space') and (GAME_STATE == "start" or GAME_STATE == "serve") then
        GAME_STATE = "countdown"
        countdown = 3
        countdownTime = countdownTime + dt

    end

    if GAME_STATE == "countdown" then
        countdownTime = countdownTime + dt
    end

end

function love.draw()

    push:start()

    love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)

    if GAME_STATE == "start" then
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('WELCOME  TO  PONG', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Space to Start', 0, 50, VIRTUAL_WIDTH, 'center')
    elseif GAME_STATE == "serve" then
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Score : ' .. tostring(leftPlayer.score), 0, 10, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.printf('Score : ' .. tostring(rightPlayer.score), VIRTUAL_WIDTH / 2, 10, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.printf('Press Space to Continue', 0, 50, VIRTUAL_WIDTH, 'center')
        ball:reset()

    elseif GAME_STATE == "countdown" then
        if countdownTime > countdownInterval then
            countdown = countdown - 1
            countdownTime = countdownTime % countdownInterval
        end
        love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
        love.graphics.setFont(smallFont)
        love.graphics.printf('Starting in ' .. tostring(countdown), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')

        if countdown == 0 then
            GAME_STATE = "play"
        end

    elseif GAME_STATE == "play" then
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)


        if ball.x < 0 then

          rightPlayer.score = rightPlayer.score + 1
          if rightPlayer.score == 5 then
              GAME_STATE = "end"
              winner = "Right"
          else
              GAME_STATE = "serve"
          end

        elseif ball.x > VIRTUAL_WIDTH then
            leftPlayer.score = leftPlayer.score + 1
            if leftPlayer.score == 5 then
                GAME_STATE = "end"
                winner = "Left"
            else
                GAME_STATE = "serve"
            end
        end

        if ball:hasCollided(leftPlayer) then
            ball:updateOnCollision('left', leftPlayer)
        end

        if ball:hasCollided(rightPlayer) then
            ball:updateOnCollision('right', rightPlayer)
        end

        love.graphics.rectangle('fill', 10, leftPlayer.y, leftPlayer.width, leftPlayer.height)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayer.y, rightPlayer.width, rightPlayer.height)
        love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)

    elseif GAME_STATE == "end" then

        love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('GAME END', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf(winner .. " Player wins the game!", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')

    end

    push:finish()

end

function love.resize(w, h)
    push:resize(w, h)
end
