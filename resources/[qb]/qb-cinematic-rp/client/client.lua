-- ============================================
-- CINEMATIC RP - Main Client Script
-- Gangs, Police, Missions & Advanced AI
-- ============================================

local spawnedNPCs = {}
local spawnedVehicles = {}
local targetPed = nil
local nearbyNPCs = {}
local QBCore = nil
local gameActive = false

-- Initialize QBCore
CreateThread(function()
    print("^2[Cinematic RP] v1.0.0 Initializing...^7")
    Wait(500)
    
    -- Try to get QBCore
    TriggerEvent('QBCore:GetObject', function(obj)
        QBCore = obj
    end)
    
    Wait(1000)
    
    if QBCore then
        print("^2[Cinematic RP] QBCore loaded successfully!^7")
    else
        print("^3[Cinematic RP] Running in standalone mode (QBCore not found)^7")
    end
    
    print("^2[Cinematic RP] Spawning NPCs and vehicles...^7")
    SpawnAllNPCs()
    SpawnAllVehicles()
    
    gameActive = true
    
    print("^2[Cinematic RP] System Ready!^7")
    print("^2[Cinematic RP] Press E to target NPC | F to kidnap | G for police chase^7")
    
    -- Main game loop
    MainGameLoop()
end)

-- ==================== NPC SPAWNING ====================
function SpawnAllNPCs()
    for i, spawnData in ipairs(Config.NPCSpawns) do
        CreateThread(function()
            Wait(i * 100)
            SpawnNPC(spawnData)
        end)
    end
    print("^2[Cinematic RP] Spawning " .. #Config.NPCSpawns .. " NPCs...^7")
end

function SpawnNPC(spawnData)
    local model = spawnData.model or Utils.RandomTable(Config.NPCModels)
    local modelHash = GetHashKey(model)
    
    RequestModel(modelHash)
    local timeout = 0
    
    while not HasModelLoaded(modelHash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(modelHash) then
        print("^1[Cinematic RP] Failed to load NPC model: " .. model .. "^7")
        return
    end
    
    -- Create the PED
    local ped = CreatePed(4, modelHash, spawnData.x, spawnData.y, spawnData.z, spawnData.heading, true, false)
    
    if not DoesEntityExist(ped) then
        print("^1[Cinematic RP] Failed to create NPC entity!^7")
        ReleaseModel(modelHash)
        return
    end
    
    -- Configure NPC
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedFleeAttributes(ped, 0, false)
    SetEntityHealth(ped, 200)
    
    -- Give weapon if armed
    if spawnData.armed then
        local weapon = Utils.RandomTable(Config.Weapons)
        GiveWeaponToPed(ped, GetHashKey(weapon), 250, false, true)
    end
    
    -- Store NPC data
    local npcData = {
        entity = ped,
        model = model,
        faction = spawnData.faction,
        gang = spawnData.gang,
        job = spawnData.job,
        rank = spawnData.rank,
        type = spawnData.type,
        armed = spawnData.armed,
        state = 'idle',
        target = nil,
        lastUpdate = GetGameTimer(),
        spawnCoords = {x = spawnData.x, y = spawnData.y, z = spawnData.z},
        heading = spawnData.heading,
    }
    
    table.insert(spawnedNPCs, npcData)
    ReleaseModel(modelHash)
end

-- ==================== VEHICLE SPAWNING ====================
function SpawnAllVehicles()
    for i, vehicleData in ipairs(Config.VehicleSpawns) do
        CreateThread(function()
            Wait(i * 100)
            SpawnVehicle(vehicleData)
        end)
    end
    print("^2[Cinematic RP] Spawning " .. #Config.VehicleSpawns .. " vehicles...^7")
end

function SpawnVehicle(vehicleData)
    local modelHash = GetHashKey(vehicleData.model)
    
    RequestModel(modelHash)
    local timeout = 0
    
    while not HasModelLoaded(modelHash) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end
    
    if not HasModelLoaded(modelHash) then
        print("^1[Cinematic RP] Failed to load vehicle model: " .. vehicleData.model .. "^7")
        return
    end
    
    local vehicle = CreateVehicle(modelHash, vehicleData.x, vehicleData.y, vehicleData.z, vehicleData.heading, true, false)
    
    if not DoesEntityExist(vehicle) then
        print("^1[Cinematic RP] Failed to create vehicle entity!^7")
        ReleaseModel(modelHash)
        return
    end
    
    -- Damage windows for realism
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    
    local vehicleData = {
        entity = vehicle,
        model = vehicleData.model,
        faction = vehicleData.faction,
        gang = vehicleData.gang,
        job = vehicleData.job,
        driver = nil,
    }
    
    table.insert(spawnedVehicles, vehicleData)
    ReleaseModel(modelHash)
end

-- ==================== MAIN GAME LOOP ====================
function MainGameLoop()
    CreateThread(function()
        while gameActive do
            Wait(100)
            
            -- Update NPC behaviors
            UpdateNPCBehaviors()
            
            -- Handle keybinds
            HandleKeybinds()
            
            -- Update nearby NPCs
            UpdateNearbyNPCs()
        end
    end)
end

-- ==================== NPC BEHAVIOR SYSTEM ====================
function UpdateNPCBehaviors()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            -- Random scenario behavior
            if GetGameTimer() - npcData.lastUpdate > 15000 then
                local scenario = Utils.RandomTable(Config.Animations.scenarios)
                TaskStartScenarioInPlace(npcData.entity, scenario, 0, true)
                npcData.lastUpdate = GetGameTimer()
            end
            
            -- Check if NPC should be despawned
            local distance = Utils.GetDistance3D(playerCoords, GetEntityCoords(npcData.entity))
            if distance > Config.Settings.despawnDistance then
                if DoesEntityExist(npcData.entity) then
                    DeleteEntity(npcData.entity)
                end
            end
        end
    end
end

-- ==================== KEYBIND HANDLING ====================
function HandleKeybinds()
    -- E to target NPC
    if IsControlJustPressed(0, 38) then
        TargetNearestNPC()
    end
    
    -- F to kidnap
    if IsControlJustPressed(0, 47) then
        if targetPed then
            InitiateKidnap(targetPed)
        end
    end
    
    -- G for police chase
    if IsControlJustPressed(0, 47) then
        TriggerPoliceChase()
    end
    
    -- H for gang war
    if IsControlJustPressed(0, 74) then
        TriggerGangWar()
    end
end

-- ==================== TARGETING SYSTEM ====================
function TargetNearestNPC()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local closestDistance = 100.0
    local closestNPC = nil
    
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            local npcCoords = GetEntityCoords(npcData.entity)
            local distance = Utils.GetDistance3D(playerCoords, npcCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestNPC = npcData.entity
                targetPed = closestNPC
            end
        end
    end
    
    if closestNPC then
        Utils.Notify('Target', '✅ Target acquired! Distance: ' .. math.floor(closestDistance) .. 'm', 'success')
    else
        Utils.Notify('Target', '❌ No NPCs nearby!', 'error')
    end
end

-- ==================== NEARBY NPCs ====================
function UpdateNearbyNPCs()
    local playerCoords = GetEntityCoords(PlayerPedId())
    nearbyNPCs = {}
    
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            local distance = Utils.GetDistance3D(playerCoords, GetEntityCoords(npcData.entity))
            if distance < 50.0 then
                table.insert(nearbyNPCs, {data = npcData, distance = distance})
            end
        end
    end
end

-- ==================== KIDNAP SYSTEM ====================
function InitiateKidnap(targetPed)
    if not DoesEntityExist(targetPed) then return end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local targetCoords = GetEntityCoords(targetPed)
    local distance = Utils.GetDistance3D(playerCoords, targetCoords)
    
    if distance > 5.0 then
        Utils.Notify('Kidnap', '⚠️ Target too far away!', 'error')
        return
    end
    
    Utils.Notify('Kidnap', '🚨 KIDNAPPING IN PROGRESS...', 'error')
    
    -- Animation sequence
    local dict = 'nonmission_rowdy'
    RequestAnimDict(dict)
    
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    
    -- Player kidnap animation
    TaskPlayAnim(playerPed, dict, 'kid_throw_person', 8.0, -8.0, 3000, 1, 0, false, false, false)
    TaskPlayAnim(targetPed, dict, 'kid_kick_floor', 8.0, -8.0, 3000, 1, 0, false, false, false)
    
    Wait(3000)
    
    -- Transport to warehouse
    local warehouseLoc = Config.Locations.kidnap_warehouse
    SetEntityCoords(targetPed, warehouseLoc.x, warehouseLoc.y, warehouseLoc.z, false, false, false, false)
    
    Utils.Notify('Kidnap', '✅ Target kidnapped and transported!', 'success')
    RemoveAnimDict(dict)
end

-- ==================== POLICE CHASE ====================
function TriggerPoliceChase()
    local policeNPCs = {}
    
    for _, npcData in ipairs(spawnedNPCs) do
        if npcData.faction == 'police' and DoesEntityExist(npcData.entity) then
            table.insert(policeNPCs, npcData)
        end
    end
    
    if #policeNPCs == 0 then
        Utils.Notify('Police', '❌ No police units available!', 'error')
        return
    end
    
    Utils.Notify('Police', '🚨 POLICE CHASE INITIATED!', 'error')
    
    local playerPed = PlayerPedId()
    
    -- Make police chase player
    for i = 1, math.min(3, #policeNPCs) do
        local copData = policeNPCs[i]
        if DoesEntityExist(copData.entity) then
            TaskStartScenarioInPlace(copData.entity, 'WORLD_HUMAN_COP_IDLES', 0, true)
            Wait(500)
            TaskGoToEntity(copData.entity, playerPed, -1, 1.0, 10.0, 1073741824, 0)
        end
    end
end

-- ==================== GANG WAR ====================
function TriggerGangWar()
    local vagosNPCs = {}
    local ballastNPCs = {}
    
    for _, npcData in ipairs(spawnedNPCs) do
        if npcData.gang == 'vagos' and DoesEntityExist(npcData.entity) then
            table.insert(vagosNPCs, npcData)
        elseif npcData.gang == 'ballast' and DoesEntityExist(npcData.entity) then
            table.insert(ballastNPCs, npcData)
        end
    end
    
    if #vagosNPCs == 0 or #ballastNPCs == 0 then
        Utils.Notify('Gang War', '❌ Not enough gang members!', 'error')
        return
    end
    
    Utils.Notify('Gang War', '🔥 GANG WAR INITIATED!', 'error')
    
    -- Make gangs fight
    for i = 1, math.min(5, math.min(#vagosNPCs, #ballastNPCs)) do
        local vagosNPC = vagosNPCs[i]
        local ballastNPC = ballastNPCs[math.random(1, #ballastNPCs)]
        
        if DoesEntityExist(vagosNPC.entity) and DoesEntityExist(ballastNPC.entity) then
            TaskCombatPed(vagosNPC.entity, ballastNPC.entity, 0, 16)
            Wait(200)
        end
    end
end

-- ==================== EXPORTS ====================
exports('GetSpawnedNPCs', function()
    return spawnedNPCs
end)

exports('GetSpawnedVehicles', function()
    return spawnedVehicles
end)

exports('GetTargetPed', function()
    return targetPed
end)

exports('GetNearbyNPCs', function()
    return nearbyNPCs
end)

print("^2[Cinematic RP] Client script loaded successfully!^7")
