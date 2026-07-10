local QBCore = exports['qb-core']:GetCoreObject()

local DutyTimes = {}
local PlayerDutyStatus = {}

-- Toggle Duty Event
RegisterServerEvent('police-job:server:toggleDuty')
AddEventHandler('police-job:server:toggleDuty', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return end
    
    if Player.PlayerData.job.name ~= 'police' then
        TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        return
    end
    
    local isDuty = PlayerDutyStatus[source] or false
    
    if isDuty then
        -- Turn off duty
        PlayerDutyStatus[source] = false
        DutyTimes[source] = nil
        TriggerClientEvent('police-job:client:dutyOff', source)
        TriggerClientEvent('QBCore:Notify', source, 'You are now off duty', 'success')
    else
        -- Turn on duty
        PlayerDutyStatus[source] = true
        DutyTimes[source] = os.time()
        TriggerClientEvent('police-job:client:dutyOn', source)
        TriggerClientEvent('QBCore:Notify', source, 'You are now on duty', 'success')
    end
end)

TriggerEvent('QBCore:AddCommand', 'duty', 'Toggle Police Duty', {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    if Player.PlayerData.job.name ~= 'police' then
        TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        return
    end
    
    local isDuty = PlayerDutyStatus[source] or false
    
    if isDuty then
        DutyTimes[source] = nil
        PlayerDutyStatus[source] = false
        TriggerClientEvent('police-job:client:dutyOff', source)
        TriggerClientEvent('QBCore:Notify', source, 'You are now off duty', 'success')
    else
        DutyTimes[source] = os.time()
        PlayerDutyStatus[source] = true
        TriggerClientEvent('police-job:client:dutyOn', source)
        TriggerClientEvent('QBCore:Notify', source, 'You are now on duty', 'success')
    end
end)

TriggerEvent('QBCore:AddCommand', 'policewardrobe', 'Change Police Uniform', {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end
    
    if Player.PlayerData.job.name ~= 'police' then
        TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        return
    end
    
    TriggerClientEvent('police-job:client:openWardrobe', source)
end)

-- Get duty status
QBCore.Functions.CreateCallback('police-job:getDutyStatus', function(source, cb)
    cb(PlayerDutyStatus[source] or false)
end)

-- Get duty time
QBCore.Functions.CreateCallback('police-job:getDutyTime', function(source, cb)
    if DutyTimes[source] then
        local dutyMinutes = math.floor((os.time() - DutyTimes[source]) / 60)
        cb(dutyMinutes)
    else
        cb(0)
    end
end)

-- Player Disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    DutyTimes[source] = nil
    PlayerDutyStatus[source] = nil
end)

-- Export duty status
exports('getDutyStatus', function(source)
    return PlayerDutyStatus[source] or false
end)
