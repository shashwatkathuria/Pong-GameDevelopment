PlayState = Class{__includes = BaseState}

PADDLE_HEIGHT = 40
PADDLE_WIDTH = 5
PADDLE_SPEED = 250

function PlayState:init()

    -- Initializing ball, left player and right player
    self.ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)
    self.leftPlayer = Paddle(10, 30, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)
    self.rightPlayer = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, PADDLE_WIDTH, PADDLE_HEIGHT, PADDLE_SPEED)

    -- Randomizing seed
    math.randomseed(os.time())

end

function PlayState:update(dt)

    self.ball:update(dt)

    -- Continuous keyboard moves for left player
    if love.keyboard.isDown('w') then
        self.leftPlayer:update('moveUp', dt)
    elseif love.keyboard.isDown('s') then
        self.leftPlayer:update('moveDown', dt)
    end

    -- Continuous keyboard moves for right player
    if love.keyboard.isDown('up') then
        self.rightPlayer:update('moveUp', dt)
    elseif love.keyboard.isDown('down') then
        self.rightPlayer:update('moveDown', dt)
    end

    -- Incrementing right player score when ball goes to the left of screen
    if self.ball.x < 0 then

      rightPlayerScore = rightPlayerScore + 1

      -- Game ends when scores reaches 5
      if rightPlayerScore == 5 then
          stateMachine:change('end')
          winner = "Right"
      else
          stateMachine:change("serve", {
            ['ball'] = self.ball,
            ['leftPlayer'] = self.leftPlayer,
            ['rightPlayer'] = self.rightPlayer
          })
      end

    -- Incrementing left player score when ball goes to the right of screen
  elseif self.ball.x > VIRTUAL_WIDTH then

        leftPlayerScore = leftPlayerScore + 1

        -- Game ends when scores reaches 5
        if leftPlayerScore == 5 then
            stateMachine:change('end')
            winner = "Left"
        else
            stateMachine:change("serve",{
                ['ball'] = self.ball,
                ['leftPlayer'] = self.leftPlayer,
                ['rightPlayer'] = self.rightPlayer
            })
        end

    end

    -- Updating ball if it collides with left player
    if self.ball:hasCollided(self.leftPlayer) then
        self.ball:updateOnCollision('left', self.leftPlayer)
    end

    -- Updating ball if it collides with right player
    if self.ball:hasCollided(self.rightPlayer) then
        self.ball:updateOnCollision('right', self.rightPlayer)
    end

end

function PlayState:render()

    -- White color for ball and paddles
    love.graphics.setColor(255 / 255, 255 / 255, 255 / 255, 255 / 255)

    -- Drawing updated ball, left and right player
    love.graphics.rectangle('fill', 10, self.leftPlayer.y, self.leftPlayer.width, self.leftPlayer.height)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, self.rightPlayer.y, self.rightPlayer.width, self.rightPlayer.height)
    love.graphics.rectangle('fill', self.ball.x, self.ball.y, self.ball.width, self.ball.height)

end
