--actual dimensions of our window
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

--change this to change zoom level, the resolution we are emulating with push
VIRTUAL_WIDTH = 1280
VIRTUAL_HEIGHT = 720

PLAYER_WALK_SPEED = 240 --pixels per second
PLAYER_JUMP_SPEED = -540

WALKER_MOVE_SPEED = 180

--size of our tiles in pixels (64 wide, 64 tall)
TILE_SIZE = 64

--tile ID's
TILE_ID_EMPTY = 109 --transparent tile
--ground tiles
UNDERGROUND = 1
LEFT = 2
MID = 3
RIGHT = 4
SINGLE = 5

YELLOW_COIN = 15
LIGHT_BLOCK = 193

COLLIDABLE_TILES = {
    UNDERGROUND, LEFT, MID, RIGHT, SINGLE
}