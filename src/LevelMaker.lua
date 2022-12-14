LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileset = math.random(4)

    local keySpawned = false
    local lockSpawned = false

    for x = 1, height do
        table.insert(tiles, {})
    end

    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        local spawnColumn = math.random(5) == 1 and true or false
        local spawnPit = math.random(5) == 1 and true or false
        local spawnBush = math.random(10) == 1 and true or false

        if spawnColumn then
            for y = 1, 4 do
                if spawnBush and y == 4 then
                    tileID = math.random(28, 33)
                end
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
            local objHeight = math.random(3, 4)

            if math.random(10) == 1 then -- chance to spawn a coin
                table.insert(objects, GameObject{
                    x = (x - 1) * TILE_SIZE, 
                    y = (objHeight - 1) * TILE_SIZE,
                    width = 64,
                    height = 64,
                    frame = YELLOW_COIN,
                    collidable = true,
                    consumable = true,
                    solid = false,
                    onConsume = function(player)
                        gSounds['coin']:stop()
                        gSounds['coin']:play()
                        player.score = player.score + 100
                    end

                })    
            

            elseif math.random(10) == 2 then --chance to spawn a box
                table.insert(objects, GameObject{
                    x = (x - 1) * TILE_SIZE,
                    y = (objHeight - 1) * TILE_SIZE,
                    width = 64,
                    height = 64,
                    frame = LIGHT_BLOCK,
                    collidable = true,
                    consumable = false,
                    solid = true,
                    hit = false,
                    
                    onCollide = function(obj)
                        if not obj.hit then
                            gSounds['coin-appears']:stop()
                            gSounds['coin-appears']:play()
                            obj.hit = true
                            local coin = GameObject{
                                x = (x - 1) * TILE_SIZE,
                                y = (objHeight - 1) * TILE_SIZE - 1, -- -1 pixel so we don't immediately collide with it
                                width = 64,
                                height = 64,
                                frame = YELLOW_COIN,
                                collidable = false,
                                consumable = true,
                                solid = false,
                                onConsume = function(player)
                                    gSounds['coin']:stop()
                                    gSounds['coin']:play()
                                    player.score = player.score + 100
                                end
                            }

                            Timer.tween(0.1, {[coin] = {y = (objHeight - 2) * TILE_SIZE}})

                            table.insert(objects, coin)
                        end
                    end
                    
                })

            elseif math.random(2) == 1 and not keySpawned then
                keySpawned = true
                local key = GameObject{
                    x = (x - 1) * TILE_SIZE,
                    y = (objHeight - 1) * TILE_SIZE,
                    width = 64,
                    height = 64,
                    frame = GREEN_KEY,
                    consumable = true,
                    onConsume = function(player)
                        for k, obj in pairs(player.level.objects) do
                            if obj.frame == LOCK_BLOCK then
                                local goal = GameObject{
                                    x = obj.x,
                                    y = obj.y,
                                    width = 64,
                                    height = 64,
                                    frame = GREEN_FLAG_RAISED,
                                    consumable = true,
                                    solid = false,
                                    
                                    onConsume = function(player)
                                        gStateMachine:change('play', {levelNum = player.levelNum + 1, score = player.score})
                                    end
                                }
                                table.remove(player.level.objects, k)
                                table.insert(objects, goal)
                            end
                        end
                    
                    end
                }
                table.insert(objects, key)    
            
            end

            if width - x < 6 and not lockSpawned then
                lockSpawned = true
                local lock = GameObject{
                    x = (x - 1) * TILE_SIZE,
                    y = 5 * TILE_SIZE,
                    width = 64,
                    height = 64,
                    frame = LOCK_BLOCK,
                    solid = true
                    
                }

                table.insert(objects, lock)
            end

            for y = 1, 6 do
                if spawnBush and y == 6 then
                    tileID = math.random(28, 33)
                end
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