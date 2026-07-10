local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local InDutyZone = false
local OnDuty = false
local MenuOpen = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
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
                if distToDuty < 2 and not MenuOpen then
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
        OnDuty = isDuty
        
        TriggerEvent('chat:addMessage', {
            color = {0, 255, 0},
            multiline = true,
            args = {'Police', isDuty and 'Press E to LEAVE DUTY' or 'Press E to JOIN DUTY'}
        })
    end)
end)

-- Press E to toggle duty with menu
RegisterKeyMapping('toggleduty', 'Toggle Police Duty', 'keyboard', 'E')

RegisterCommand('toggleduty', function()
    if InDutyZone and PlayerData.job and PlayerData.job.name == 'police' then
        OpenDutyMenu()
    else
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {'Police', 'You must be at police station!'}
        })
    end
end, false)

function OpenDutyMenu()
    MenuOpen = true
    QBCore.Functions.TriggerCallback('police-job:getDutyStatus', function(isDuty)
        OnDuty = isDuty
        
        local menuOptions = {
            {
                header = "Police Duty",
                isMenuHeader = true,
            },
        }
        
        if OnDuty then
            table.insert(menuOptions, {
                header = "Leave Duty",
                txt = "Go off duty and remove uniform",
                params = {
                    event = "police-job:client:leaveDuty"
                }
            })
        else
            table.insert(menuOptions, {
                header = "Join Duty",
                txt = "Put on uniform and go on duty",
                params = {
                    event = "police-job:client:joinDuty"
                }
            })
        end
        
        table.insert(menuOptions, {
            header = "Close",
            txt = "Close Menu",
            params = {
                event = "police-job:client:closeMenu"
            }
        })
        
        exports['qb-menu']:openMenu(menuOptions)
        MenuOpen = false
    end)
end

RegisterNetEvent('police-job:client:joinDuty')
AddEventHandler('police-job:client:joinDuty', function()
    TriggerServerEvent('police-job:server:toggleDuty')
end)

RegisterNetEvent('police-job:client:leaveDuty')
AddEventHandler('police-job:client:leaveDuty', function()
    TriggerServerEvent('police-job:server:toggleDuty')
end)

RegisterNetEvent('police-job:client:closeMenu')
AddEventHandler('police-job:client:closeMenu', function()
    exports['qb-menu']:closeMenu()
end)

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
    
    -- Give weapons
    GiveWeaponToPed(ped, GetHashKey('WEAPON_PISTOL'), 120, false, true)
    GiveWeaponToPed(ped, GetHashKey('WEAPON_NIGHTSTICK'), 1, false, true)
end
