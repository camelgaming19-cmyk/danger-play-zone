local QBCore = exports['qb-core']:GetCoreObject()

local PlayerDutyStatus = {}

QBCore.Commands.Add('policemenu', 'Open Police Menu', {}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' then
            TriggerClientEvent('police-job:client:openPoliceMenu', source)
        else
            TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        end
    end
end)

-- Arrest Command
QBCore.Commands.Add('arrest', 'Arrest a player', {{name = 'id', help = 'Player ID'}, {name = 'charge', help = 'Charge'}}, false, function(source, args, rawCommand)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' and PlayerDutyStatus[source] then
            if args[1] then
                local targetId = tonumber(args[1])
                local Target = QBCore.Functions.GetPlayer(targetId)
                if Target then
                    local charge = args[2] or 'unknown'
                    TriggerClientEvent('police-job:client:arrest', targetId, source, charge)
                    TriggerClientEvent('QBCore:Notify', source, 'Player arrested', 'success')
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Player not found', 'error')
                end
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'You must be on duty', 'error')
        end
    end
end)

-- Toggle Duty
TriggerEvent('QBCore:AddCommand', 'duty', 'Toggle Police Duty', {}, false, function(source, args, rawCommand)
    TogglePlayerDuty(source)
end)

function TogglePlayerDuty(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.PlayerData.job.name == 'police' then
            if PlayerDutyStatus[source] then
                PlayerDutyStatus[source] = false
                TriggerClientEvent('police-job:client:dutyOff', source)
                TriggerClientEvent('QBCore:Notify', source, 'You are now off duty', 'success')
            else
                PlayerDutyStatus[source] = true
                TriggerClientEvent('police-job:client:dutyOn', source)
                TriggerClientEvent('QBCore:Notify', source, 'You are now on duty', 'success')
            end
        else
            TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        end
    end
end

-- Get Duty Status
QBCore.Functions.CreateCallback('police-job:getDutyStatus', function(source, cb)
    cb(PlayerDutyStatus[source] or false)
end)

-- Player Disconnect
AddEventHandler('playerDropped', function(reason)
    local source = source
    if PlayerDutyStatus[source] then
        PlayerDutyStatus[source] = nil
    end
end)

exports('getDutyStatus', function(source)
    return PlayerDutyStatus[source] or false
end)
