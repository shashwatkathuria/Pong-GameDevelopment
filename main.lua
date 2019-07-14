push = require 'push'
math = require 'math'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

leftPlayerX = 10
leftPlayerY = 30
rightPlayerX = VIRTUAL_WIDTH - 10
rightPlayerY = VIRTUAL_HEIGHT - 50

ballX = VIRTUAL_WIDTH / 2 - 2
ballY = VIRTUAL_HEIGHT / 2 - 2

ballVx = -100
ballVy = 0

GAME_STATE = 'play'

PADDLE_SPEED = 250

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')


    font = love.graphics.newFont('ARCADECLASSIC.ttf', 48)

    love.graphics.setFont(font)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    ballX = ballX + ballVx * dt
    ballY = ballY + ballVy * dt

    if love.keyboard.isDown('w') then
        leftPlayerY = leftPlayerY + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        leftPlayerY = leftPlayerY + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        rightPlayerY = rightPlayerY + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        rightPlayerY = rightPlayerY + PADDLE_SPEED * dt
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)

    love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)

    love.graphics.printf('WELCOME  TO  PONG', 0, 10, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)

    if GAME_STATE == "play" then

        if leftPlayerY >= 0 then
            leftPlayerY = math.min(leftPlayerY, VIRTUAL_HEIGHT - 20)
        else
            leftPlayerY = 0
        end
        if rightPlayerY >= 0 then
            rightPlayerY = math.min(rightPlayerY, VIRTUAL_HEIGHT - 20)
        else
            rightPlayerY = 0
        end

        if ballY < 0 then
            ballX = 0
            ballVy = -ballVy
        elseif ballY > VIRTUAL_HEIGHT then
            ballY = VIRTUAL_HEIGHT
            ballVy = -ballVy
        end
        if ballX < 0 or ballX > VIRTUAL_WIDTH then
            GAME_STATE = "end"
        end
        leftPaddleCollide = ballCollideLeftPlayer()
        rightPaddleCollide = ballCollideRightPlayer()


        if ballCollideLeftPlayer() then
          ballVx = -ballVx
        end
        if ballCollideRightPlayer() then
          ballVx = -ballVx
        end
        love.graphics.rectangle('fill', 10, leftPlayerY, 5, 20)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayerY, 5, 20)
        love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    elseif GAME_STATE == "end" then

        love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)
        love.graphics.printf('GAME END', 0, 10, VIRTUAL_WIDTH, 'center')

    end

    push:apply('end')

end

function ballCollideLeftPlayer()
    collisionNearness = 1
    if ballX >= leftPlayerX and ballX < leftPlayerX + 5 + collisionNearness then
      if ballY >= leftPlayerY - collisionNearness and ballY <= leftPlayerY + 20 + collisionNearness then
        return true
      else
        return false
      end
    else
      return false
    end
end

function ballCollideRightPlayer()
    if ballX >= rightPlayerX and ballX < rightPlayerX + 5 + collisionNearness  then
      if ballY >= rightPlayerY - collisionNearness and ballY <= rightPlayerY + 20 + collisionNearness then
        return true
      else
        return false
      end
    else
      return false
    end
end
