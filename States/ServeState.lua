ServeState = Class { __includes = BaseState }

function ServeState:init()
    self.ball = nil
    self.leftPlayer = nil
    self.rightPlayer = nil
end

function ServeState:enter(enterParams)
    self.ball = enterParams['ball']
    self.leftPlayer = enterParams['leftPlayer']
    self.rightPlayer = enterParams['rightPlayer']
end

function ServeState:render()
    -- Printing messages specific to serve state, displaying scores
    love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
    love.graphics.setFont(bigFont)
    love.graphics.printf('SCORE', 0, 5, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(biggestFont)
    love.graphics.printf(tostring(self.leftPlayer.score), 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 'center')
    love.graphics.printf(tostring(self.rightPlayer.score), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH / 2, 'center')

    -- Vertical partition in the middle of the screen
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 6, 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Space to Continue', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
    self.ball:reset()
end
