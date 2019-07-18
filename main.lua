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

ballVx = 0
ballVy = 0

PADDLE_HEIGHT = 40
PADDLE_WIDTH = 5
rightPlayerCenter = VIRTUAL_HEIGHT - 50 - PADDLE_HEIGHT / 2
leftPlayerCenter = 30 + PADDLE_HEIGHT / 2

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
    ballVy = 200 * (math.random() - 0.5)
    ballVx = math.random() > 0.5 and 100 or -100
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
            ballY = VIRTUAL_HEIGHT
            ballVy = -ballVy
        end
        ballX = ballX + ballVx * dt
        ballY = ballY + ballVy * dt

        if love.keyboard.isDown('w') then
            leftPlayerY = leftPlayerY - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('s') then
            leftPlayerY = leftPlayerY + PADDLE_SPEED * dt
        end

        leftPlayerCenter = leftPlayerY + PADDLE_HEIGHT / 2
        rightPlayerCenter = rightPlayerY + PADDLE_HEIGHT / 2

        if love.keyboard.isDown('up') then
            rightPlayerY = rightPlayerY - PADDLE_SPEED * dt
        elseif love.keyboard.isDown('down') then
            rightPlayerY = rightPlayerY + PADDLE_SPEED * dt
        end
    end

    if love.keyboard.isDown('space') and GAME_STATE == "start" then
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
    end

    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)

    if GAME_STATE == "play" then

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


        if ballX < 0 or ballX > VIRTUAL_WIDTH then
            GAME_STATE = "end"
        end

        ballCollideLeftPlayer()
        ballCollideRightPlayer()

        love.graphics.rectangle('fill', 10, leftPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayerY, PADDLE_WIDTH, PADDLE_HEIGHT)
        love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    elseif GAME_STATE == "end" then

        love.graphics.clear(178 / 255, 94 / 255, 212 / 255, 255 / 255)
        love.graphics.setFont(bigFont)
        love.graphics.printf('GAME END', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')

    end

    push:apply('end')

end

function love.resize(w, h)
    push:resize(w, h)
end

function ballCollideLeftPlayer()

    if ballX > leftPlayerX + PADDLE_WIDTH or leftPlayerX > ballX + 4 then
      return false
    end
    if ballY > leftPlayerY + PADDLE_HEIGHT or leftPlayerY > ballY + 4 then
      return false
    end

    sign = (ballY - leftPlayerCenter) > 0 and 1 or -1
    ballVy = sign * 1.05 * ballVy
    ballVx = -ballVx
    ballX = leftPlayerX + PADDLE_WIDTH
    
    return true

end

function ballCollideRightPlayer()

    if ballX > rightPlayerX + PADDLE_WIDTH or rightPlayerX > ballX + 4 then
      return false
    end
    if ballY > rightPlayerY + PADDLE_HEIGHT or rightPlayerY > ballY + 4 then
      return false
    end

    sign = (ballY - rightPlayerCenter) > 0 and 1 or -1
    ballVy = sign * 1.05 * ballVy
    ballVx = -ballVx
    ballX = rightPlayerX - 4

    return true
end
