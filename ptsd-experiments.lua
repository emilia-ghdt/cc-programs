sPath = "/.ptsd/ptsd.data"

if fs.exists(sPath) then
    local file = fs.open(sPath, "r")
    sContent = file.readAll()
    file.close()
    nOrientation = tonumber(content)
end

if not fs.exists(".ptsd") or not fs.isDir(".ptsd") then
    fs.delete(".ptsd")
    fs.makeDir(".ptsd")
end

for i = 1, 100 do
    file = fs.open(".ptsd/ptsd.json", "w")
    file.write(orientation)
    file.flush()
    file.close()
    if turtle.turnRight() then
        orientation = (orientation + 1) % 4
    end
end
