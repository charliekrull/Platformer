--[[
    The main menu, the first state we encounter
]]

StartState = Class{__includes = BaseState}




function StartState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['start']:stop()
        gSounds['start']:play()
        gStateMachine:change('play', {levelNum = 1, score = 0})
    end

end

function StartState:render()

    love.graphics.setColor(1, 1, 1)
    for x = 0, VIRTUAL_WIDTH, 640 do
        for y = 0, VIRTUAL_HEIGHT, 480 do
            love.graphics.draw(gTextures['backgrounds'][6], x, y)
        end
    end


    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf('Unnamed Platformer!', 0, VIRTUAL_HEIGHT/2 - 100, VIRTUAL_WIDTH, 'center')
end