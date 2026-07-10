local npcs = {}

-- Create NPCs at Car Wash Locations
CreateThread(function()
    Wait(1000)
    
    for _, location in ipairs(Config.CarWashLocations) do
        CreateNPC(location)
    end
end)

function CreateNPC(location)
    -- Load model
    local model = GetHashKey(location.npcModel)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    -- Create ped
    local ped = CreatePed(4, model, location.npcCoords.x, location.npcCoords.y, location.npcCoords.z, location.npcHeading, true, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    
    -- Make ped stand
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_STUPOR', 0, true)
    
    table.insert(npcs, ped)
end

-- NPC Interaction
CreateThread(function()
    while true do
        Wait(100)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for _, location in ipairs(Config.CarWashLocations) do
            local distance = #(playerCoords - location.npcCoords)
            
            if distance < 5 then
                TriggerServerEvent('carwash:server:greetPlayer')
            end
        end
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
