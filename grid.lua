local grid = {}

--
-- Hexagon
--
local hex = {}

function hex:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grid:Hex(q, r, s)
    assert(not (math.floor (0.5 + q + r + s) ~= 0), "q + r + s must be 0")

    local h = {
        q = q,
        r = r,
        s = s,
    }

    return hex:New(h)
end

function hex:Str()
    return "q = " .. self.q .. ", r = " .. self.r .. ", s = " .. self.s
end

function hex:Print()
    print(self:Str())
end

function hex:Eq(other)
    return self.q == other.q and self.r == other.r and self.s == other.s
end

function hex:Ne(other)
    return not (self:Eq(other))
end

-- arithmetic
function hex:Add(other)
    return grid:Hex(self.q + other.q, self.r + other.r, self.s + other.s)
end

function hex:Sub(other)
    return grid:Hex(self.q - other.q, self.r - other.r, self.s - other.s)
end

function hex:Mul(other)
    return grid:Hex(self.q * other.q, self.r * other.r, self.s * other.s)
end

-- distance
function hex:Len()
    return (math.abs(self.q) + math.abs(self.r) + math.abs(self.s)) / 2
end

function hex:Dis(other)
    local diff = self:Sub(other)
    return diff:Len()
end

-- neighbors
local hexDirections = {
    grid:Hex(1, 0, -1), grid:Hex(1, -1, 0), grid:Hex(0, -1, 1),
    grid:Hex(-1, 0, 1), grid:Hex(-1, 1, 0), grid:Hex(0, 1, -1),
}

function grid:direction(dir)
    assert(0 <= dir and dir < 6, "0 <= dir < 6")
    return hexDirections[dir]
end

function hex:Neighbor(dir)
    return self:Add(grid:direction(dir))
end

-- round
function hex:Round()
    local x = math.floor(self.q)
    local y = math.floor(self.r)
    local z = math.floor(self.s)
    local xdiff = math.abs(x - self.q)
    local ydiff = math.abs(y - self.r)
    local zdiff = math.abs(z - self.s)

    if (xdiff > ydiff and xdiff > sdiff) then
        x = -y - z
    elseif (rdiff > sdiff) then
        y = -x - z
    else
        z = -x - y
    end

    return grid:Hex(x, y, z)
end

--
-- Layout
--

local orientation = {}

function orientation:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grid:Orientation(f0, f1, f2, f3, b0, b1, b2, b3, startAngle)
    local o = {
        f0 = f0,
        f1 = f1,
        f2 = f2,
        f3 = f3,
        b0 = b0,
        b1 = b1,
        b2 = b2,
        b3 = b3,
        startAngle = startAngle,
    }
    return orientation:New(o)
end

function orientation:Str()
    local f = "f0 = " .. self.f0 .. ", f1 = " .. self.f1 .. ", f2 = " .. self.f2 .. ", f3 = " .. self.f3
    local b = ", b0 = " .. self.b0 .. ", b1 = " .. self.b1 .. ", b2 = " .. self.b2 .. ", b3 = " .. self.b3
    local sa = ", startAngle = " .. self.startAngle
    return f .. b .. sa
end

function orientation:Print()
    print(self:Str())
end

grid.layoutPointy = grid:Orientation(math.sqrt(3.0), math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, math.sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
grid.layoutFlat = grid:Orientation(3.0 / 2.0, 0.0, math.sqrt(3.0) / 2.0, math.sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, math.sqrt(3.0) / 3.0, 0.0)

local layout = {}

function layout:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function grid:Layout(orientation, size, origin)
    assert(size ~= nil or size.x ~= nil or size.y ~= nil, "size should be a point {x=0, y=0}")
    assert(origin ~= nil or origin.x ~= nil or origin.y ~= nil, "origin should be a point {x=0, y=0}")
     
    local l = {
        orientation = orientation,
        size = size,
        origin = origin,
    }

    return layout:New(l)
end

function layout:Str()
    local orientation = "{" .. self.orientation:Str() .. "}, "
    local size = "{x=" .. self.size.x .. ", y=" .. self.size.y .. "}, "
    local origin = "{x=" .. self.origin.x .. ", y=" .. self.origin.y .. "}" 
    return orientation .. size .. origin
end

function layout:Print()
    print(self:Str())
end

--
-- Hex to screen
--
function hex:Pix(layout)
    local o = layout.orientation
    local x = (o.f0 * self.q + o.f1 * self.r) * layout.size.x
    local y = (o.f2 * self.q + o.f3 * self.r) * layout.size.y
    return {
        x = x + layout.origin.x,
        y = y + layout.origin.y,
    }
end


--
-- screen to hex
--
function layout:Hex(p)
    local o = self.orientation
    local pt = {
        x = (p.x - self.origin.x) / self.size.x,
        y = (p.y - self.origin.r) / self.size.y,
    }
    local x = o.b0 * pt.x + o.b1 * pt.y
    local y = o.b2 * pt.x + o.b3 * pt.y
    return grid:Hex(x, y, -x - y)
end

--
-- grid creation
--

function grid.Grid(hexrad, size, start)
    assert(hexrad > 0, "hexradius > 0")
    assert(size > 0, "size > 0")
    assert(start ~= nil or start.x ~= nil or start.y ~= nil, "start should be a point {x,y}")
    
    local hexgrid = {}

    hexgrid.rad = hexrad
    hexgrid.layout = grid:Layout(grid.layoutFlat, start, {x=size, y=size})

    -- q = x
    -- r = y
    -- s = z
    hexgrid.grid = {}
    local i = 1
    for s=-size,size do
        hexgrid.grid[i] = {}

        if s <= 0 then
            for q=(-i+1),size do
                table.insert(hexgrid.grid[i], grid:Hex(q, -(q+s), s))
            end
        else
            for q=-size,size - (i % (size + 1)) do
                table.insert(hexgrid.grid[i], grid:Hex(q, -(q+s), s))
            end
        end

        i = i + 1
    end

    hexgrid.vertices = {}
    for i=1,6 do
        local dir = math.pi/3 * (i+0.5)

        hexgrid.vertices[i] = {}
        hexgrid.vertices[i].x = hexrad * math.cos(dir)
        hexgrid.vertices[i].y = hexrad * math.sin(dir)
    end

    return hexgrid
end

function printGrid(g)
    for i,row in ipairs(g) do
        print("row -> " .. i)

        for j,h in ipairs(row) do
            h:Print()
        end
    end
end
return grid
