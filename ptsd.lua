-- Position Tracking System Driver
local ptsd = {}

-- Start facing towards postive X,
-- after turnRight() facing towards positive Z,
-- positive Y is up
ptsd.x, ptsd.y, ptsd.z = 0, 0, 0
ptsd.facing = 3
ptsd.fuel = turtle.getFuelLevel()

-- return the current position
function ptsd.getPos()
    return ptsd.x, ptsd.y, ptsd.z
end

-- return the current orientation by the x- and z-axis
function ptsd.getDeltas()
    local deltas = {x = (ptsd.facing - 2) * (ptsd.facing % 2),
                    z = (ptsd.facing - 1) * ((ptsd.facing % 2) - 1)}
    return deltas
end

-- update the fuel level
function ptsd.updateFuel()
    ptsd.fuel = turtle.getFuelLevel()
end

-- move forward
function ptsd.forward()
    ptsd.save()
    result, reason = turtle.forward()
    if result then
        d = ptsd.getDeltas()
        ptsd.x = ptsd.x + d.x
        ptsd.z = ptsd.z + d.z
        ptsd.updateFuel()
    end
    ptsd.save()
    return result, reason
end

-- move up
function ptsd.up()
    ptsd.save()
    result, reason = turtle.up()
    if result then
        ptsd.y = ptsd.y + 1
        ptsd.updateFuel()
    end
    ptsd.save()
    return result, reason
end

-- move down
function ptsd.down()
    ptsd.save()
    result, reason = turtle.down()
    if result then
        ptsd.y = ptsd.y - 1
        ptsd.updateFuel()
    end
    ptsd.save()
    return result, reason
end

function ptsd.turnRight()
    ptsd.save()
    result = turtle.turn
    -- TODO
end

function pstd.save()
    orientation = 0
 
--[[ if fs.exists(".ptsd/ptsd.json") then
    local file = fs.open("ptsd.json", "r")
    content = file.readAll()
    file.close()
    orientation = tonumber(content)
end

if not fs.exists(".ptsd") or not fs.isDir(".ptsd") then
    fs.delete(".ptsd")
    fs.makeDir(".ptsd")
end

for i = 1, 100 do
    if turtle.turnRight() then
        orientation = (orientation + 1) % 4
    end
    file = fs.open(".ptsd/ptsd.json", "w")
    file.write(orientation)
    file.flush()
    file.close()
end ]]--
end
