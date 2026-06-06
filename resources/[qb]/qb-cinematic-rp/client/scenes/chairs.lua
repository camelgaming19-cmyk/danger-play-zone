-- Scene director: chairs & simple scene command handler
-- File: resources/[qb]/qb-cinematic-rp/client/scenes/chairs.lua
-- Provides: /scene commands for starting/ending scenes, spawning NPCs, creating chairs, seating, cuffing, punching

local sceneActive = false
local sceneNPCs = {} -- { { entity = ped, faction = 'gang', role = 'gangster', index = n } }
local sceneChairs = {} -- { chairEntity }
local nextNpcIndex = 1

local ChairModels = {
    'prop_chair_01a',
    'prop_chair_01b',
    'prop_chair_02',
    'prop_chair_03',
    'prop_off_chair_01',
    'prop_off_chair_02',
    'prop_cs_office_chair',
}

local function safeNotify(title, msg, type)
    if Utils and Utils.Notify then
        Utils.Notify(title, msg, type)
    else
        print(('[%s] %s'):format(title or 'Info', msg or ''))
    end
end

local function LoadModel(model)
    local m = (type(model) == 'number') and model or GetHashKey(model)
    if not IsModelInCdimage(m) then return false end
    RequestModel(m)
    local t = 0
    while not HasModelLoaded(m) and t < 200 do
        Wait(10)
        t = t + 1
    end
    return HasModelLoaded(m)
end

