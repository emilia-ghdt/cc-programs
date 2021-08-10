local tArgs = {...}

local function findInList(list, searchString)
    for _, sName in pairs(list) do
        if string.find(sName, searchString) then
            return sName
        end
    end
end

local coffeeSlot = tArgs[1] or 1

local playerChest = tArgs[2]
        or findInList(peripheral.getNames(), "xu2:tileplayerchest")
local playerChest = peripheral.wrap(playerChest)

local bufferChest = tArgs[3]
        or findInList(peripheral.getNames(), "minecraft:chest")
        or findInList(peripheral.getNames(), "actuallyadditions:giantchest")

local coffeeMakerName = tArgs[4]
        or findInList(peripheral.getNames(), "actuallyadditions:coffeemachine")
local coffeeMaker = peripheral.wrap(coffeeMakerName)

local thisTurtle = tArgs[5]
        or findInList(playerChest.getTransferLocations(), "turtle")

local bDebug = tArgs[6] or false

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
    if bDebug then
        print("Checking turtle inventory")
    end
    local turtleCoffeeSlot, coffeeCount = checkTurtleForCoffee()
    if coffeeCount < 16 then
        if bDebug then
            print("Free slot detected, retrieving coffee from coffee maker...")
        end
        getCoffeeFromMaker()
    end
    if turtleCoffeeSlot then
        if bDebug then
            print("Coffee present in turtle inventory")
            print("Detecting empty cup...")
        end
        if checkForEmptyCup() then
            if bDebug then
                print("Empty cup detected!")
                print("Removing empty cup...")
            end
            removeEmptyCup()
            if bDebug then
                print("Inserting full cup...")
            end
            supplyFullCup(turtleCoffeeSlot)
            if bDebug then
                print("Refilling inventory from Coffee Maker...")
            end
            getCoffeeFromMaker()
        end
    else
        if bDebug then
            print("No coffee found")
        end
        os.sleep(0.1)
    end
end
