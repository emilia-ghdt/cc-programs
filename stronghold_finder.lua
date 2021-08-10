-- the number of rings in which strongholds generate
local nRings = 8

-- the number of strongholds that generate in each ring
local tStrongholds = {3, 6, 10, 15, 21, 28, 36}

-- the minimum and maximum distance a stronghold
-- in a certain ring can have from the origin
local tDistances = {}
for i = 1, 8 do
    tDistances[i] = {min = 192 * i - 112, max = 192 * i - 16}
end

local n = tDistances[#tDistances].max

-- 2D-array of booleans describing whether
-- or not a chunk can contain a stronghold
local ttChunks = {}
for y = -n, n do
    local tChunks = {}
    for x = -n, n do
        local d = math.sqrt(y * y + x * x)
        if round(d) 
    end
end
