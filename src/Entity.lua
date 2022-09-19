--[[
    An entity in the game, like a player or enemy, which inherit from this class
]]

Entity = Class{}

function Entity:init(def)
    --position
    self.x = def.x
    self.y = def.y

    --velocity
    self.dx = 0
    self.dy = 0

    --dimensions (for calculating collisions)
    self.width = def.width
    self.height = def.height

    self.stateMachine = def.stateMachine
    self.currentState = def.currentState
    self.frameSet = def.frameSet --[[since I'm not parsing that cluster of a spritesheet and I don't know how
                                    to use the XML file yet, this is the table in gTextures that holds the animation frames]]

    self.direction = 'left'

    --reference to the tile map so we can check collisions
    self.map = def.map

    --reference to level for tests against other entities and objects
    self.level = def.level
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:collides(entity) --function for determining if two entities collide, not to be confused with tileset collision which is in Player
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)

end

function Entity:render()
    love.graphics.draw(gTextures[self.frameSet][self.currentState][self.currentAnimation:getCurrentFrame()], --self.currentAnimation will be set in each state 
        math.floor(self.x+ gTextures[self.frameSet][self.currentState][self.currentAnimation:getCurrentFrame()]:getWidth()/2), --x position offset appropriately (d/t origin offset below)
        math.floor(self.y), --y position
        0, --rotation
        self.direction == 'left' and -1 or 1, --x scale/mirroring
        1,
        gTextures[self.frameSet][self.currentState][self.currentAnimation:getCurrentFrame()]:getWidth()/2, --x origin offset
        1  --y origin offset for mirroring
    )
    
    
end