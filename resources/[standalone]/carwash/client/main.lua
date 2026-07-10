local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local CurrentWashLocation = nil

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    CreateBlips()
end)

AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
end)

-- Create Blips
function CreateBlips()
    for _, location in ipairs(Config.CarWashLocations) do
        local blip = AddBlipForCoord(location.coords)
        SetBlipSprite(blip, Config.Blip.sprite)
        SetBlipDisplay(blip, Config.Blip.display)
        SetBlipScale(blip, Config.Blip.scale)
        SetBlipColour(blip, Config.Blip.color)
        SetBlipAsShortRange(blip, false)
        AddTextEntryForBlip(blip, location.name)
        SetBlipRoute(blip, true)
    end
end

-- Car Wash Location Marker
CreateThread(function()
    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        for i, location in ipairs(Config.CarWashLocations) do
            local distance = #(playerCoords - location.coords)
            
            if distance < 30 then
                DrawMarker(2, location.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 0, 150, 255, 100, false, true, 2, false, nil, nil, false)
            end
            
            if distance < location.radius then
                CurrentWashLocation = i
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, '[E] Wash Car - $' .. Config.WashPrice)
                
                if IsControlJustPressed(0, 38) then -- E Key
                    StartCarWash(i)
                end
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local camCoords = GetGameplayCamCoords()
    local distance = #(vector3(x, y, z) - camCoords)
    
    if distance > 50 then return end
    
    local scale = 0.35 * (distance / 10)
    if scale > 0.55 then scale = 0.55 end
    
    SetTextScale(scale, scale)
    SetTextFont(0)
    SetTextProxyActive(true)
    SetDrawOrigin(x, y, z, 0)
    SetTextCentre(true)
    SetTextColour(255, 255, 255, 200)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function StartCarWash(locationIndex)
    local location = Config.CarWashLocations[locationIndex]
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if not vehicle or vehicle == 0 then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Car Wash', 'You must be in a vehicle!'}
        })
        return
    end
    
    -- Start washing
    TriggerServerEvent('carwash:server:washCar')
end

print('^2[CarWash]^7 Client Main Loaded!')
