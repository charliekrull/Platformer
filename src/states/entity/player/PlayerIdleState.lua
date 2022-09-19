--the player when no buttons are being pressed
PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation{
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
    
end

function PlayerIdleState:enter(params)
    self.player.currentState = 'idle'
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walk')
    end

    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    for k, entity in pairs(self.player.level.entities) do --check for collisions with entities
        if entity:collides(self.player) then
            --[[
                play a sound and die
            ]]
        end
    end
end
