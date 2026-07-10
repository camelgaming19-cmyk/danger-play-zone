local QBCore = exports['qb-core']:GetCoreObject()

local ArrestedPlayers = {}

RegisterServerEvent('police-job:server:arrestPlayer')
AddEventHandler('police-job:server:arrestPlayer', function(targetId, charge)
    local source = source
    local Police = QBCore.Functions.GetPlayer(source)
    local Target = QBCore.Functions.GetPlayer(targetId)
    
    if not Police or not Target then return end
    
    if Police.PlayerData.job.name ~= 'police' then
        TriggerClientEvent('QBCore:Notify', source, 'You are not a police officer', 'error')
        return
    end
    
    if ArrestedPlayers[targetId] then
        TriggerClientEvent('QBCore:Notify', source, 'Player is already arrested', 'error')
        return
    end
    
    ArrestedPlayers[targetId] = {
        chargedBy = Police.PlayerData.citizenid,
        charge = charge,
        time = os.time()
    }
    
    local jailTime = Config.JailTime[charge] or 10
    local fine = Config.ArrestFines[charge] or 5000
    
    TriggerClientEvent('police-job:client:arrestAnimation', targetId)
    TriggerClientEvent('police-job:client:goToJail', targetId, jailTime)
    
    -- Add jail time and fine to player
    Target.Functions.RemoveMoney('bank', fine, 'police-fine')
    
    TriggerClientEvent('QBCore:Notify', targetId, 'You were arrested for: ' .. charge, 'error')
    TriggerClientEvent('QBCore:Notify', targetId, 'Fine: $' .. fine, 'error')
    TriggerClientEvent('QBCore:Notify', source, 'Player arrested and fined $' .. fine, 'success')
    
    -- Log arrest
    MySQL.Async.execute('INSERT INTO police_arrests (arrested_player, charged_by, charge, fine, jail_time, timestamp) VALUES (?, ?, ?, ?, ?, ?)', {
        Target.PlayerData.citizenid,
        Police.PlayerData.citizenid,
        charge,
        fine,
        jailTime,
        os.date('%Y-%m-%d %H:%M:%S')
    })
    
    SetTimeout(jailTime * 60000, function()
        if ArrestedPlayers[targetId] then
            ArrestedPlayers[targetId] = nil
            TriggerClientEvent('police-job:client:releaseFromJail', targetId)
        end
    end)
end)

QBCore.Functions.CreateCallback('police-job:getArrestStatus', function(source, cb)
    cb(ArrestedPlayers[source] ~= nil)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    ArrestedPlayers[source] = nil
end)
