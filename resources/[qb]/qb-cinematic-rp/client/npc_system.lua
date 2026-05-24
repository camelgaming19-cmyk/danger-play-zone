-- ============================================
-- CINEMATIC RP - NPC System Functions
-- ============================================

-- Get all NPCs by faction
function GetNPCsByFaction(faction)
    local npcs = {}
    for _, npcData in ipairs(spawnedNPCs) do
        if npcData.faction == faction and DoesEntityExist(npcData.entity) then
            table.insert(npcs, npcData)
        end
    end
    return npcs
end

-- Get all gang members
function GetGangMembers(gang)
    local members = {}
    for _, npcData in ipairs(spawnedNPCs) do
        if npcData.gang == gang and DoesEntityExist(npcData.entity) then
            table.insert(members, npcData)
        end
    end
    return members
end

-- Get all police units
function GetPoliceUnits()
    local units = {}
    for _, npcData in ipairs(spawnedNPCs) do
        if npcData.faction == 'police' and DoesEntityExist(npcData.entity) then
            table.insert(units, npcData)
        end
    end
    return units
end

-- Give weapon to NPC
function GiveNPCWeapon(ped, weapon)
    if DoesEntityExist(ped) then
        GiveWeaponToPed(ped, GetHashKey(weapon), 250, false, true)
    end
end

-- Make NPC patrol route
function MakeNPCPatrol(npcData, patrolPoints)
    if not DoesEntityExist(npcData.entity) then return end
    
    CreateThread(function()
        local currentPoint = 1
        
        while DoesEntityExist(npcData.entity) do
            local point = patrolPoints[currentPoint]
            
            TaskGoStraightToCoord(npcData.entity, point.x, point.y, point.z, 1.0, -1, 0.0, 0.0)
            
            Wait(5000)
            
            currentPoint = currentPoint + 1
            if currentPoint > #patrolPoints then
                currentPoint = 1
            end
        end
    end)
end

-- Set NPC to stand around
function MakeNPCLoiter(npcData)
    if not DoesEntityExist(npcData.entity) then return end
    
    local scenario = Utils.RandomTable(Config.Animations.scenarios)
    TaskStartScenarioInPlace(npcData.entity, scenario, 0, true)
end

-- Make NPC attack target
function MakeNPCAttack(npcData, target)
    if not DoesEntityExist(npcData.entity) or not DoesEntityExist(target) then return end
    
    TaskCombatPed(npcData.entity, target, 0, 16)
end

-- Make NPC follow entity
function MakeNPCFollow(npcData, target)
    if not DoesEntityExist(npcData.entity) or not DoesEntityExist(target) then return end
    
    TaskFollowToOffsetOfEntity(npcData.entity, target, 0.0, -3.0, 0.0, 5.0, -1, 10.0, true)
end

-- Clean up NPC
function RemoveNPC(npcData)
    if DoesEntityExist(npcData.entity) then
        DeleteEntity(npcData.entity)
    end
end

-- Clean all NPCs
function RemoveAllNPCs()
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            DeleteEntity(npcData.entity)
        end
    end
    spawnedNPCs = {}
    print("^2[Cinematic RP] All NPCs cleared!^7")
end

print("^2[Cinematic RP] NPC System functions loaded!^7")
