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
            print(player.inventory)

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

-- Hook the function into the game
Events.OnFillInventoryObjectContextMenu.Add(AddCassetteContextMenu)