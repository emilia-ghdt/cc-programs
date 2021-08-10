local tArgs = {...}

if tArgs[7] == nil or tArgs[7] == "true" then
    os.setComputerLabel("The Intern")
end

local function findInList(list, searchString)
    if searchString == nil then
        return nil
    end

    for _, sName in pairs(list) do
        if string.find(sName, searchString) then
            return sName
        end
    end
end

local coffeeSlot = tonumber(tArgs[1]) or 1

local playerChest = findInList(peripheral.getNames(), tArgs[2])
        or findInList(peripheral.getNames(), "xu2:tileplayerchest")
local playerChest = peripheral.wrap(playerChest)

local bufferChestName = findInList(peripheral.getNames(), tArgs[3])
        or findInList(peripheral.getNames(), "minecraft:chest")
        or findInList(peripheral.getNames(), "actuallyadditions:giantchest")
local bufferChest = peripheral.wrap(bufferChestName)

local coffeeMakerName = findInList(peripheral.getNames(), tArgs[4])
        or findInList(peripheral.getNames(), "actuallyadditions:coffeemachine")
local coffeeMaker = peripheral.wrap(coffeeMakerName)

local thisTurtle = findInList(playerChest.getTransferLocations(), tArgs[5])
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
    if coffeeMakerCups == nil
            or coffeeMakerCups.count < coffeeMakerCups.maxCount then
        playerChest.pushItems(coffeeMakerName, coffeeSlot, nil, 2)
    else
        playerChest.pushItems(bufferChestName, coffeeSlot)
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

local function refillCoffeeMaker()
    beansMeta = coffeeMaker.getItemMeta(1)
    if not beansMeta or beansMeta.count < beansMeta.maxCount then
        for i, item in pairs(bufferChest.list()) do
            if item and item.name == "actuallyadditions:item_coffee_beans" then
                bufferChest.pushItems(coffeeMakerName, i, nil, 1)
            end
        end
    end

    emptyCupsMeta = coffeeMaker.getItemMeta(2)
    if not emptyCupsMeta or emptyCupsMeta.count < emptyCupsMeta.maxCount then
        for i, item in pairs(bufferChest.list()) do
            if item and item.name == "actuallyadditions:item_misc"
                    and item.damage == 14 then
                bufferChest.pushItems(coffeeMakerName, i, nil, 2)
            end
        end
    end
end

local function checkTurtleForCoffee()
    local turtleCoffeeSlot = nil
    local coffeeCount = 0
    for i = 1, 16 do
        local currentItem = turtle.getItemDetail(i)
        if currentItem ~= nil
          and currentItem.name == "actuallyadditions:item_coffee" then
            if coffeeCount == 0 then
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
        print("Refilling coffee maker...")
    end
    refillCoffeeMaker()

    if bDebug then
        print("Checking turtle inventory...")
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
