-- Initializing Paddle class
Paddle = Class{}

-- Constructor for paddle
function Paddle:init(x, y, width, height, speed)
    self.x = x
    self.y = y

    self.width = width
    self.height = height

    self.centerY = self.y + ((self.y + self.height) / 2)

    self.speed = speed

    self.score = 0
end

-- Function to update paddle according to move specified
function Paddle:update(move, dt)

    -- Moving up by required amount
    if move == "moveUp" then
        self.y = self.y - self.speed * dt
    -- Moving down by required amount
    elseif move == "moveDown" then
        self.y = self.y + self.speed * dt
    end

    -- Not letting paddle go below the bottom of screen
    if self.y >= 0 then
        self.y = math.min(self.y, VIRTUAL_HEIGHT - self.height)
    -- Not letting paddle go above the top of screen
    else
        self.y = 0
    end

    -- Updating centreY
    self.centerY = self.y + (self.height / 2)

end

-- Function to reset paddle
function Paddle:reset(x, y)

    -- Resetting required variables
    self.x = x
    self.y = y
    self.centerY = self.y + (self.height / 2)
    self.score = 0
    
end
