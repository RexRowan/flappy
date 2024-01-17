
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20

    self.spawnInterval = 2
end

function PlayState:update(dt)
    self.timer = self.timer + dt

    if self.timer > self.spawnInterval then
        local gapHeight = math.random(30, 180) 

        table.insert(self.pipePairs, PipePair(self.lastY, gapHeight))

        self.spawnInterval = math.random(2, 4)
        
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end

        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    self.bird:update(dt)

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()

    if gStateMachine:isPaused() then
        love.graphics.draw(pauseIcon, VIRTUAL_WIDTH / 2 - pauseIcon:getWidth() / 2, VIRTUAL_HEIGHT / 2 - pauseIcon:getHeight() / 2)
    end
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end