Class = require 'lib/class'

push = require 'lib/push'

Timer = require 'lib/knife/timer'

require 'src/Util'
require 'src/constants'
require 'src/Animation'
require 'src/Entity'
require 'src/GameLevel'
require 'src/Player'
require 'src/StateMachine'
require 'src/Tile'
require 'src/TileMap'
require 'src/Walker'
require 'src/LevelMaker'
require 'src/GameObject'

require 'src/states/BaseState'
require 'src/states/entity/player/PlayerFallState'
require 'src/states/entity/player/PlayerIdleState'
require 'src/states/entity/player/PlayerJumpState'
require 'src/states/entity/player/PlayerWalkState'

require 'src/states/entity/enemies/WalkerIdleState'
require 'src/states/entity/enemies/WalkerMoveState'
require 'src/states/entity/enemies/WalkerFallState'

require 'src/states/game/PlayState'
require 'src/states/game/StartState'

--all the sound files
gSounds = {['jump'] = love.audio.newSource("sounds/Jump.wav", 'static'),
        ['coin'] = love.audio.newSource('sounds/Pickup_Coin.wav', 'static'),
        ['player-hit'] = love.audio.newSource('sounds/Player_Hit.wav', 'static'),
        ['enemy-hit'] = love.audio.newSource('sounds/Enemy_Hit.wav', 'static'),
        ['start'] = love.audio.newSource('sounds/Start.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/Fuzzball Parade.mp3', 'stream') --[["Fuzzball Parade" Kevin MacLeod (incompetech.com)
        Licensed under Creative Commons: By Attribution 4.0 License
        http://creativecommons.org/licenses/by/4.0/]]
        }

--all the fonts in the game 
gFonts = {['large'] = love.graphics.newFont('fonts/Trigram.ttf', 100),
        ['medium'] = love.graphics.newFont('fonts/Trigram.ttf', 50),
        ['small'] = love.graphics.newFont('fonts/Trigram.ttf', 25)}

--the raw images we'll be using
gTextures = {['tiles'] = love.graphics.newImage('graphics/Tilesheet/tilesheet_complete.png'),
    ['backgrounds'] = {['tiled'] = love.graphics.newImage('graphics/Backgrounds/set2_tiles.png')},

    ['playerBlue'] = {['idle'] = {love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_stand.png')},

        ['walk'] = {love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_walk1.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_walk2.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_walk3.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_walk4.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_walk5.png')},

        ['jump'] = {love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_up1.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_up2.png'),
        love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_up3.png')},

        ['fall'] = {love.graphics.newImage('graphics/PNG/Players/Player Blue/playerBlue_fall.png')}
    },

    ['walker'] = {['idle'] = {love.graphics.newImage('graphics/PNG/Enemies/enemyWalking_1.png')},
        ['move'] = {love.graphics.newImage('graphics/PNG/Enemies/enemyWalking_1.png'),
        love.graphics.newImage('graphics/PNG/Enemies/enemyWalking_2.png'),
        love.graphics.newImage('graphics/PNG/Enemies/enemyWalking_3.png')},

        ['fall'] = {love.graphics.newImage('graphics/PNG/Enemies/enemyWalking_1.png')}
    }
}

--the tiles, objects, entites, etc split from tilesheets
gFrames = {['tiles'] = GenerateQuads(gTextures['tiles'], 64, 64),
    
}

gFrames['tilesets'] = GenerateTileSets(gTextures['tiles'], gFrames['tiles'])

--insert tile 109 into each tileset so it can actually display empty space
for k, v in pairs(gFrames['tilesets']) do
    gFrames['tilesets'][k][109] = love.graphics.newQuad(1280, 256, 64, 64, 1408, 768)
end
