push = require 'push'
math = require 'math'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

leftPlayerY = 30
rightPlayerY = VIRTUAL_HEIGHT - 50


PADDLE_SPEED = 300

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
    love.graphics.rectangle('fill', 10, leftPlayerY, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, rightPlayerY, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    push:apply('end')

end

-- function startBall()
--
-- end
