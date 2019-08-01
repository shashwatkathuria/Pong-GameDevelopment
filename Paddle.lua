Paddle = Class{}

function Paddle:init(x, y, width, height, speed)
    self.x = x
    self.y = y

    self.width = width
    self.height = height

    self.centerY = self.y + ((self.y + self.height) / 2)

    self.speed = speed

    self.score = 0
end

function Paddle:reset(x, y)
    self.x = x
    self.y = y
    self.centerY = self.y + (self.height / 2)
    self.score = 0
end

function Paddle:update(move, dt)
    if move == "moveUp" then
        self.y = self.y - self.speed * dt
    elseif move == "moveDown" then
        self.y = self.y + self.speed * dt
    end

    if self.y >= 0 then
        self.y = math.min(self.y, VIRTUAL_HEIGHT - self.height)
    else
        self.y = 0
    end

    self.centerY = self.y + (self.height / 2)

end
