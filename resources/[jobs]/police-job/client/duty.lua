local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local InDutyZone = false
local OnDuty = false

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

-- Duty Location Marker
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distToDuty = #(playerCoords - Config.PoliceDutyLocation.coords)
        
        if PlayerData.job and PlayerData.job.name == 'police' then
            if distToDuty < 10 then
                DrawMarker(2, Config.PoliceDutyLocation.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, false, nil, nil, false)
            end
            
            if distToDuty < Config.PoliceDutyLocation.radius then
                InDutyZone = true
                if distToDuty < 2 then
                    TriggerEvent('police-job:client:showDutyMenu')
                end
            else
                InDutyZone = false
            end
        end
    end
end)

RegisterNetEvent('police-job:client:showDutyMenu')
AddEventHandler('police-job:client:showDutyMenu', function()
    QBCore.Functions.TriggerCallback('police-job:getDutyStatus', function(isDuty)
        if isDuty then
            if TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Police', 'Press E to leave duty'}
            }) then
                OnDuty = true
            end
        else
            if TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {'Police', 'Press E to join duty'}
            }) then
                OnDuty = false
            end
        end
    end)
end)

-- Press E to toggle duty
RegisterKeyMapping('toggleduty', 'Toggle Police Duty', 'keyboard', 'E')

RegisterCommand('toggleduty', function()
    if InDutyZone and PlayerData.job and PlayerData.job.name == 'police' then
        TriggerServerEvent('police-job:server:toggleDuty')
    end
end, false)

RegisterNetEvent('police-job:client:changeUniform')
AddEventHandler('police-job:client:changeUniform', function()
    local playerPed = PlayerPedId()
    local isMale = GetEntityModel(playerPed) == GetHashKey("a_m_m_business_1")
    
    if isMale then
        ApplyUniform(playerPed, Config.Uniforms.duty.male)
    else
        ApplyUniform(playerPed, Config.Uniforms.duty.female)
    end
end)

function ApplyUniform(ped, uniform)
    ClearAllPedProps(ped)
    
    SetPedComponentVariation(ped, 11, uniform.torso_1, uniform.torso_2, 2)
    SetPedComponentVariation(ped, 8, uniform.tshirt_1, uniform.tshirt_2, 2)
    SetPedComponentVariation(ped, 4, uniform.pants_1, uniform.pants_2, 2)
    SetPedComponentVariation(ped, 6, uniform.shoes_1, uniform.shoes_2, 2)
    SetPedComponentVariation(ped, 9, uniform.bproof_1, uniform.bproof_2, 2)
end
