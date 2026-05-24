-- ============================================
-- CINEMATIC RP - Mission System
-- ============================================

local activeMission = nil
local missionProgress = 0
local missionCompleted = false

-- Start kidnap mission
function StartKidnapMission(targetPed)
    if not DoesEntityExist(targetPed) then return end
    
    activeMission = {
        type = 'kidnap',
        target = targetPed,
        startTime = GetGameTimer(),
        objective = 'Kidnap the target',
        status = 'active',
    }
    
    Utils.Notify('Mission', '🎯 KIDNAP MISSION STARTED!', 'success')
    Utils.Notify('Objective', 'Kidnap the target and bring to warehouse', 'success')
    
    missionProgress = 0
    missionCompleted = false
end

-- Start robbery mission
function StartRobberyMission()
    activeMission = {
        type = 'robbery',
        startTime = GetGameTimer(),
        objective = 'Rob the store',
        status = 'active',
    }
    
    Utils.Notify('Mission', '🎯 ROBBERY MISSION STARTED!', 'success')
    Utils.Notify('Objective', 'Rob the store with gang members', 'success')
end

-- Start drive by mission
function StartDrivByMission(targetCoords)
    activeMission = {
        type = 'drive_by',
        target = targetCoords,
        startTime = GetGameTimer(),
        objective = 'Drive by the location',
        status = 'active',
    }
    
    Utils.Notify('Mission', '🎯 DRIVE BY MISSION STARTED!', 'success')
    Utils.Notify('Objective', 'Drive by and eliminate targets', 'success')
end

-- Start drug deal mission
function StartDrugDealMission(dealerPed)
    if not DoesEntityExist(dealerPed) then return end
    
    activeMission = {
        type = 'drug_deal',
        dealer = dealerPed,
        startTime = GetGameTimer(),
        objective = 'Complete the drug deal',
        status = 'active',
    }
    
    Utils.Notify('Mission', '🎯 DRUG DEAL MISSION STARTED!', 'success')
    Utils.Notify('Objective', 'Go to dealer and complete transaction', 'success')
end

-- Update mission
function UpdateMission()
    if not activeMission or activeMission.status ~= 'active' then return end
    
    local elapsedTime = GetGameTimer() - activeMission.startTime
    
    if activeMission.type == 'kidnap' then
        if DoesEntityExist(activeMission.target) then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local targetCoords = GetEntityCoords(activeMission.target)
            local distance = Utils.GetDistance3D(playerCoords, targetCoords)
            
            if distance < 5.0 then
                missionProgress = missionProgress + 1
                
                if missionProgress > 100 then
                    CompleteMission()
                end
            end
        else
            FailMission()
        end
    end
end

-- Complete mission
function CompleteMission()
    if not activeMission then return end
    
    missionCompleted = true
    activeMission.status = 'completed'
    
    local reward = Config.Missions[activeMission.type].reward
    
    Utils.Notify('Mission', '✅ MISSION COMPLETED!', 'success')
    Utils.Notify('Reward', 'You earned $' .. reward, 'success')
end

-- Fail mission
function FailMission()
    if not activeMission then return end
    
    activeMission.status = 'failed'
    
    Utils.Notify('Mission', '❌ MISSION FAILED!', 'error')
end

-- Get active mission
function GetActiveMission()
    return activeMission
end

-- Cancel mission
function CancelMission()
    if activeMission then
        activeMission.status = 'cancelled'
        Utils.Notify('Mission', '⚠️ Mission cancelled', 'error')
    end
    activeMission = nil
end

print("^2[Cinematic RP] Mission System loaded!^7")
