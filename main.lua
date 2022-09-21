require 'src/Dependencies'


function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('linear', 'linear')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)


   gStateMachine = StateMachine{
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end
   }
   gStateMachine:change('start')

    love.keyboard.keysPressed = {}

end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true

end

function love.keyboard.wasPressed(key)

    return love.keyboard.keysPressed[key]
end

function love.update(dt)

    gStateMachine:update(dt)

    
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    gStateMachine:render()

    push:finish()
    
end