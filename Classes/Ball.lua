-- Initializing Ball class
Ball = Class{}

-- Constructor for ball
function Ball:init(x, y, width, height)

    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.vx = math.random() > 0.5 and 150 or -150
    self.vy = math.random(-300, 300)

end

-- Function to update ball and rebound if required
function Ball:update(dt)

    -- Rebounding on collision with top of screen
    if self.y < 0 then
        self.y = 0
        self.vy = -self.vy

    -- Rebounding on collision with bottom of screen
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
        self.vy = -self.vy
    end

    -- Updating ball's position
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

end

-- Function to check whether ball has collided with paddle
function Ball:hasCollided(paddle)

    -- If the horizontal edges of ball and paddle are away from each other
    -- completely
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
      return false
    end

    -- If the vertical edges of ball and paddle are away from each other
    -- completely
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
      return false
    end

    -- Else there is a collision
    return true

end

-- Function to update ball on collision with paddle
function Ball:updateOnCollision(player, paddle)

    -- Scaling of ball's vy velocity depending upon collision
    -- distance from the center of the paddle
    yOffsetVelocity = 1 + ( math.abs(self.y - paddle.centerY) / paddle.height ) / 2

    self.vy = self.vy * yOffsetVelocity
    self.vx = -self.vx * 1.05

    -- For left player
    if player == "left" then
        -- Setting ball's position to avoid infinite collision
        self.x = paddle.x + paddle.width

    -- For right player
    elseif player == "right" then
        -- Setting ball's position to avoid infinite collision
        self.x = paddle.x - self.width

    end

end
