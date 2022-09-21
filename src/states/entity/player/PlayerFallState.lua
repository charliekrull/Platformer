PlayerFallState = Class{__includes = BaseState}

function PlayerFallState:init(player, gravity)
    self.player = player
    self.gravity = gravity
    self.animation = Animation{
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
    
end

function PlayerFallState:enter(params)
    self.player.currentState = 'fall'
end

function PlayerFallState:update(dt)
    self.player.currentAnimation:update(dt)

    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    --check for collisions below us
    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width -1, self.player.y + self.player.height)

    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        --if there's a collision, stop falling and enter idle or walking state as apporpriate
        self.player.dy = 0

        if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
            self.player:changeState('walk')

        else
            self.player:changeState('idle')
        end

        self.player.y = (tileBottomLeft.y - 1) * TILE_SIZE - self.player.height

    elseif self.player.y > VIRTUAL_HEIGHT then
        --die

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

    --check for object collisions


    --check for entity collisions and kill THEM if necessary
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            self.player.score = self.player.score + 100
            table.remove(self.player.level.entities, k)
        end
    end
end