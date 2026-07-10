local npcs = {}

-- Create NPCs at Car Wash Locations
CreateThread(function()
    Wait(2000) -- Wait for config to load
    
    if not Config or not Config.CarWashLocations then
        print('^1[CarWash] ERROR: Config not loaded for NPC creation!^7')
        return
    end
    
    for _, location in ipairs(Config.CarWashLocations) do
        CreateNPC(location)
    end
    
    print('^2[CarWash] NPCs created!^7')
end)

function CreateNPC(location)
    -- Load model
    local model = GetHashKey(location.npcModel)
    RequestModel(model)
    
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(model) then
        print('^1[CarWash] ERROR: Failed to load NPC model: ' .. location.npcModel .. '^7')
        return
    end
    
    -- Create ped
    local ped = CreatePed(4, model, location.npcCoords.x, location.npcCoords.y, location.npcCoords.z, location.npcHeading, true, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    
    -- Make ped stand
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STUPOR', 0, true)
    
    table.insert(npcs, ped)
    ReleaseNamedPtfxAsset(model)
end

-- NPC Interaction
CreateThread(function()
    Wait(2000)
    
    while true do
        Wait(100)
        
        if not Config or not Config.CarWashLocations then
            goto continue_npc
        end
        
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, location in ipairs(Config.CarWashLocations) do
            local distance = #(playerCoords - location.npcCoords)
            
            if distance < 5 then
                TriggerServerEvent('carwash:server:greetPlayer')
                break
            end
        end
        
        ::continue_npc::
    end
end)

-- NPC Talk Event
RegisterNetEvent('carwash:client:npcTalk')
AddEventHandler('carwash:client:npcTalk', function(message)
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Car Wash Worker', message}
    })
end)

print('^2[CarWash]^7 NPC System Loaded!')
