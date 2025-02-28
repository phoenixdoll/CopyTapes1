local function AddCassetteContextMenu(player, context, items)
    if not items then return end
    if type(items) ~= "table" then items = {items} end

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

            -- Match "Cassette" at the start of the display name (case-insensitive)
            if string.match(displayName, "^[Cc]assette") then
                context:addOption("Play Cassette", nil, function()
                    print("Cassette option clicked!") -- Replace with actual function
                end)
            end
        end
    end
end

-- Hook the function into the game
Events.OnFillInventoryObjectContextMenu.Add(AddCassetteContextMenu)