-- Full qb-target integration for Cinematic RP
-- File: resources/[qb]/qb-cinematic-rp/client/qb_target_full.lua
-- Features:
--  - Registers NPC entities with qb-target and passes entity/data to handlers
--  - Registers chair models with qb-target for player sit interactions
--  - Exposes events that receive qb-target data (data.entity) for reliable handling

local registered = {}
local chairModels = {
    "prop_chair_01a",
    "prop_chair_01b",
    "prop_chair_02",
    "prop_chair_03",
    "prop_off_chair_01",
    "prop_off_chair_02",
    "prop_cs_office_chair",
}

local function safeNotify(title, msg, type)
    if Utils and Utils.Notify then
        Utils.Notify(title, msg, type)
    else
        print(('[%s] %s'):format(title or 'Info', msg or ''))
    end
end

local function WaitForQBTarget()
    local tries = 0
    while not exports['qb-target'] and tries < 40 do
        Wait(200)
        tries = tries + 1
    end
    if not exports['qb-target'] then
        safeNotify('qb-target', 'qb-target not found; target integration disabled', 'error')
        return false
    end
    return true
end

local function BuildOptions(npcData)
    local opts = {}

    table.insert(opts, {
        type = 'client',
        event = 'cinematic:client:inspectTarget',
        icon = 'fas fa-eye',
        label = 'Inspect',
        -- qb-target will pass { entity = <entity> } to the event handler
    })

    if npcData.faction ~= 'police' then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:cuffTarget',
            icon = 'fas fa-handcuffs',
            label = 'Cuff',
        })
    end

    if npcData.canSit then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:seatTarget',
            icon = 'fas fa-chair',
            label = 'Seat NPC',
        })
    end

    if npcData.faction == 'gang' or npcData.hostile then
        table.insert(opts, {
            type = 'client',
            event = 'cinematic:client:punchTarget',
            icon = 'fas fa-fist-raised',
            label = 'Punch',
        })
    end

    -- stand/remove option for seated NPCs (handler can decide validity)
    table.insert(opts, {
        type = 'client',
        event = 'cinematic:client:standTarget',
        icon = 'fas fa-person-walking',
        label = 'Stand / Remove',
    })

    return opts
end

-- Register an NPC entity with qb-target
function RegisterNPCWithQbTarget(npcData)
    if not npcData or not npcData.entity then return end
    local ent = npcData.entity
    if registered[ent] then return end
    if not DoesEntityExist(ent) then return end
    if not WaitForQBTarget() then return end

    local options = BuildOptions(npcData)

    exports['qb-target']:AddTargetEntity(ent, {
        options = options,
        distance = 2.5,
    })

    registered[ent] = true
    print(('^2[Cinematic RP] Registered entity %s with qb-target^7'):format(tostring(ent)))
end

function UnregisterNPCFromQbTarget(entity)
    if not entity then return end
    if not registered[entity] then return end
    if not exports['qb-target'] then return end

    exports['qb-target']:RemoveTargetEntity(entity)
    registered[entity] = nil
    print(('^3[Cinematic RP] Unregistered entity %s from qb-target^7'):format(tostring(entity)))
end

-- Register all NPCs from global spawnedNPCs if present
function RegisterAllSpawnedNPCs()
    if not WaitForQBTarget() then return end
    if not spawnedNPCs then
        print('^1[Cinematic RP] spawnedNPCs not found; nothing to register^7')
        return
    end
    for _, npc in ipairs(spawnedNPCs) do
        RegisterNPCWithQbTarget(npc)
    end
end

-- Register chair models so players can sit
local function RegisterChairs()
    if not WaitForQBTarget() then return end
    local opts = {{ type = 'client', event = 'cinematic:client:playerSitOnChair', icon = 'fas fa-chair', label = 'Sit' }}
    exports['qb-target']:AddTargetModel(chairModels, { options = opts, distance = 2.5 })
    print('^2[Cinematic RP] Chair models registered with qb-target^7')
end

-- Periodic scanner to auto-register newly spawned NPCs
Citizen.CreateThread(function()
    Wait(1000)
    if not WaitForQBTarget() then return end

    RegisterChairs()

    while true do
        if spawnedNPCs then
            for _, npc in ipairs(spawnedNPCs) do
                if npc and npc.entity and DoesEntityExist(npc.entity) and not registered[npc.entity] then
                    RegisterNPCWithQbTarget(npc)
                end
            end
        end

        -- cleanup
        for ent, _ in pairs(registered) do
            if not DoesEntityExist(ent) then
                registered[ent] = nil
            end
        end

        Wait(2000)
    end
end)

