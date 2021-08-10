tArgs = {...}
coffeeSlot = tArgs[1] or 1

if not tArgs[2] then
    for _, sName in pairs(peripheral.getNames()) do
        if string.find(sName, "xu2:tileplayerchest_") then
            playerChestName = sName
        end
    end
else
    playerChestName = tArgs[2]
end
playerChest = peripheral.wrap(playerChestName)

if not tArgs[3] then
    for _, sName in pairs(peripheral.getNames()) do
        if string.find(sName, "actuallyadditions:giantchest_") then
            emptyCupChest = sName
            break
        end
    end
else
    emptyCupChest = tArgs[3]
end

if not tArgs[4] then
    for _, sName in pairs(playerChest.getTransferLocations()) do
        if string.find(sName, "turtle_") then
            this = sName
        end
    end
else
    this = tArgs[4]
end

turtle.select(1)

while true do
    local turtleCoffeeSlot = nil
    for i = 1, 16 do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil
          and currentItem.name == "actuallyadditions:item_coffee" then
            turtleCoffeeSlot = i
            break
        end
    end
    if turtleCoffeeSlot then
        local currentItem = playerChest.getItemMeta(coffeeSlot)
        if currentItem ~= nil
          and currentItem.name == "actuallyadditions:item_misc"
          and currentItem.damage == 14 then
            playerChest.pushItems(emptyCupChest, coffeeSlot)
            playerChest.pullItems(this, turtleCoffeeSlot)
        end
    else
        os.sleep(0.1)
    end
end
