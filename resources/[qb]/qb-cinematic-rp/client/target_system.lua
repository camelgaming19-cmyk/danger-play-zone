-- ============================================
-- CINEMATIC RP - Target System
-- ============================================

-- Target data
local targetData = {
    ped = nil,
    faction = nil,
    name = nil,
    distance = 0,
}

-- Target nearest NPC
function TargetNPC()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closest = nil
    local closestDist = 100.0
    
    for _, npcData in ipairs(spawnedNPCs) do
        if DoesEntityExist(npcData.entity) then
            local npcCoords = GetEntityCoords(npcData.entity)
            local dist = Utils.GetDistance3D(playerCoords, npcCoords)
            
            if dist < closestDist then
                closestDist = dist
                closest = npcData
            end
        end
    end
    
    if closest then
        targetData.ped = closest.entity
        targetData.faction = closest.faction
        targetData.distance = closestDist
        
        Utils.Notify('Target', '✅ Targeted: ' .. closest.faction:upper(), 'success')
        return closest
    end
    
    return nil
end

-- Get current target
function GetCurrentTarget()
    return targetData
end

-- Check if target in range
function IsTargetInRange(range)
    if not targetData.ped or not DoesEntityExist(targetData.ped) then
        return false
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(targetData.ped)
    local distance = Utils.GetDistance3D(playerCoords, targetCoords)
    
    return distance <= range
end

-- Get target distance
function GetTargetDistance()
    if not targetData.ped or not DoesEntityExist(targetData.ped) then
        return -1
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(targetData.ped)
    
    return Utils.GetDistance3D(playerCoords, targetCoords)
end

-- Clear target
function ClearTarget()
    targetData.ped = nil
    targetData.faction = nil
    Utils.Notify('Target', '❌ Target cleared', 'error')
end

-- Draw target marker
function DrawTargetMarker()
    if not targetData.ped or not DoesEntityExist(targetData.ped) then return end
    
    local coords = GetEntityCoords(targetData.ped)
    
    DrawMarker(20, coords.x, coords.y, coords.z + 2.5, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 200, false, true, 2, false, nil, nil, false)
end

print("^2[Cinematic RP] Target System loaded!^7")
