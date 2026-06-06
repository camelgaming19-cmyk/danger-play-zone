-- Cinematic RP - Action handlers and chair target registration
-- Location: resources/[qb]/qb-cinematic-rp/client/cinematic_actions.lua

local seatAssignments = {} -- [npcEntity] = chairEntity
local cuffedPeds = {}

local ChairModels = {
    `prop_chair_01a`,
    `prop_chair_01b`,
    `prop_chair_02`,
    `prop_chair_03`,
    `prop_off_chair_01`,
    `prop_off_chair_02`,
    `prop_cs_office_chair`,
}

-- Safe notify helper
local function safeNotify(title, msg, type)
    if Utils and Utils.Notify then
        Utils.Notify(title, msg, type)
    else
        print(string.format("[%s] %s", title or "Notify", msg or ""))
    end
end

-- Wait for qb-target export
local function WaitForQBTarget()
    local tries = 0
    while not exports['qb-target'] and tries < 30 do
        Wait(200)
        tries = tries + 1
    end
    if not exports['qb-target'] then
        safeNotify('qb-target', 'qb-target export not found, target features disabled', 'error')
        return false
    end
    return true
end

-- Utility: find nearest chair object to coords
local function FindNearestChair(coords, maxDist)
    maxDist = maxDist or 3.0
    local px, py, pz = coords.x, coords.y, coords.z

    local closest = nil
    local closestDist = maxDist

    for _, modelName in ipairs(ChairModels) do
        local modelHash = GetHashKey(modelName)
        local obj = GetClosestObjectOfType(px, py, pz, maxDist, modelHash, false, false, false)
        if obj and DoesEntityExist(obj) then
            local ox, oy, oz = table.unpack(GetEntityCoords(obj))
            local d = Vdist(px, py, pz, ox, oy, oz)
            if d < closestDist then
                closestDist = d
                closest = obj
            end
        end
    end

    return closest
end

-- Seat an NPC on the nearest chair
function SeatNPCOnNearestChair(npcEntity)
    if not npcEntity or not DoesEntityExist(npcEntity) then return false end
    if seatAssignments[npcEntity] and DoesEntityExist(seatAssignments[npcEntity]) then
        safeNotify('Seat', 'NPC is already seated', 'error')
        return false
    end

    local npcCoords = GetEntityCoords(npcEntity)
    local chair = FindNearestChair(npcCoords, 4.0)
    if not chair then
        safeNotify('Seat', 'No chair found nearby', 'error')
        return false
    end

    -- Clear tasks and move NPC close to chair
    ClearPedTasksImmediately(npcEntity)
    local chairCoords = GetEntityCoords(chair)
    local chairHeading = GetEntityHeading(chair)

    SetEntityCoords(npcEntity, chairCoords.x, chairCoords.y, chairCoords.z - 0.95, 0, 0, 0, false)
    SetEntityHeading(npcEntity, chairHeading)

    -- Try to use seat scenario
    local scenario = 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER'
    TaskStartScenarioAtPosition(npcEntity, scenario, chairCoords.x, chairCoords.y, chairCoords.z, chairHeading, 0, true, true)

    seatAssignments[npcEntity] = chair
    safeNotify('Seat', 'NPC seated', 'success')
    return true
end

-- Unseat NPC
function UnseatNPC(npcEntity)
    if not npcEntity or not DoesEntityExist(npcEntity) then return false end
    if not seatAssignments[npcEntity] then
        safeNotify('Seat', 'NPC is not seated', 'error')
        return false
    end

    ClearPedTasksImmediately(npcEntity)
    seatAssignments[npcEntity] = nil
    safeNotify('Seat', 'NPC stood up', 'success')
    return true
end

-- Cuff a ped (disable control/attacks)
function CuffPed(ped)
    if not ped or not DoesEntityExist(ped) then return false end
    if cuffedPeds[ped] then
        safeNotify('Cuff', 'Entity already cuffed', 'error')
        return false
    end

    -- Block non temporary events and clear tasks
    SetBlockingOfNonTemporaryEvents(ped, true)
    ClearPedTasksImmediately(ped)
    FreezeEntityPosition(ped, true)
    cuffedPeds[ped] = true

    safeNotify('Cuff', 'Ped cuffed', 'success')
    return true
