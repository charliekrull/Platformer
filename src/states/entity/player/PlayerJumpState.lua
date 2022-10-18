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
    self.player.dy = params.dy
end

function PlayerJumpState:update(dt)
    self.player.currentAnimation:update(dt)

    self.player.dy = self.player.dy + self.gravity
    self.player.y = self.player.y + (self.player.dy * dt)

    if self.player.dy >= 0 then
        self.player:changeState('fall')
    end

    --look at the two tiles above the head to check for collisions; 3 pixels of leeway to get through gaps

    local tileTopLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y)
    local tileTopRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y)

    --if there is a collision on top, fall

    if (tileTopLeft and tileTopRight) and (tileTopLeft:collidable() or tileTopRight:collidable()) then
        self.player.dy = 0
        self.player:changeState('fall')

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
    for k, object in pairs(self.player.level.objects) do
        if object:collides(self.player) then
            if object.solid then
                object.onCollide(object)
                self.player.y = object.y + object.height
                self.player.dy = 0
                self.player:changeState('fall')

            elseif object.consumable then
                object.onConsume(self.player)
                table.remove(self.player.level.objects, k)
            
            
            end


        end
    end


    --check if we've collided with entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['player-hit']:stop()
            gSounds['player-hit']:play()
            gStateMachine:change('start')
            
        end
    end

end