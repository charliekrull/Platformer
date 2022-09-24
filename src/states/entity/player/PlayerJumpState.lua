PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation{
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
    
end

function PlayerJumpState:enter(params)
    self.player.currentState = 'jump'
    self.player.dy = PLAYER_JUMP_SPEED
end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)

    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    if self.player.dy >= 0 then
        self.player:changeState('fall')
    end

    --look at the two tiles above the head to check for collisions; 3 pixels of leeway to get through gaps

    local tileTopLeft = self.player.map:pointToTile(self.player.x + 3, self.player.y)
    local tileTopRight = self.player.map:pointToTile(self.player.x + self.player.width - 3, self.player.y)

    --if there is a collision on top, fall

    if (tileTopLeft and tileTopRight) and (tileTopLeft:collidable() or tileTopRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('falling')

    elseif love.keyboard.isDown('left') then
        self.player.direction = 'left'
        self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
        self.player:checkLeftCollisions(dt)

    elseif love.keyboard.isDown('right') then
        self.player.direction = 'right'
        self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
        self.player:checkRightCollisions(dt)
        
    else
        self.player:checkObjectCollisions()
    
    end

    --check here if we've hit any game objects


    --check if we've collided with entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gStateMachine:change('start')
            
        end
    end

end