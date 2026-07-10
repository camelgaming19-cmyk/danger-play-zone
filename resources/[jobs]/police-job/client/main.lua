local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}

local function CreateBlip()
    if not PlayerData.job or PlayerData.job.name ~= 'police' then return end
    
    local blip = AddBlipForCoord(Config.PoliceDutyLocation.coords)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipDisplay(blip, Config.Blip.display)
    SetBlipScale(blip, Config.Blip.scale)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipAsShortRange(blip, false)
    AddTextEntryForBlip(blip, "Police Station")
    SetBlipRoute(blip, true)
end

local function RemoveBlip()
    -- Blip removal logic here
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job and PlayerData.job.name == 'police' then
        CreateBlip()
    end
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    if job.name == 'police' then
        CreateBlip()
    else
        RemoveBlip()
    end
end)

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
    local playerPed = PlayerPedId()
    ClearAllPedProps(playerPed)
end)

RegisterNetEvent('police-job:client:showMenu')
AddEventHandler('police-job:client:showMenu', function()
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Police Menu', 'Commands: /duty, /arrest, /policewardrobe'}
    })
end)
