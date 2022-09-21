PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    --generate level
    self.level = LevelMaker.generate(100, 12)
    self.tileMap = self.level.tileMap


    self.gravityAmount = 6
    
    self.player = Player({
        x = 0, y = 0,
        width = 45, height = 54,
        frameSet = 'playerBlue',
        stateMachine = StateMachine{
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walk'] = function() return PlayerWalkState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['fall'] = function() return PlayerFallState(self.player, self.gravityAmount) end
        },
    

        --get references to tilemap and level
        map = self.tileMap,
        level = self.level
    })

    self:spawnEnemies()

    self.player:changeState('fall')
end

function PlayState:update(dt)
    Timer.update(dt)

    --remove nils from pickups etc
    self.level:clear()
    
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()
    
    if self.player.x <= 0 then
        self.player.x = 0

    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    
    end
end

function PlayState:render()
    love.graphics.push()
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    love.graphics.clear(0, 0, 1)

    self.level:render()
    self.player:render()

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: '.. self.player.score, 0, 0)
end

function PlayState:updateCamera()
    --clamp movement of camera's X between 0 and map bounds
    self.camX = math.max(0,
    math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
    self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

end

function PlayState:spawnEnemies()
    for x = 1, self.tileMap.width do
        local groundFound = false
        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == MID or self.tileMap.tiles[y][x] == UNDERGROUND then
                    groundFound = true

                    if math.random(20) == 1 then
                        
                        local walker 
                        walker = Walker{
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE,
                            frameSet = 'walker',
                            width = 32,
                            height = 44,
                            stateMachine = StateMachine{
                                ['idle'] = function() return WalkerIdleState(self.tileMap, self.player, walker) end,
                                ['move'] = function() return WalkerMoveState(self.tileMap, self.player, walker) end
                            }
                        }

                        walker:changeState('idle', {
                            waitPeriod = math.random(3)
                        })

                        table.insert(self.level.entities, walker)
                    end
                    
                end
            end
        end
    end

end