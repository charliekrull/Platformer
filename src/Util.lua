--[[
    Some Helper functions
]]

function table.slice(tbl, first, last, step)
    local sliced = {}
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

function table.randomChoice(tbl) --returns single random element in tbl
    local choice = tbl[math.random(#tbl)]
    return choice
        
    
end

--gets individual images from a spritesheet/tilesheet
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(x * tilewidth, y * tileheight,
            tilewidth, tileheight, atlas:getDimensions())

            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateTileSets(atlas, quads) --custom function for this game, not very extensible, uses magic numbers
                                        --I'm ok with it because this is a pretty specifically laid out sheet
    local tilesets = {}
    local tableCounter = 0

    for setsY = 1, 4 do
        tilesets[setsY] = {}
        local tileCounter = 1
        for y = 1, 4 do
            for x = 1, 9 do
                tilesets[setsY][tileCounter] = quads[(setsY - 1) * 22 * 3 + (y-1) * 22 + x]
                tileCounter = tileCounter + 1
            end
        end


    end

    return tilesets
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end