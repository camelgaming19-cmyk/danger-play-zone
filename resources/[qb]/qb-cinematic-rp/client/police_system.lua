-- ============================================
-- CINEMATIC RP - Police System
-- ============================================

-- Get all police units
function GetPoliceForces()
    return GetNPCsByFaction('police')
end

-- Order police arrest
function OrderPoliceArrest(targetPed)
    if not DoesEntityExist(targetPed) then return end
    
    local police = GetPoliceForces()
    
    if #police == 0 then
        Utils.Notify('Police', '❌ No police units available!', 'error')
        return
    end
    
    Utils.Notify('Police', '🚔 ARREST INITIATED!', 'error')
    
    -- Police pursue target
    for i = 1, math.min(2, #police) do
        local cop = police[i]
        if DoesEntityExist(cop.entity) then
            TaskGoToEntity(cop.entity, targetPed, -1, 1.0, 5.0, 1073741824, 0)
        end
        Wait(300)
    end
    
    -- Wait for arrest
    Wait(5000)
    PlayPoliceArrestAnimation(targetPed, police[1].entity)
end

-- Play arrest animation
function PlayPoliceArrestAnimation(suspect, cop)
    if not DoesEntityExist(suspect) or not DoesEntityExist(cop) then return end
    
    local dict = 'move_m@_armed'
    RequestAnimDict(dict)
    
    while not HasAnimDictLoaded(dict) do
        Wait(100)
    end
    
    -- Handcuff animation
    TaskPlayAnim(suspect, dict, 'idle', 8.0, -8.0, 5000, 1, 0, false, false, false)
    
    Utils.Notify('Police', '🔗 Suspect handcuffed!', 'success')
    
    Wait(3000)
    
    -- Transport to jail
    TransportToJail(suspect)
end

-- Transport to jail
function TransportToJail(suspect)
    if not DoesEntityExist(suspect) then return end
    
    local jailLoc = Config.Locations.jail_cell
    SetEntityCoords(suspect, jailLoc.x, jailLoc.y, jailLoc.z, false, false, false, false)
    
    Utils.Notify('Police', '🚔 Suspect transported to jail!', 'success')
end

-- Police respond to location
function PoliceRespond(location)
    local police = GetPoliceForces()
    
    if #police == 0 then return end
    
    Utils.Notify('Police', '🚨 Police responding to location!', 'success')
    
    for _, cop in ipairs(police) do
        if DoesEntityExist(cop.entity) then
            TaskGoStraightToCoord(cop.entity, location.x, location.y, location.z, 3.0, -1, 0.0, 0.0)
        end
    end
end

-- Police patrol routes
function PolicePatrolRoute()
    local police = GetPoliceForces()
    
    local patrolPoints = {
        {x = 450.0, y = -980.0, z = 29.5},
        {x = 470.0, y = -980.0, z = 29.5},
        {x = 470.0, y = -1000.0, z = 29.5},
        {x = 450.0, y = -1000.0, z = 29.5},
    }
    
    for _, cop in ipairs(police) do
        MakeNPCPatrol(cop, patrolPoints)
    end
end

-- Full police chase
function InitiateFullPoliceChase(suspect)
    if not DoesEntityExist(suspect) then return end
    
    local police = GetPoliceForces()
    
    if #police < 3 then
        Utils.Notify('Police', '❌ Not enough police units!', 'error')
        return
    end
    
    Utils.Notify('Police', '🚨 FULL POLICE CHASE!', 'error')
    
    -- Make all police chase suspect
    for _, cop in ipairs(police) do
        if DoesEntityExist(cop.entity) then
            TaskCombatPed(cop.entity, suspect, 0, 16)
        end
        Wait(200)
    end
end

-- Police vehicle pursuit
function PoliceVehiclePursuit(suspect)
    if not DoesEntityExist(suspect) then return end
    
    local police = GetPoliceForces()
    local policeVehicles = {}
    
    for _, veh in ipairs(spawnedVehicles) do
        if veh.job == 'police' and DoesEntityExist(veh.entity) then
            table.insert(policeVehicles, veh)
        end
    end
    
    if #policeVehicles == 0 or #police < 2 then
        Utils.Notify('Police', '❌ Not enough resources!', 'error')
        return
    end
    
    Utils.Notify('Police', '🚔 VEHICLE PURSUIT IN PROGRESS!', 'error')
    
    local vehicle = policeVehicles[1].entity
    local driver = police[1].entity
    local suspectCoords = GetEntityCoords(suspect)
    
    if DoesEntityExist(vehicle) and DoesEntityExist(driver) then
        TaskWarpPedIntoVehicle(driver, vehicle, 0)
        Wait(500)
        TaskVehicleChase(driver, vehicle, suspect)
    end
end

print("^2[Cinematic RP] Police System loaded!^7")
