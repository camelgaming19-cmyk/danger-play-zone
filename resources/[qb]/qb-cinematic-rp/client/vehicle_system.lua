-- ============================================
-- CINEMATIC RP - Vehicle System
-- ============================================

-- Get vehicles by faction
function GetVehiclesByFaction(faction)
    local vehicles = {}
    for _, vehData in ipairs(spawnedVehicles) do
        if vehData.faction == faction and DoesEntityExist(vehData.entity) then
            table.insert(vehicles, vehData)
        end
    end
    return vehicles
end

-- Get gang vehicles
function GetGangVehicles(gang)
    local vehicles = {}
    for _, vehData in ipairs(spawnedVehicles) do
        if vehData.gang == gang and DoesEntityExist(vehData.entity) then
            table.insert(vehicles, vehData)
        end
    end
    return vehicles
end

-- Put NPC in vehicle
function PutNPCInVehicle(ped, vehicle, seat)
    if not DoesEntityExist(ped) or not DoesEntityExist(vehicle) then return end
    
    TaskWarpPedIntoVehicle(ped, vehicle, seat or 0)
end

-- Make NPC drive
function MakeNPCDrive(ped, vehicle, destination)
    if not DoesEntityExist(ped) or not DoesEntityExist(vehicle) then return end
    
    PutNPCInVehicle(ped, vehicle, 0)
    Wait(500)
    
    TaskVehicleGoToCoord(ped, vehicle, destination.x, destination.y, destination.z, 20.0, 0, GetHashKey('oracle'), 411, 0.0, 1.0)
end

-- Make NPC chase in vehicle
function MakeNPCVehicleChase(ped, vehicle, target)
    if not DoesEntityExist(ped) or not DoesEntityExist(vehicle) or not DoesEntityExist(target) then return end
    
    PutNPCInVehicle(ped, vehicle, 0)
    Wait(500)
    
    TaskVehicleChase(ped, vehicle, target)
end

-- Make convoy
function MakeConvoy(pedList, vehicleList, destination)
    for i, pedData in ipairs(pedList) do
        if i <= #vehicleList then
            local veh = vehicleList[i]
            if DoesEntityExist(pedData.entity) and DoesEntityExist(veh.entity) then
                MakeNPCDrive(pedData.entity, veh.entity, destination)
                Wait(200)
            end
        end
    end
end

-- Damage vehicle
function DamageVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    SmashVehicleWindow(vehicle, 2)
    SmashVehicleWindow(vehicle, 3)
end

-- Remove vehicle
function RemoveVehicle(vehicleData)
    if DoesEntityExist(vehicleData.entity) then
        DeleteEntity(vehicleData.entity)
    end
end

-- Remove all vehicles
function RemoveAllVehicles()
    for _, vehData in ipairs(spawnedVehicles) do
        if DoesEntityExist(vehData.entity) then
            DeleteEntity(vehData.entity)
        end
    end
    spawnedVehicles = {}
    print("^2[Cinematic RP] All vehicles cleared!^7")
end

print("^2[Cinematic RP] Vehicle System loaded!^7")
