
ScoreState = Class{__includes = BaseState}


function ScoreState:enter(params)
    self.score = params.score
    if self.score >= 3 then
        self.medal = love.graphics.newImage('gold_medal.png')
    elseif self.score >= 2 then
        self.medal = love.graphics.newImage('silver_medal.png')
    elseif self.score >= 1 then
        self.medal = love.graphics.newImage('bronze_medal.png')
    end
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')

    if self.medal then
        local yOffset = 20
        love.graphics.draw(self.medal, VIRTUAL_WIDTH / 2 - self.medal:getWidth() / 2, 100 + yOffset)
    end
end