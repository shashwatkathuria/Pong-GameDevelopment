StartState = Class{ __includes = BaseState }

function StartState:update(dt)

    -- Changing state to countdown when space is pressed
    if love.keyboard.wasPressed('space') then
        stateMachine:change('countdown')
    end

end

function StartState:render()

    -- Printing messages specific to start state
    love.graphics.setColor(224 / 255, 201 / 255, 70 / 255, 255 / 255)
    love.graphics.setFont(bigFont)
    love.graphics.printf('WELCOME  TO  PONG', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Press Space to Start', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
    
end