-- Event handlers that receive qb-target data (data.entity guaranteed when used via AddTargetEntity/AddTargetModel)
RegisterNetEvent('cinematic:client:inspectTarget', function(data)
    local ent = data and data.entity
    if not ent or not DoesEntityExist(ent) then
        safeNotify('Inspect', 'No valid target', 'error')
        return
    end

    -- Prefer existing TargetNPC implementation if available
    if TargetNPC and GetEntityModel(ent) then
        -- If your target system uses TargetNPC, we can leverage it, otherwise just notify
        safeNotify('Inspect', ('Inspecting entity %s'):format(tostring(ent)), 'inform')
    else
        safeNotify('Inspect', 'Inspect action invoked', 'inform')
    end
end)

RegisterNetEvent('cinematic:client:cuffTarget', function(data)
    local ent = data and data.entity
    if not ent or not DoesEntityExist(ent) then
        safeNotify('Cuff', 'No valid target to cuff', 'error')
        return
    end
    -- forward to cinematic handler if exists
    if exports and exports['qb-cinematic-rp'] and exports['qb-cinematic-rp'].CuffPed then
        exports['qb-cinematic-rp']:CuffPed(ent)
        return
    end
    TriggerEvent('cinematic:client:requestCuff', ent)
end)

RegisterNetEvent('cinematic:client:seatTarget', function(data)
    local ent = data and data.entity
    if not ent or not DoesEntityExist(ent) then
        safeNotify('Seat', 'No valid NPC to seat', 'error')
        return
    end
    if exports and exports['qb-cinematic-rp'] and exports['qb-cinematic-rp'].SeatNPCOnNearestChair then
        exports['qb-cinematic-rp']:SeatNPCOnNearestChair(ent)
        return
    end
    TriggerEvent('cinematic:client:seatNPC', ent)
end)

RegisterNetEvent('cinematic:client:punchTarget', function(data)
    local ent = data and data.entity
    if not ent or not DoesEntityExist(ent) then
        safeNotify('Punch', 'No valid NPC to punch', 'error')
        return
    end
    if exports and exports['qb-cinematic-rp'] and exports['qb-cinematic-rp'].PunchNPC then
        exports['qb-cinematic-rp']:PunchNPC(ent)
        return
    end
    TriggerEvent('cinematic:client:requestPunch', ent)
end)

RegisterNetEvent('cinematic:client:standTarget', function(data)
    local ent = data and data.entity
    if not ent or not DoesEntityExist(ent) then
        safeNotify('Stand', 'No valid entity', 'error')
        return
    end
    -- Attempt to unseat / remove
    if exports and exports['qb-cinematic-rp'] and exports['qb-cinematic-rp'].UnseatNPC then
        exports['qb-cinematic-rp']:UnseatNPC(ent)
        return
    end
    TriggerEvent('cinematic:client:UnseatNPC', ent)
end)

-- Player sitting on chair (data.entity will be the chair)
RegisterNetEvent('cinematic:client:playerSitOnChair', function(data)
    local chair = data and data.entity
    local playerPed = PlayerPedId()
    if not chair or not DoesEntityExist(chair) then
        safeNotify('Sit', 'No chair found', 'error')
        return
    end

    local chairCoords = GetEntityCoords(chair)
    local chairHeading = GetEntityHeading(chair)
    ClearPedTasksImmediately(playerPed)
    SetEntityCoords(playerPed, chairCoords.x, chairCoords.y, chairCoords.z - 0.95, 0, 0, 0, false)
    SetEntityHeading(playerPed, chairHeading)
    TaskStartScenarioAtPosition(playerPed, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', chairCoords.x, chairCoords.y, chairCoords.z, chairHeading, 0, true, true)
end)

-- Exports
exports('RegisterNPCWithQbTarget', RegisterNPCWithQbTarget)
exports('UnregisterNPCFromQbTarget', UnregisterNPCFromQbTarget)
exports('RegisterAllSpawnedNPCs', RegisterAllSpawnedNPCs)

print('^2[Cinematic RP] full qb-target integration loaded!^7')
