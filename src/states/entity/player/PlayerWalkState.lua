PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player)
    self.player = player

    self.animation = Animation{
        frames = {1, 2, 3, 2},
        interval = 0.1

    }

    self.player.currentAnimation = self.animation
    
end

function PlayerWalkState:enter(params)
    self.player.currentState = 'walk'
end

function PlayerWalkState:update(dt)
    self.player.currentAnimation:update(dt)

    if not love.keyboard.isDown('left') and not love.keyboard.isDown('right') then
        self.player:changeState('idle')

    else
        --get the tiles at the bottomleft and bottom right corners
        local tileBottomLeft = self.player.map:pointToTile(self.player.x + 1, self.player.y + self.player.height)
        local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 1, self.player.y + self.player.height)

        --temporarily shift player down a pixel to test for game objects
        self.player.y = self.player.y + 1
        local collidedObjects = self.player:checkObjectCollisions()
        self.player.y = self.player.y - 1

        --if no tiles underneath us, fall
        if #collidedObjects == 0 and (tileBottomLeft and tileBottomRight) and (not tileBottomLeft:collidable() and not tileBottomRight:collidable()) then
            self.player.dy = 0
            self.player:changeState('fall')

        elseif love.keyboard.isDown('left') then --if there are tiles, walk
            self.player.x = self.player.x - PLAYER_WALK_SPEED * dt
            self.player.direction = 'left'
            self.player:checkLeftCollisions(dt)

        elseif love.keyboard.isDown('right') then
            self.player.x = self.player.x + PLAYER_WALK_SPEED * dt
            self.player.direction = 'right'
            self.player:checkRightCollisions(dt)
            
        end
    end
    --see if we've collided with any entities, die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            --playe a sound and die
            gSounds['player-hit']:stop()
            gSounds['player-hit']:play()
            gStateMachine:change('start')
        end
    end

    if love.keyboard.wasPressed('space') then
        gSounds['jump']:stop()
        gSounds['jump']:play()
        self.player:changeState('jump', {dy = PLAYER_JUMP_SPEED})
    end

   
end