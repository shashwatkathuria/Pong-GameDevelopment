Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.vx = math.random() > 0.5 and 150 or -150
    self.vy = math.random(-300, 300)

end

function Ball:reset()

    self.vx = math.random() > 0.5 and 150 or -150
    self.vy = math.random(-300, 300)

    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
end

function Ball:updateOnCollision(player, paddle)

    if player == "left" then
        self.vy = self.vy
        self.vx = -self.vx * 1.05
        self.x = paddle.x + paddle.width
    elseif player == "right" then
        self.vy = self.vy
        self.vx = -self.vx * 1.05
        self.x = paddle.x - self.width

    end
end

function Ball:hasCollided(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
      return false
    end
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
      return false
    end

    return true
end

function Ball:update(dt)
    if self.y < 0 then
        self.y = 0
        self.vy = -self.vy
    elseif self.y > VIRTUAL_HEIGHT - self.height then
        self.y = VIRTUAL_HEIGHT - self.height
        self.vy = -self.vy
    end
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
end
