Paddle = Class{}

function Paddle:init(x, y, width, height, speed)
    self.x = x
    self.y = y

    self.width = width
    self.height = height

    self.speed = speed

    self.score = 0
end

function Paddle:reset(x, y)
    self.x = x
    self.y = y
end