local function SpawnNPC(faction, role)
    local player = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(player))
    local forward = GetEntityForwardVector(player)
    local spawnCoords = vector3(px + forward.x * 2.0, py + forward.y * 2.0, pz)

    -- choose model from Config.NPCModels if available, otherwise fallback
    local model = 'a_m_m_business_01'
    if Config and Config.NPCModels and #Config.NPCModels > 0 then
        model = Config.NPCModels[ math.random(1, #Config.NPCModels) ]
    end

    if not LoadModel(model) then
        safeNotify('Scene', 'Failed to load ped model '..tostring(model), 'error')
        return nil
    end

    local ped = CreatePed(4, GetHashKey(model), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, false)
    if not DoesEntityExist(ped) then
        safeNotify('Scene', 'Failed to create ped', 'error')
        return nil
    end

    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, false)
    SetPedCanRagdoll(ped, true)

    local npcData = {
        entity = ped,
        faction = faction or 'civilian',
        role = role or 'civilian',
        index = nextNpcIndex,
    }

    sceneNPCs[nextNpcIndex] = npcData
    nextNpcIndex = nextNpcIndex + 1

    -- notify other systems (qb-target integration listens for this)
    TriggerEvent('cinematic:client:npcSpawned', npcData)

    safeNotify('Scene', ('Spawned NPC #%d (%s)'):format(npcData.index, npcData.faction), 'success')
    return npcData
end

local function CreateChairAtPlayer()
    local player = PlayerPedId()
    local px, py, pz = table.unpack(GetEntityCoords(player))
    local forward = GetEntityForwardVector(player)
    local spawnCoords = vector3(px + forward.x * 1.5, py + forward.y * 1.5, pz)

    local model = ChairModels[ math.random(1, #ChairModels) ]
    if not LoadModel(model) then
        safeNotify('Scene', 'Failed to load chair model '..tostring(model), 'error')
        return nil
    end

    local chair = CreateObject(GetHashKey(model), spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, true)
    if not DoesEntityExist(chair) then
        safeNotify('Scene', 'Failed to create chair object', 'error')
        return nil
    end

    PlaceObjectOnGroundProperly(chair)
    SetEntityAsMissionEntity(chair, true, true)

    table.insert(sceneChairs, chair)
    local idx = #sceneChairs
    safeNotify('Scene', ('Created chair #%d'):format(idx), 'success')
    return chair, idx
end

local function SeatNPCAtChair(npcIndex, chairIndex)
    local npc = sceneNPCs[npcIndex]
    local chair = sceneChairs[chairIndex]
    if not npc or not npc.entity or not DoesEntityExist(npc.entity) then
        safeNotify('Scene', 'Invalid NPC index', 'error')
        return false
    end
    if not chair or not DoesEntityExist(chair) then
        safeNotify('Scene', 'Invalid chair index', 'error')
        return false
    end

    local chairCoords = GetEntityCoords(chair)
    local chairHeading = GetEntityHeading(chair)

    ClearPedTasksImmediately(npc.entity)
    SetEntityCoords(npc.entity, chairCoords.x, chairCoords.y, chairCoords.z - 0.95, 0, 0, 0, false)
    SetEntityHeading(npc.entity, chairHeading)
    TaskStartScenarioAtPosition(npc.entity, 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', chairCoords.x, chairCoords.y, chairCoords.z, chairHeading, 0, true, true)

    safeNotify('Scene', ('NPC #%d seated on chair #%d'):format(npcIndex, chairIndex), 'success')
    return true
end

local function CuffNPCByIndex(npcIndex)
    local npc = sceneNPCs[npcIndex]
    if not npc or not npc.entity or not DoesEntityExist(npc.entity) then
        safeNotify('Scene', 'Invalid NPC index to cuff', 'error')
        return false
    end
    TriggerEvent('cinematic:client:requestCuff', npc.entity)
    safeNotify('Scene', ('Cuffed NPC #%d'):format(npcIndex), 'inform')
    return true
end

local function PunchNPCByIndexes(attackerIndex, targetIndex)
    local attacker = sceneNPCs[attackerIndex]
    local target = sceneNPCs[targetIndex]
    if not attacker or not attacker.entity or not DoesEntityExist(attacker.entity) then
        safeNotify('Scene', 'Invalid attacker index', 'error')
        return false
    end
    if not target or not target.entity or not DoesEntityExist(target.entity) then
        safeNotify('Scene', 'Invalid target index', 'error')
        return false
    end

    -- Make attacker play melee anim and damage target
    -- We reuse cinematic action handler by triggering its event
    TriggerEvent('cinematic:client:requestPunch', target.entity)
    safeNotify('Scene', ('NPC #%d punched NPC #%d'):format(attackerIndex, targetIndex), 'inform')
    return true
end

local function EndScene()
    -- cleanup NPCs
    for i, npc in pairs(sceneNPCs) do
        if npc and npc.entity and DoesEntityExist(npc.entity) then
            TriggerEvent('cinematic:client:npcDespawned', npc)
            DeleteEntity(npc.entity)
        end
    end
    sceneNPCs = {}
    nextNpcIndex = 1

    -- cleanup chairs
    for i, chair in ipairs(sceneChairs) do
        if chair and DoesEntityExist(chair) then
            DeleteEntity(chair)
        end
    end
    sceneChairs = {}

    sceneActive = false
    safeNotify('Scene', 'Scene ended and cleaned up', 'success')
end

-- Command parser: /scene <sub> ...
RegisterCommand('scene', function(source, args, raw)
    local sub = args[1]
    if not sub then
        safeNotify('Scene', 'Usage: /scene start | spawn npc <faction> <count> | chair create | sit npc <npcIndex> chair <chairIndex> | cuff npc <npcIndex> | punch npc <attacker> npc <target> | end', 'inform')
        return
    end

    if sub == 'start' then
        sceneActive = true
        sceneNPCs = {}
        sceneChairs = {}
        nextNpcIndex = 1
        safeNotify('Scene', 'Scene started', 'success')
        return
    end

    if sub == 'end' then
        EndScene()
        return
    end

    if not sceneActive and sub ~= 'start' then
        safeNotify('Scene', 'No active scene. Use /scene start', 'error')
        return
    end

    if sub == 'spawn' and args[2] == 'npc' then
        local faction = args[3] or 'gang'
        local count = tonumber(args[4]) or 1
        for i=1,count do
            SpawnNPC(faction, 'member')
            Wait(200)
        end
        return
    end

    if sub == 'chair' and args[2] == 'create' then
        CreateChairAtPlayer()
        return
    end

    if sub == 'sit' and args[2] == 'npc' and args[4] == 'chair' then
        local npcIndex = tonumber(args[3])
        local chairIndex = tonumber(args[5])
        if npcIndex and chairIndex then
            SeatNPCAtChair(npcIndex, chairIndex)
        else
            safeNotify('Scene', 'Invalid indices for sit', 'error')
        end
        return
    end

    if sub == 'cuff' and args[2] == 'npc' then
        local npcIndex = tonumber(args[3])
        if npcIndex then CuffNPCByIndex(npcIndex) else safeNotify('Scene','Invalid npc index','error') end
        return
    end

    if sub == 'punch' and args[2] == 'npc' and args[4] == 'npc' then
        local attacker = tonumber(args[3])
        local target = tonumber(args[5])
        if attacker and target then PunchNPCByIndexes(attacker, target) else safeNotify('Scene','Invalid indices for punch','error') end
        return
    end

    safeNotify('Scene', 'Unknown scene command', 'error')
end, false)

print('^2[Cinematic RP] scene director (chairs) loaded!^7')
