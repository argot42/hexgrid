local grid = {}

function grid.new(rad, xsize, ysize)
    local g = {
        rad = rad,
        hex = {},
        size = {
            x = xsize,
            y = ysize,
        },
    }

    for i=1,6 do
        local dir = math.pi/3 * (i+0.5)

        g.hex[i] = {}
        g.hex[i].x = g.rad * math.cos(dir)
        g.hex[i].y = g.rad * math.sin(dir)
    end
    
    return g
end

return grid
