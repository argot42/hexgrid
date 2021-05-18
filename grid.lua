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

function grid:Hex(x, y, z)
    assert(not (math.floor (0.5 + x + y + z) ~= 0), "q + r + s must be 0")

    local h = {
        x = x,
        y = y,
        z = z,
    }

    return hex:New(h)
end

function hex:Str()
    return "x = " .. self.x .. ", y = " .. self.y .. ", z = " .. self.z
end

function hex:Print()
    print(self:Str())
end

function hex:Eq(other)
    return self.x == other.x and self.y == other.y and self.z == other.z
end

function hex:Ne(other)
    return not (self:Eq(other))
end

-- arithmetic
function hex:Add(other)
    return grid:Hex(self.x + other.x, self.y + other.y, self.z + other.z)
end

function hex:Sub(other)
    return grid:Hex(self.x - other.x, self.y - other.y, self.z - other.z)
end

function hex:Mul(other)
    return grid:Hex(self.x * other.x, self.y * other.y, self.z * other.z)
end

-- distance
function hex:Len()
    return (math.abs(self.x) + math.abs(self.y) + math.abs(self.z)) / 2
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
    local q = math.floor(self.q)
    local r = math.floor(self.r)
    local s = math.floor(self.s)
    local qdiff = math.abs(q - self.q)
    local rdiff = math.abs(r - self.r)
    local sdiff = math.abs(s - self.s)

    if (qdiff > rdiff and qdiff > sdiff) then
        q = -r - s
    elseif (rdiff > sdiff) then
        r = -q - s
    else
        s = -q - r
    end

    return grid:Hex(q, r, s)
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

function HexLib:Orientation(f0, f1, f2, f3, b0, b1, b2, b3, startAngle)
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

local layoutPointy = HexLib:Orientation(math.sqrt(3.0), math.sqrt(3.0) / 2.0, 0.0, 3.0 / 2.0, math.sqrt(3.0) / 3.0, -1.0 / 3.0, 0.0, 2.0 / 3.0, 0.5)
local layoutFlat = HexLib:Orientation(3.0 / 2.0, 0.0, math.sqrt(3.0) / 2.0, math.sqrt(3.0), 2.0 / 3.0, 0.0, -1.0 / 3.0, math.sqrt(3.0) / 3.0, 0.0)

local layout = {}

function layout:New(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function HexLib:Layout(orientation, size, origin)
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
        y = (p.y - self.origin.y) / self.size.y,
    }
    local q = o.b0 * pt.x + o.b1 * pt.y
    local r = o.b2 * pt.x + o.b3 * pt.y
    return HexLib:Hex(q, r, -q - r)
end

return grid
