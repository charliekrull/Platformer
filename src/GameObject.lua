--[[
    An object like a gem or a switch or a key, as opposed to an enemy or NPC, which are entities
]]

GameObject = Class{}

function GameObject:init(def)
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height
    self.frame = def.frame --the image of the complete texture to use

    self.collidable = def.collidable
    self.consumable = def.consumable
    self.solid = def.solid
    self.onCollide = def.onCollide
    self.onConsume = def.onConsume
    self.hit = def.hit
    
end

function GameObject:collides(target)
    return not (target.x > self.x + self.width or self.x > target.x + target.width or
            target.y > self.y + self.height or self.y > target.y + target.height)
end

function GameObject:update(dt)

end

function GameObject:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tiles'][self.frame], self.x, self.y)
end