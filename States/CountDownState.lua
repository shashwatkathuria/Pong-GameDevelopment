CountDownState = Class{ __includes = BaseState }

function CountDownState:init()
    self.countdownInterval = 0.7
    self.countdownTime = 0
    self.countdown = 3
end

function CountDownState:update(dt)
    countdownTime = countdownTime + dt

    -- Countdown algorithm with interval as countdownInterval
    if countdownTime > countdownInterval then
        countdown = countdown - 1
        countdownTime = countdownTime % countdownInterval
    end
end

function CountDownState:render()
    -- Printing countdown
    love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
    love.graphics.setFont(biggestFont)
    love.graphics.printf(tostring(self.countdown), 0, VIRTUAL_HEIGHT / 2 - 24, VIRTUAL_WIDTH, 'center')

    -- Starting game when countdown is over
    if self.countdown == 0 then
        GAME_STATE = "play"
    end
end
