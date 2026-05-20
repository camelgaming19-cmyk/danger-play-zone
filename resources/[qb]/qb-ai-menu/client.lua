local spawnedPeds = {}
local menuPool = nil
local mainMenu = nil
local isMenuOpen = false
local QBCore = nil
local initialized = false

CreateThread(function()
    print("^2[qb-ai-menu] Starting initialization...^7")
    
    -- Wait longer for QBCore to load
    local timeout = 0
    while not initialized and timeout < 200 do
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj)
                if obj then
                    QBCore = obj
                    initialized = true
                end
            end)
        end
        
        Wait(50)
        timeout = timeout + 1
        
        if timeout == 50 then
            print("^3[qb-ai-menu] Waiting for QBCore (50)...^7")
        elseif timeout == 100 then
            print("^3[qb-ai-menu] Waiting for QBCore (100)...^7")
        elseif timeout == 150 then
            print("^3[qb-ai-menu] Waiting for QBCore (150)...^7")
        end
    end
    
    if not initialized then
        print("^1[qb-ai-menu] ERROR: QBCore not found after long timeout!^7")
        print("^1[qb-ai-menu] Ensure your server.cfg has:^7")
        print("^1[qb-ai-menu]   ensure qb-core^7")
        print("^1[qb-ai-menu]   ensure qb-ai-menu^7")
        return
    end
    
    print("^2[qb-ai-menu] QBCore loaded successfully!^7")
    
    -- Create menu
    mainMenu = CreateAIMenu()
    
    print("^2[qb-ai-menu] Menu created successfully!^7")
    print("^2[qb-ai-menu] Press T to open the menu!^7")
    
    -- Menu loop
    CreateThread(function()
        while true do
            Wait(0)
            
            if isMenuOpen then
                ProcessMenuInput()
            end
            
            -- Keybind: T to open menu
            if IsControlJustPressed(0, 167) then
                isMenuOpen = not isMenuOpen
                if isMenuOpen then
                    print("^2[qb-ai-menu] Menu opened^7")
                else
                    print("^3[qb-ai-menu] Menu closed^7")
                end
            end
        end
    end)
end)

function CreateAIMenu()
    local menu = {
        title = "~b~AI MENU",
        subtitle = "~g~NPC SYSTEM",
        items = {},
        currentPage = 1,
        selected = 1
    }
    
    -- Spawn NPC Items
    table.insert(menu.items, {
        label = "~g~[SPAWN]~s~ Guard",
        model = "s_m_m_security_01",
        type = "spawn"
    })
    
    table.insert(menu.items, {
        label = "~g~[SPAWN]~s~ Cop",
        model = "a_m_m_business_1",
        type = "spawn"
    })
    
    table.insert(menu.items, {
        label = "~g~[SPAWN]~s~ Civilian",
        model = "a_m_m_business_2",
        type = "spawn"
    })
    
    table.insert(menu.items, {
        label = "~g~[SPAWN]~s~ Mechanic",
        model = "a_m_m_business_3",
        type = "spawn"
    })
    
    -- Management Items
    table.insert(menu.items, {
        label = "~r~[DELETE]~s~ Last NPC",
        type = "deleteLastPed"
    })
    
    table.insert(menu.items, {
        label = "~r~[DELETE]~s~ All NPCs",
        type = "deleteAllPeds"
    })
    
    -- Info Items
    table.insert(menu.items, {
        label = "~b~[INFO]~s~ NPC Count",
        type = "info"
    })
    
    return menu
end

function ProcessMenuInput()
    -- Display menu
    DisplayMenu(mainMenu)
    
    -- Navigation
    if IsControlJustPressed(0, 172) then -- Arrow Up
        mainMenu.selected = mainMenu.selected - 1
        if mainMenu.selected < 1 then
            mainMenu.selected = #mainMenu.items
        end
        PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
    end
    
    if IsControlJustPressed(0, 173) then -- Arrow Down
        mainMenu.selected = mainMenu.selected + 1
        if mainMenu.selected > #mainMenu.items then
            mainMenu.selected = 1
        end
        PlaySoundFrontend(-1, "CONFIRM_BEEP", "HUD_MINI_GAME_SOUNDSET", true)
    end
    
    -- Select Item
    if IsControlJustPressed(0, 38) then -- ENTER
        local item = mainMenu.items[mainMenu.selected]
        HandleMenuSelection(item)
        PlaySoundFrontend(-1, "SELECT", "HUD_MINI_GAME_SOUNDSET", true)
    end
    
    -- Close menu with T
    if IsControlJustPressed(0, 167) then
        isMenuOpen = false
    end
end

