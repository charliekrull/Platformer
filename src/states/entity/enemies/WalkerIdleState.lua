WalkerIdleState = Class{__includes = BaseState}

function WalkerIdleState:init(tilemap, player, walker)
    self.tilemap = tilemap
    self.player = player
    self.walker = walker

    self.waitTimer = 0
    self.animation = Animation{
        frames = {1},
        interval = 1
    }

    self.walker.currentAnimation = self.animation
end

function WalkerIdleState:enter(params)
    self.walker.currentState = 'idle'
    self.waitPeriod = params.waitPeriod
end

function WalkerIdleState:update(dt)
    if self.waitTimer < self.waitPeriod then
        self.waitTimer = self.waitTimer + dt

    else
        self.walker:changeState('move')
    end
end