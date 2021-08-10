tArgs = {...}

local function findInList(list, searchString)
    for _, sName in pairs(list) do
        if string.find(sName, searchString) then
            return sName
        end
    end
end

coffeeSlot = tArgs[1] or 1

playerChest = tArgs[2]
        or findInList(peripheral.getNames(), "xu2:tileplayerchest")
playerChest = peripheral.wrap(playerChest)

bufferChest = tArgs[3]
        or findInList(peripheral.getNames(), "minecraft:chest")
        or findInList(peripheral.getNames(), "actuallyadditions:giantchest")

coffeeMakerName = tArgs[4]
        or findInList(peripheral.getNames(), "actuallyadditions:coffeemachine")
coffeeMaker = peripheral.wrap(coffeeMakerName)

thisTurtle = tArgs[5]
        or findInList(playerChest.getTransferLocations(), "turtle")

local function checkForEmptyCup()
    local currentItem = playerChest.getItemMeta(coffeeSlot)
    if currentItem ~= nil
      and currentItem.name == "actuallyadditions:item_misc"
      and currentItem.damage == 14 then
        return true
    end
    return false
end

local function removeEmptyCup()
    local coffeeMakerCups = coffeeMaker.getItemMeta(2)
    if coffeeMakerCups.count < coffeeMakerCups.maxCount then
        playerChest.pushItems(coffeeMakerName, coffeeSlot, nil, 2)
    else
        playerChest.pushItems(bufferChest, coffeeSlot)
    end
end

local function supplyFullCup(turtleCoffeeSlot)
    playerChest.pullItems(thisTurtle, turtleCoffeeSlot)
end

local function getCoffeeFromMaker()
    if coffeeMaker.getItemMeta(3) then
        coffeeMaker.pushItems(thisTurtle, 3)
        return true
    end
    return false
end

local function checkTurtleForCoffee()
    local turtleCoffeeSlot = nil
    local coffeeCount = 0
    for i = 1, 16 do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil
          and currentItem.name == "actuallyadditions:item_coffee" then
            if coffeeCount == nil then
                turtleCoffeeSlot = i
            end
            coffeeCount = coffeeCount + 1
        end
    end
    return turtleCoffeeSlot, coffeeCount
end

turtle.select(1)

while true do
    local turtleCoffeeSlot, coffeeCount = checkTurtleForCoffee()
    if coffeeCount < 16 then
        getCoffeeFromMaker()
    end
    if turtleCoffeeSlot then
        if checkForEmptyCup() then
            removeEmptyCup()
            supplyFullCup(turtleCoffeeSlot)
            getCoffeeFromMaker()
        end
    else
        os.sleep(0.1)
    end
end
