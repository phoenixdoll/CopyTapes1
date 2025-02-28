local function AddCassetteContextMenu(player, context, items)
    if not items then return end
    if type(items) ~= "table" then items = {items} end

    --check player is valid
    if not player or type(player) ~= "userdata" then
        player = getSpecificPlayer(0)
        if not player then
            print("Error: Player is nil.")
            return
        end
    end

    for _, item in ipairs(items) do
        local itemObj = item
        if not instanceof(item, "InventoryItem") and item.items then
            itemObj = item.items[1]
        end

        -- Extra safety check
        if itemObj then
            local displayName = itemObj:getDisplayName() or ""
            local itemType = itemObj:getType() or ""

            -- Debugging: Print to console
            print("Checking item:", displayName, "| Type:", itemType)
            print(player)
            print(player.getInventory)

            -- Match "Cassette" at the start of the display name (case-insensitive)
            if string.match(displayName, "^[Cc]assette") then
                context:addOption("Erase Cassette", nil, function()
                    -- Ensure player and inventory are valid
                    print("Erase Cassette clicked!")
                    player:getInventory():DoRemoveItem(itemObj)
                    print ("Cassette removed!")

                        -- Add the "Blank Tape" item to the player's inventory
                    local blankTape = InventoryItemFactory.CreateItem("CopyTapes.BlankTape")
                    player:getInventory():AddItem(blankTape)
                    print("Cassette erased and Blank Tape added!")
                end)
            end
        end
    end
end

local function AddCassetteCopyOption(player, context, items)
    if not items then return end
    if type(items) ~= "table" then 
        items = {items} 
    end

    -- Ensure we have a valid player
    if not player or type(player) ~= "userdata" then
        player = getSpecificPlayer(0)
        if not player then
            print("Error: Player is nil.")
            return
        end
    end

    local inventory = player:getInventory()
    -- Only show the option if a blank cassette exists
    local blankTape = inventory:FindAndReturn("CopyTapes.BlankTape")
    if not blankTape then
        return
    end

    for _, item in ipairs(items) do
        local itemObj = item
        if not instanceof(item, "InventoryItem") and item.items then
            itemObj = item.items[1]
        end

        if itemObj then
            local displayName = itemObj:getDisplayName() or ""
            local itemType = itemObj:getType() or ""
            -- Only add the option for cassettes that are not the blank cassette itself
            if string.match(displayName, "^[Cc]assette") and itemType ~= "CopyTapes.BlankTape" then
                context:addOption("Copy Cassette", nil, function()
                    -- Check again that there is a blank cassette available
                    local blank = inventory:FindAndReturn("CopyTapes.BlankTape")
                    if blank then
                        -- Remove one blank cassette from the inventory
                        inventory:RemoveOneOf("CopyTapes.BlankTape")
                        -- Create a new cassette of the same type as the clicked item
                        local newCassette = InventoryItemFactory.CreateItem(itemObj:getType())
                        inventory:AddItem(newCassette)
                        print("Cassette copied!")
                    else
                        print("No blank cassette available.")
                    end
                end)
            end
        end
    end
end


-- Hook our context menu function into the game
Events.OnFillInventoryObjectContextMenu.Add(AddCassetteContextMenu)
Events.OnFillInventoryObjectContextMenu.Add(AddCassetteCopyOption)