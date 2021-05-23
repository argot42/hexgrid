local grid = require "grid"

function love.load()
    --hexradius = 10
    --size = 25

    --hexgrid = grid.new(hexradius, size, size) 
    layout = grid:Layout(grid.layoutFlat, {x=10,y=10}, {x=20,y=20})

end

function love.draw(dt)
    --drawgrid()
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
end

function love.keypressed(key, scancode, isrepeat)
    print(key, scancode, isrepeat)
    if (key == "q") then
        love.event.quit()
    end
end
