CountDownState = Class{ __includes = BaseState }

function CountDownState:init()

    -- Initializing variables required
    self.countdownInterval = 0.7
    self.countdownTime = 0
    self.countdown = 3

end

function CountDownState:update(dt)

    -- Incrementing countdowntime appropriately
    self.countdownTime = self.countdownTime + dt

    -- Countdown algorithm with interval as countdownInterval
    if self.countdownTime > self.countdownInterval then
        self.countdown = self.countdown - 1
        -- Resetting countdown time to closest fractional number
        self.countdownTime = self.countdownTime % self.countdownInterval
    end

end

function CountDownState:render()

    -- Printing countdown
    love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
    love.graphics.setFont(biggestFont)
    love.graphics.printf(tostring(self.countdown), 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')

    -- Changing state to play when countdown is over
    if self.countdown == 0 then
        stateMachine:change('play')
    end

end
