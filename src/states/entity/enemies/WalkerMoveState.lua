WalkerMoveState = Class{__includes = BaseState}

function WalkerMoveState:init(tilemap, player, walker)
    self.tilemap = tilemap
    self.player = player
    self.walker = walker
    
    self.animation = Animation{
        frames = {1, 2},
        interval = 0.1
    }

    self.walker.currentAnimation = self.animation

    self.walker.direction = math.random(2) == 1 and 'left' or 'right'
    self.moveDuration = math.random(5)
    self.moveTimer = 0

end

function WalkerMoveState:enter(params)
    self.walker.currentState = 'move'
end

function WalkerMoveState:update(dt)
    self.moveTimer = self.moveTimer + dt
    self.walker.currentAnimation:update(dt)

    --reset movement or maybe go idle if it's moved long enough
    if self.moveTimer > self.moveDuration then
        if math.random(3) == 1 then
            self.walker:changeState('idle', {
                waitPeriod = math.random(3)
            })

        else
            self.walker.direction = math.random(2) == 1 and 'left' or 'right'
            self.moveDuration = math.random(5)
            self.moveTimer = 0
        end

    elseif self.walker.direction == 'left' then
        self.walker.x = self.walker.x - WALKER_MOVE_SPEED * dt

        --switch directions if we collide with a wall or come to an empty space
        local tileLeft = self.tilemap:pointToTile(self.walker.x, self.walker.y)
        local tileBottomLeft = self.tilemap:pointToTile(self.walker.x, self.walker.y + self.walker.height)

        if (tileLeft and tileBottomLeft) and (tileLeft:collidable() or not tileBottomLeft:collidable()) then
            self.walker.x = self.walker.x + WALKER_MOVE_SPEED * dt
            self.walker.direction = 'right'
        end

    else
        self.walker.direction = 'right'
        self.walker.x = self.walker.x + WALKER_MOVE_SPEED * dt

        --switch directions if we come to empty space or collide with a wall
        local tileRight = self.tilemap:pointToTile(self.walker.x + self.walker.width, self.walker.y)
        local tileBottomRight = self.tilemap:pointToTile(self.walker.x + self.walker.width, self.walker.y + self.walker.height)

        if (tileRight and tileBottomRight) and (tileRight:collidable() or not tileBottomRight:collidable()) then
            self.walker.x = self.walker.x - WALKER_MOVE_SPEED * dt
            self.walker.direction = 'left'

        end
    end
end