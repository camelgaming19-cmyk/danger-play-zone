local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('police-job:client:arrest')
AddEventHandler('police-job:client:arrest', function(targetId, policeId, charge)
    -- Arrest animation
end)

RegisterNetEvent('police-job:client:arrestAnimation')
AddEventHandler('police-job:client:arrestAnimation', function()
    local playerPed = PlayerPedId()
    
    RequestAnimDict('combat@damage@rb_writhe')
    TaskPlayAnim(playerPed, 'combat@damage@rb_writhe', 'rb_writhe_loop', 8.0, -8.0, -1, 1, 0, false, false, false)
end)

RegisterNetEvent('police-job:client:goToJail')
AddEventHandler('police-job:client:goToJail', function(jailTime)
    local playerPed = PlayerPedId()
    
    ClearTasksFromPed(playerPed)
    SetEntityCoords(playerPed, Config.JailLocation.coords)
    SetEntityHeading(playerPed, Config.JailLocation.heading)
    
    -- Jail animation
    RequestAnimDict('combat@damage@rb_writhe')
    TaskPlayAnim(playerPed, 'combat@damage@rb_writhe', 'rb_writhe_loop', 8.0, -8.0, jailTime * 60000, 1, 0, false, false, false)
end)

RegisterNetEvent('police-job:client:releaseFromJail')
AddEventHandler('police-job:client:releaseFromJail', function()
    local playerPed = PlayerPedId()
    ClearTasksFromPed(playerPed)
    SetEntityCoords(playerPed, Config.PoliceDutyLocation.coords)
    TriggerEvent('QBCore:Notify', 'You have been released from jail', 'success')
end)

RegisterCommand('tackledown', function()
    local playerPed = PlayerPedId()
    local nearbyPlayers = GetNearbyPlayers(3.0)
    
    for _, otherId in ipairs(nearbyPlayers) do
        if otherId ~= PlayerId() then
            local otherPed = GetPlayerPed(otherId)
            
            -- Tackle animation
            RequestAnimDict('melee@tackle')
            TaskPlayAnim(playerPed, 'melee@tackle', 'tackle_a_player', 8.0, -8.0, -1, 1, 0, false, false, false)
            
            RequestAnimDict('melee@tackle')
            TaskPlayAnim(otherPed, 'melee@tackle', 'victim_tackle_a', 8.0, -8.0, -1, 1, 0, false, false, false)
            
            break
        end
    end
end, false)

function GetNearbyPlayers(range)
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for i = 0, GetMaxPlayers() do
        if NetworkIsSessionStarted() then
            local ped = GetPlayerPed(i)
            if ped ~= playerPed then
                local pedCoords = GetEntityCoords(ped)
                if #(playerCoords - pedCoords) <= range then
                    table.insert(players, i)
                end
            end
        end
    end
    
    return players
end
