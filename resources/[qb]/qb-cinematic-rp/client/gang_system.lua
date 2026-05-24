-- ============================================
-- CINEMATIC RP - Gang System
-- ============================================

-- Get gang territory
function GetGangTerritory(gang)
    return Config.Gangs[gang].territory
end

-- Order gang kidnap
function OrderGangKidnap(targetPed)
    if not DoesEntityExist(targetPed) then return end
    
    local gangMembers = GetGangMembers('vagos')
    
    if #gangMembers < 2 then
        Utils.Notify('Gang', '❌ Not enough gang members!', 'error')
        return
    end
    
    Utils.Notify('Gang', '🔫 Gang kidnapping target...', 'error')
    
    -- Multiple gang members attack target
    for i = 1, math.min(3, #gangMembers) do
        local memberData = gangMembers[i]
        if DoesEntityExist(memberData.entity) then
            TaskCombatPed(memberData.entity, targetPed, 0, 16)
        end
        Wait(200)
    end
    
    Wait(3000)
    
    -- Transport to hideout
    local hideout = Config.Locations.gang_hideout
    SetEntityCoords(targetPed, hideout.x, hideout.y, hideout.z, false, false, false, false)
    
    Utils.Notify('Gang', '✅ Target secured at hideout!', 'success')
end

-- Order gang drive by
function OrderGangDriveBy(targetCoords)
    local gangMembers = GetGangMembers('vagos')
    local gangVehicles = {}
    
    for _, vehicleData in ipairs(spawnedVehicles) do
        if vehicleData.gang == 'vagos' and DoesEntityExist(vehicleData.entity) then
            table.insert(gangVehicles, vehicleData)
        end
    end
    
    if #gangVehicles == 0 or #gangMembers < 2 then
        Utils.Notify('Gang', '❌ Not enough resources!', 'error')
        return
    end
    
    Utils.Notify('Gang', '🔫 Drive by in progress!', 'error')
    
    local vehicle = gangVehicles[1].entity
    local driver = gangMembers[1].entity
    local shooter = gangMembers[2].entity
    
    if DoesEntityExist(vehicle) and DoesEntityExist(driver) and DoesEntityExist(shooter) then
        -- Put in vehicle
        TaskWarpPedIntoVehicle(driver, vehicle, 0)
        TaskWarpPedIntoVehicle(shooter, vehicle, 1)
        
        Wait(500)
        
        -- Drive to location
        TaskVehicleGoToCoord(driver, vehicle, targetCoords.x, targetCoords.y, targetCoords.z, 20.0, 0, GetHashKey('oracle'), 411, 0.0, 1.0)
    end
end

-- Trigger gang war
function TriggerFullGangWar()
    local vagosMembers = GetGangMembers('vagos')
    local ballastMembers = GetGangMembers('ballast')
    
    if #vagosMembers == 0 or #ballastMembers == 0 then
        Utils.Notify('Gang War', '❌ Not enough gang members!', 'error')
        return
    end
    
    Utils.Notify('Gang War', '🔥 FULL SCALE GANG WAR!', 'error')
    
    -- Make all members fight
    for i = 1, #vagosMembers do
        local vagos = vagosMembers[i]
        local ballast = ballastMembers[math.random(1, #ballastMembers)]
        
        if DoesEntityExist(vagos.entity) and DoesEntityExist(ballast.entity) then
            TaskCombatPed(vagos.entity, ballast.entity, 0, 16)
        end
        Wait(100)
    end
end

-- Make gang patrol territory
function MakeGangPatrol(gang)
    local members = GetGangMembers(gang)
    local territory = GetGangTerritory(gang)
    
    local patrolPoints = {
        {x = territory.x - 50, y = territory.y - 50, z = territory.z},
        {x = territory.x + 50, y = territory.y - 50, z = territory.z},
        {x = territory.x + 50, y = territory.y + 50, z = territory.z},
        {x = territory.x - 50, y = territory.y + 50, z = territory.z},
    }
    
    for _, memberData in ipairs(members) do
        MakeNPCPatrol(memberData, patrolPoints)
    end
end

-- Gang territory response
function GangTerritoryResponse(gang, location)
    local members = GetGangMembers(gang)
    
    for _, memberData in ipairs(members) do
        if DoesEntityExist(memberData.entity) then
            TaskGoStraightToCoord(memberData.entity, location.x, location.y, location.z, 2.0, -1, 0.0, 0.0)
        end
    end
end

print("^2[Cinematic RP] Gang System loaded!^7")
