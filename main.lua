local grid = require "grid"

function love.load()
    --hexradius = 10
    --size = 25

    --hexgrid = grid.new(hexradius, size, size) 
    --layout = grid:Layout(grid.layoutFlat, {x=10,y=10}, {x=20,y=20})
    hexgrid = grid.Grid(5, 2, {x=10, y=10})
end

function love.draw(dt)
    drawgrid()
end

function drawgrid()
    --local jxOffset = hexgrid.rad * -math.tan(math.pi/1.5) 
    --local ixOffset = jxOffset/4
    --local iyOffet = jxOffset * math.sin(math.pi/3)
    --

    --for i=1,hexgrid.size.x do
    --    for j=1,hexgrid.size.y do
    --        love.graphics.push()
    --        
    --        love.graphics.translate(ixOffset + j * jxOffset, i * iyOffet)
    --        love.graphics.line(
    --            hexgrid.hex[1].x, hexgrid.hex[1].y,
    --            hexgrid.hex[2].x, hexgrid.hex[2].y,
    --            hexgrid.hex[3].x, hexgrid.hex[3].y,
    --            hexgrid.hex[4].x, hexgrid.hex[4].y,
    --            hexgrid.hex[5].x, hexgrid.hex[5].y,
    --            hexgrid.hex[6].x, hexgrid.hex[6].y,
    --            hexgrid.hex[1].x, hexgrid.hex[1].y)

    --        love.graphics.pop()
    --    end

    --    ixOffset = -ixOffset
    --end

    local jxOffset = hexgrid.rad * -math.tan(math.pi/1.5) 
    local ixOffset = jxOffset/4
    local iyOffet = jxOffset * math.sin(math.pi/3)

    for i,row in ipairs(hexgrid.grid) do
        for j,hex in ipairs(row) do
            love.graphics.push()

            love.graphics.translate(ixOffset + j * jxOffset, i * iyOffet)
            love.graphics.line(
                hexgrid.vertices[1].x, hexgrid.vertices[1].y,
                hexgrid.vertices[2].x, hexgrid.vertices[2].y,
                hexgrid.vertices[3].x, hexgrid.vertices[3].y,
                hexgrid.vertices[4].x, hexgrid.vertices[4].y,
                hexgrid.vertices[5].x, hexgrid.vertices[5].y,
                hexgrid.vertices[6].x, hexgrid.vertices[6].y,
                hexgrid.vertices[1].x, hexgrid.vertices[1].y)

            love.graphics.pop()
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    print(key, scancode, isrepeat)
    if (key == "q") then
        love.event.quit()
    end
end

function love.mousepressed(x, y, button)
    print(x, y, button)
end
