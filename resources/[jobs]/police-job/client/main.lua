local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == 'police' then
        CreateBlip()
    end
end)

AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    if job.name == 'police' then
        CreateBlip()
    else
        RemoveBlip()
    end
end)

function CreateBlip()
    local blip = AddBlipForCoord(Config.PoliceDutyLocation.coords)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipDisplay(blip, Config.Blip.display)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipAsShortRange(blip, false)
    AddTextEntryForBlip(blip, "Police Station")
    SetBlipRoute(blip, true)
end

function RemoveBlip()
    -- Blip removal logic
end

RegisterNetEvent('police-job:client:openPoliceMenu')
AddEventHandler('police-job:client:openPoliceMenu', function()
    TriggerEvent('police-job:client:showMenu')
end)

RegisterNetEvent('police-job:client:dutyOn')
AddEventHandler('police-job:client:dutyOn', function()
    TriggerEvent('police-job:client:changeUniform')
end)

RegisterNetEvent('police-job:client:dutyOff')
AddEventHandler('police-job:client:dutyOff', function()
    -- Remove uniform and weapons
    local playerPed = PlayerPedId()
    ClearAllPedProps(playerPed)
end)
