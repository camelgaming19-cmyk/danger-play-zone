-- QB-TARGET integration for Cinematic RP
-- Registers spawned NPCs and scene objects with qb-target so players can interact
-- Location: resources/[qb]/qb-cinematic-rp/client/qb_target.lua

local registeredEntities = {}
local registeredZones = {}

-- Utility: safe notify (uses existing Utils if available)
local function safeNotify(title, msg, type)
    if Utils and Utils.Notify then
        Utils.Notify(title, msg, type)
    else
        print(string.format("[%s] %s" , title or "Notify", msg or ""))
    end
end

-- Wait until qb-target export is available
local function WaitForQBTarget()
    local tries = 0
    while not exports['qb-target'] and tries < 30 do
        Wait(200)
        tries = tries + 1
    end
    if not exports['qb-target'] then
        safeNotify('qb-target', 'qb-target export not found, target integration disabled', 'error')
        return false
    end
    return true
end

-- Build a simple option based on npc data
local function BuildOptionsForNPC(npcData)
    local opts = {}

    -- Inspect / Target action - will call existing TargetNPC() if present
    table.insert(opts, {
        type = 'client',
        event = 'cinematic:client:targetInspect',
        icon = 'fas fa-eye',
        label = 'Inspect',
        num = 1,
    })

    -- Cuff option for non-police NPCs
    if npcData.faction ~= 'police' then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:cuffNPC',
            icon = 'fas fa-handcuffs',
            label = 'Cuff',
            num = 2,
        })
    end

    -- Sit option - if a chair exists and npc is allowed to sit
    if npcData.canSit then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:makeSit',
            icon = 'fas fa-chair',
            label = 'Sit',
            num = 3,
        })
    end

    -- Punch / Attack option for gang / hostile NPCs
    if npcData.faction == 'gang' then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:punchNPC',
            icon = 'fas fa-fist-raised',
            label = 'Punch',
            num = 4,
        })
    end

    return opts
end

-- Register a single NPC entity with qb-target
function RegisterNPCWithQbTarget(npcData)
    if not npcData or not npcData.entity then return end
    if not DoesEntityExist(npcData.entity) then return end
    if registeredEntities[npcData.entity] then return end
    if not WaitForQBTarget() then return end

    local opts = BuildOptionsForNPC(npcData)

    exports['qb-target']:AddTargetEntity(npcData.entity, {
        options = opts,
        distance = 2.5,
    })

    registeredEntities[npcData.entity] = true
    -- Debug
    print(string.format('^2[Cinematic RP] Registered entity %s with qb-target^7', tostring(npcData.entity)))
end

-- Unregister entity
function UnregisterNPCFromQbTarget(entity)
    if not entity then return end
    if not registeredEntities[entity] then return end
    if not exports['qb-target'] then return end

    exports['qb-target']:RemoveTargetEntity(entity)
    registeredEntities[entity] = nil
    print(string.format('^3[Cinematic RP] Unregistered entity %s from qb-target^7', tostring(entity)))
end

-- Helper to register all spawned NPCs found in the global spawnedNPCs table
function RegisterAllSpawnedNPCs()
    if not WaitForQBTarget() then return end
    if not spawnedNPCs then
        print('^1[Cinematic RP] No spawnedNPCs table found to register with qb-target^7')
        return
    end

    for _, npc in ipairs(spawnedNPCs) do
        RegisterNPCWithQbTarget(npc)
    end
end

-- Periodic scanner to catch new NPCs (in case events are not fired)
Citizen.CreateThread(function()
    Wait(1000)
    if not WaitForQBTarget() then return end

    while true do
        if spawnedNPCs then
            for _, npc in ipairs(spawnedNPCs) do
                if npc and npc.entity and DoesEntityExist(npc.entity) and not registeredEntities[npc.entity] then
                    RegisterNPCWithQbTarget(npc)
                end
            end
        end

        -- Clean up dead entities
        for ent, _ in pairs(registeredEntities) do
            if not DoesEntityExist(ent) then
                registeredEntities[ent] = nil
            end
        end

        Wait(2000)
    end
end)