function DisplayMenu(menu)
    local y = 0.15
    local x = 0.01
    
    -- Title Background
    DrawRect(x + 0.12, y, 0.25, 0.05, 0, 0, 0, 200)
    DrawRect(x + 0.12, y, 0.25, 0.05, 0, 150, 200, 50)
    
    -- Title Text
    DrawText(menu.title, x + 0.005, y - 0.015, 0.5, 0.5, true)
    DrawText(menu.subtitle, x + 0.005, y + 0.005, 0.3, 0.3, true)
    
    y = y + 0.08
    
    -- Menu Items
    for i = 1, #menu.items do
        local item = menu.items[i]
        local itemY = y + (i - 1) * 0.04
        
        if i == menu.selected then
            -- Highlight selected item
            DrawRect(x + 0.12, itemY, 0.25, 0.035, 255, 100, 0, 200)
            DrawRect(x + 0.12, itemY, 0.25, 0.035, 255, 150, 0, 100)
        else
            DrawRect(x + 0.12, itemY, 0.25, 0.035, 0, 0, 0, 150)
            DrawRect(x + 0.12, itemY, 0.25, 0.035, 100, 100, 100, 50)
        end
        
        DrawText(item.label, x + 0.005, itemY - 0.0075, 0.35, 0.35, false)
    end
    
    -- Footer Info
    local footerY = y + (#menu.items * 0.04) + 0.01
    DrawRect(x + 0.12, footerY, 0.25, 0.03, 0, 0, 0, 150)
    DrawText("^2[T]^s~ Toggle | ^3[ENTER]^s~ Select", x + 0.005, footerY - 0.008, 0.25, 0.25, false)
end

function DrawText(text, x, y, scaleX, scaleY, centered)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextScale(scaleX, scaleY)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(centered or false)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function HandleMenuSelection(item)
    if item.type == "spawn" then
        SpawnPed(item.model)
    elseif item.type == "deleteLastPed" then
        DeleteLastPed()
    elseif item.type == "deleteAllPeds" then
        DeleteAllPeds()
    elseif item.type == "info" then
        ShowNPCCount()
    end
end

function SpawnPed(modelName)
    local model = GetHashKey(modelName)
    
    RequestModel(model)
    local timeout = 0
    
    while not HasModelLoaded(model) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"AI Menu", "Failed to load model!"}
        })
        print("^1[qb-ai-menu] Failed to load model: " .. modelName .. "^7")
        return
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    local ped = CreatePed(4, model, coords.x + 2, coords.y + 2, coords.z, heading, true, false)
    
    SetBlockingOfNonTemporaryEvents(ped, true)
    
    table.insert(spawnedPeds, ped)
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {"AI Menu", "NPC Spawned! Total: " .. #spawnedPeds}
    })
    
    print("^2[qb-ai-menu] NPC spawned (" .. modelName .. ") - Total: " .. #spawnedPeds .. "^7")
    
    ReleaseModel(model)
end

function DeleteLastPed()
    if #spawnedPeds > 0 then
        local ped = table.remove(spawnedPeds)
        if DoesEntityExist(ped) then
            DeleteEntity(ped)
        end
        
        TriggerEvent('chat:addMessage', {
            color = {255, 100, 0},
            multiline = true,
            args = {"AI Menu", "NPC Deleted! Remaining: " .. #spawnedPeds}
        })
        print("^3[qb-ai-menu] NPC deleted - Remaining: " .. #spawnedPeds .. "^7")
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {"AI Menu", "No NPCs to delete!"}
        })
    end
end

function DeleteAllPeds()
    for i = 1, #spawnedPeds do
        if DoesEntityExist(spawnedPeds[i]) then
            DeleteEntity(spawnedPeds[i])
        end
    end
    
    local count = #spawnedPeds
    spawnedPeds = {}
    
    TriggerEvent('chat:addMessage', {
        color = {255, 0, 0},
        multiline = true,
        args = {"AI Menu", "All " .. count .. " NPCs deleted!"}
    })
    print("^1[qb-ai-menu] All " .. count .. " NPCs deleted^7")
end

function ShowNPCCount()
    TriggerEvent('chat:addMessage', {
        color = {0, 100, 255},
        multiline = true,
        args = {"AI Menu", "Total NPCs Spawned: " .. #spawnedPeds}
    })
    print("^5[qb-ai-menu] Total NPCs: " .. #spawnedPeds .. "^7")
end

-- Exports for external access
exports('GetSpawnedPeds', function()
    return spawnedPeds
end)

exports('SpawnPed', function(model)
    SpawnPed(model)
end)

exports('DeleteAllPeds', function()
    DeleteAllPeds()
end)
