LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileset = math.random(4)

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        local spawnColumn = math.random(5) == 1 and true or false
        local spawnPit = math.random(5) == 1 and true or false

        if spawnColumn then
            for y = 1, 4 do
            table.insert(tiles[y], Tile(x, y, tileID, tileset))
            end

            tileID = MID
            
            for y = 5, height do
                if y > 5 then
                    tileID = UNDERGROUND
                end
                table.insert(tiles[y], Tile(x, y, tileID, tileset))
            end

        elseif spawnPit then
            for y = 1, height do
                table.insert(tiles[y], Tile(x, y, tileID, tileset))
            end
        
        
        else

            for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, tileset)) 
            end

            tileID = MID
            
            for y = 7, height do
                if y > 7 then
                    tileID = UNDERGROUND
                end
                table.insert(tiles[y],
                Tile(x, y, tileID, tileset))
            end

        end



    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end