-- Events: expose client events to be used by qb-target options
-- Inspect
RegisterNetEvent('cinematic:client:targetInspect', function(data)
    -- data will be empty; rely on current target detection function
    if TargetNPC then
        local t = TargetNPC()
        if t then
            safeNotify('Inspect', 'You inspect the target: ' .. (t.faction or 'unknown'), 'success')
        else
            safeNotify('Inspect', 'No target found', 'error')
        end
    else
        safeNotify('Inspect', 'Inspect action not available', 'error')
    end
end)

-- Cuff
RegisterNetEvent('cinematic:client:cuffNPC', function(data)
    -- qb-target passes the entity; but our options are client events without params by default
    -- We'll try to find the nearest entity in front of the player
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local entity = nil

    if data and data.entity then
        entity = data.entity
    else
        -- fallback: find closest registered entity within 3.0
        local closest = nil
        local dist = 3.0
        for _, npc in ipairs(spawnedNPCs or {}) do
            if npc.entity and DoesEntityExist(npc.entity) then
                local d = #(coords - GetEntityCoords(npc.entity))
                if d < dist then
                    dist = d
                    closest = npc.entity
                end
            end
        end
        entity = closest
    end

    if entity and DoesEntityExist(entity) then
        TriggerEvent('cinematic:client:requestCuff', entity)
    else
        safeNotify('Cuff', 'No valid target to cuff', 'error')
    end
end)

-- Sit
RegisterNetEvent('cinematic:client:makeSit', function(data)
    -- Attempt to seat the nearest NPC in a free chair or toggle sit if the player is the target
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local entity = nil
    if data and data.entity then entity = data.entity end

    if not entity then
        local closest = nil
        local dist = 3.0
        for _, npc in ipairs(spawnedNPCs or {}) do
            if npc.entity and DoesEntityExist(npc.entity) then
                local d = #(coords - GetEntityCoords(npc.entity))
                if d < dist then
                    dist = d
                    closest = npc.entity
                end
            end
        end
        entity = closest
    end

    if entity and DoesEntityExist(entity) then
        TriggerEvent('cinematic:client:seatNPC', entity)
    else
        safeNotify('Sit', 'No NPC nearby to sit', 'error')
    end
end)

-- Punch
RegisterNetEvent('cinematic:client:punchNPC', function(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local entity = nil
    if data and data.entity then entity = data.entity end

    if not entity then
        local closest = nil
        local dist = 3.0
        for _, npc in ipairs(spawnedNPCs or {}) do
            if npc.entity and DoesEntityExist(npc.entity) then
                local d = #(coords - GetEntityCoords(npc.entity))
                if d < dist then
                    dist = d
                    closest = npc.entity
                end
            end
        end
        entity = closest
    end

    if entity and DoesEntityExist(entity) then
        -- If there is an existing client function to initiate punch we trigger it
        TriggerEvent('cinematic:client:requestPunch', entity)
    else
        safeNotify('Punch', 'No NPC nearby to punch', 'error')
    end
end)

-- Listen for spawn/despawn events so we can register/unregister entities immediately
AddEventHandler('cinematic:client:npcSpawned', function(npcData)
    RegisterNPCWithQbTarget(npcData)
end)

AddEventHandler('cinematic:client:npcDespawned', function(npcData)
    if npcData and npcData.entity then
        UnregisterNPCFromQbTarget(npcData.entity)
    end
end)

-- Provide an export to register arbitrary entity data (allow other scripts to call it)
exports('RegisterNPCWithQbTarget', RegisterNPCWithQbTarget)
exports('UnregisterNPCFromQbTarget', UnregisterNPCFromQbTarget)

print('^2[Cinematic RP] qb-target integration loaded!^7')
