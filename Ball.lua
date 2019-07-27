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

function Ball:updateOnCollisionWithLeft()
    self.vy = self.vy
    self.vx = -self.vx * 1.05
    self.x = leftPlayerX + PADDLE_WIDTH
end

function Ball:updateOnCollisionWithRight()
    self.vy = self.vy
    self.vx = -self.vx * 1.05
    self.x = rightPlayerX - self.width
end
