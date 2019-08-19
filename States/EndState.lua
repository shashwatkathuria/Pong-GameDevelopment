EndState = Class{ __includes = BaseState }

function EndState:update(dt)

    -- Changing state to start on pressing return key
    if love.keyboard.wasPressed('return') then
        stateMachine:change('start')

        -- Resetting all the variables required for scoring
        leftPlayerScore = 0
        rightPlayerScore = 0
        winner = nil

    end
    
end

function EndState:render()

      -- Printing messages specific to end state
      love.graphics.clear(104 / 255, 118 / 255, 140 / 255, 255 / 255)
      love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
      love.graphics.setFont(bigFont)
      love.graphics.printf('GAME END', 0, VIRTUAL_HEIGHT / 2 - 30, VIRTUAL_WIDTH, 'center')
      love.graphics.setFont(smallFont)
      love.graphics.printf(winner .. " Player wins the game!", 0, VIRTUAL_HEIGHT / 2 + 30, VIRTUAL_WIDTH, 'center')
      love.graphics.printf('Press Enter for Rematch', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')

end