end

-- Uncuff ped
function UncuffPed(ped)
    if not ped or not DoesEntityExist(ped) then return false end
    if not cuffedPeds[ped] then
        safeNotify('Cuff', 'Entity not cuffed', 'error')
        return false
    end

    SetBlockingOfNonTemporaryEvents(ped, false)
    FreezeEntityPosition(ped, false)
    cuffedPeds[ped] = nil

    safeNotify('Cuff', 'Ped uncuffed', 'success')
    return true
end

-- Punch: player punches NPC
function PunchNPC(target)
    if not target or not DoesEntityExist(target) then return false end

    local playerPed = PlayerPedId()

    -- play player punch anim
    local dict = 'melee@unarmed@streamed_core'
    local anim = 'plyr_takedown_front_shove'

    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) and timeout < 100 do
        Wait(10)
        timeout = timeout + 1
    end

    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, 500, 48, 0, false, false, false)
    Wait(350)

    -- apply slight damage
    if DoesEntityExist(target) then
        local health = GetEntityHealth(target)
        local newHealth = math.max(0, health - 15)
        SetEntityHealth(target, newHealth)
        safeNotify('Fight', 'You hit the target', 'inform')
    else
        safeNotify('Fight', 'No valid target', 'error')
    end

    return true
end

-- Register player sit action on chairs with qb-target
local function RegisterChairTargets()
    if not WaitForQBTarget() then return end
    -- qb-target AddTargetModel expects an array of model hashes or names
    local opts = {
        {
            type = 'client',
            event = 'cinematic:client:playerSitOnChair',
            icon = 'fas fa-chair',
            label = 'Sit',
            num = 1,
        }
    }

    -- Register models
    exports['qb-target']:AddTargetModel(ChairModels, {
        options = opts,
        distance = 2.5,
    })

    print('^2[Cinematic RP] Chairs registered with qb-target^7')
end

-- Player sits on chair
RegisterNetEvent('cinematic:client:playerSitOnChair', function(data)
    local playerPed = PlayerPedId()
    local entity = nil
    if data and data.entity then entity = data.entity end

    if not entity then
        local coords = GetEntityCoords(playerPed)
        entity = FindNearestChair(coords, 3.0)
    end

    if not entity or not DoesEntityExist(entity) then
        safeNotify('Sit', 'No chair found', 'error')
        return
    end

    -- Move player and start scenario
    local chairCoords = GetEntityCoords(entity)
    local chairHeading = GetEntityHeading(entity)

    ClearPedTasksImmediately(playerPed)
    SetEntityCoords(playerPed, chairCoords.x, chairCoords.y, chairCoords.z - 0.95, 0, 0, 0, false)
    SetEntityHeading(playerPed, chairHeading)
    TaskStartScenarioAtPosition(playerPed, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', chairCoords.x, chairCoords.y, chairCoords.z, chairHeading, 0, true, true)
end)

-- Event handlers expected by qb_target integration
RegisterNetEvent('cinematic:client:requestCuff', function(entity)
    if not entity or not DoesEntityExist(entity) then
        safeNotify('Cuff', 'No valid entity to cuff', 'error')
        return
    end
    CuffPed(entity)
end)

RegisterNetEvent('cinematic:client:seatNPC', function(entity)
    if not entity or not DoesEntityExist(entity) then
        safeNotify('Seat', 'No valid NPC to seat', 'error')
        return
    end
    SeatNPCOnNearestChair(entity)
end)

RegisterNetEvent('cinematic:client:requestPunch', function(entity)
    if not entity or not DoesEntityExist(entity) then
        safeNotify('Punch', 'No valid NPC to punch', 'error')
        return
    end
    PunchNPC(entity)
end)

-- Exports
exports('SeatNPCOnNearestChair', SeatNPCOnNearestChair)
exports('UnseatNPC', UnseatNPC)
exports('CuffPed', CuffPed)
exports('UncuffPed', UncuffPed)
exports('PunchNPC', PunchNPC)

-- Init
Citizen.CreateThread(function()
    Wait(500)
    RegisterChairTargets()
end)

print('^2[Cinematic RP] action handlers loaded!^7')
