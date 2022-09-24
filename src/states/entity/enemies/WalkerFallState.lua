WalkerFallState = Class{__includes = BaseState}

function WalkerFallState:init(tilemap, walker, gravity)
    self.tilemap = tilemap
    self.walker = walker
    self.gravity = gravity

    self.animation = Animation{
        frames = {1},
        interval = 1
    }
    self.currentAnimation = self.animation
end

function WalkerFallState:enter(params)
    self.walker.currentState = 'fall'
end

function WalkerFallState:update(dt)
    self.walker.dy = self.walker.dy + self.gravity
    self.walker.y = self.walker.y + self.walker.dy * dt

    --check if it's hit the ground and transition to moving or idling
    local tileBottomLeft = self.tilemap:pointToTile(self.walker.x, self.walker.y + self.walker.height)
    local tileBottomRight = self.tilemap:pointToTile(self.walker.x + self.walker.width, self.walker.y + self.walker.height)

    if (tileBottomLeft and tileBottomRight) and (tileBottomLeft:collidable() or tileBottomRight:collidable()) then
        local nextState = math.random(2) == 1 and 'move' or 'idle'
        if nextState == 'idle' then
            self.walker:changeState('idle', {waitPeriod = math.random(3)})

        else
            self.walker:changeState('move')
        end
    end
    
end