Tile = Class{}

function Tile:init(x, y, id, tileset)
    --position
    self.x = x
    self.y = y

    self.width = TILE_SIZE
    self.height = TILE_SIZE

    self.id = id
    self.tileset = tileset
end

function Tile:collidable() --see if tile is on the whitelist of collidable id's
    for k, v in pairs(COLLIDABLE_TILES) do
        if v == self.id then
            return true
        end
    end

    return false

end

function Tile:render()
    love.graphics.draw(gTextures['tiles'], gFrames['tilesets'][self.tileset][self.id],
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE )
end