push = require 'push'
math = require 'math'

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

ballX = VIRTUAL_WIDTH / 2 - 2
ballY = VIRTUAL_HEIGHT / 2 - 2
ballHeight = 4
ballWidth = 4
ballVx = 0
ballVy = 0
winner = "none"

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

    math.randomseed(os.time())
    ballVy = math.random(-200, 200)
    ballVx = math.random(-200, 200)
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end

end

function love.update(dt)

    if GAME_STATE == "play" then
        if ballY < 0 then
            ballY = 0
            ballVy = -ballVy
        elseif ballY > VIRTUAL_HEIGHT then
            ballY = VIRTUAL_HEIGHT - ballHeight
            ballVy = -ballVy
        end
        ballX = ballX + ballVx * dt
        ballY = ballY + ballVy * dt

        if love.keyboard.isDown('w') then
            leftPlayerY = leftPlayerY - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('s') then
            leftPlayerY = leftPlayerY + PADDLE_SPEED * dt
        end

        if love.keyboard.isDown('up') then
            rightPlayerY = rightPlayerY - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('down') then
            rightPlayerY = rightPlayerY + PADDLE_SPEED * dt
        end
    end

    if love.keyboard.isDown('space') and (GAME_STATE == "start" or GAME_STATE == "serve") then
        GAME_STATE = "play"
    end

end

function love.draw()

    push:apply('start')

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
        love.graphics.printf('Score : ' .. tostring(leftPlayerScore), 0, 10, VIRTUAL_WIDTH / 2, 'center')
        love.graphics.printf('Score : ' .. tostring(rightPlayerScore), VIRTUAL_WIDTH / 2, 10, VIRTUAL_WIDTH / 2, 'center')

    elseif GAME_STATE == "play" then
        love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)
        if leftPlayerY >= 0 then
            leftPlayerY = math.min(leftPlayerY, VIRTUAL_HEIGHT - PADDLE_HEIGHT)
        else
            leftPlayerY = 0
        end
        if rightPlayerY >= 0 then
            rightPlayerY = math.min(rightPlayerY, VIRTUAL_HEIGHT - PADDLE_HEIGHT)
        else
            rightPlayerY = 0
        end


        if ballX < 0 then

          rightPlayerScore = rightPlayerScore + 1
          ballX = VIRTUAL_WIDTH / 2 - 2
          ballY = VIRTUAL_HEIGHT / 2 - 2
          if rightPlayerScore == 5 then
              GAME_STATE = "end"
              winner = "Right"
          else
              GAME_STATE = "serve"
          end

        elseif ballX > VIRTUAL_WIDTH then


            leftPlayerScore = leftPlayerScore + 1
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            if leftPlayerScore == 5 then
                GAME_STATE = "end"
                winner = "Left"
            else
                GAME_STATE = "serve"
            end
        end

        if ballCollideLeftPlayer() then
            updateBallOnCollisionWithLeft()
        end

        if ballCollideRightPlayer() then
            updateBallOnCollisionWithRight()
        end

        love.graphics.rectangle('fill', 10, leftPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', ballX, ballY, ballWidth, ballHeight)

    elseif GAME_STATE == "end" then

        love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('GAME END', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf(winner .. " Player wins the game!", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')

    end

    push:apply('end')

end

function love.resize(w, h)
    push:resize(w, h)
end

function ballCollideLeftPlayer()

    if ballX > leftPlayerX + PADDLE_WIDTH or leftPlayerX > ballX + ballWidth then
      return false
    end
    if ballY > leftPlayerY + PADDLE_HEIGHT or leftPlayerY > ballY + ballHeight then
      return false
    end

    return true

end

function ballCollideRightPlayer()

    if ballX > rightPlayerX + PADDLE_WIDTH or rightPlayerX > ballX + ballWidth then
      return false
    end
    if ballY > rightPlayerY + PADDLE_HEIGHT or rightPlayerY > ballY + ballHeight then
      return false
    end

    return true
end

function updateBallOnCollisionWithLeft()
    ballVy = ballVy
    ballVx = -ballVx * 1.05
    ballX = leftPlayerX + PADDLE_WIDTH
end

function updateBallOnCollisionWithRight()
    ballVy = ballVy
    ballVx = -ballVx * 1.05
    ballX = rightPlayerX - ballWidth
end
