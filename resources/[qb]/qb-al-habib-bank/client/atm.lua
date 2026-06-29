-- ============================================
-- AL HABIB BANK - ATM System
-- ============================================

local QBCore = exports['qb-core']:GetCoreObject()

-- ATM animation
function PlayATMAnimation()
    local playerPed = PlayerPedId()
    
    RequestAnimDict('amb@prop_human_atm@male@into')
    while not HasAnimDictLoaded('amb@prop_human_atm@male@into') do
        Wait(10)
    end
    
    TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@into', 'enter', 8.0, -8.0, 1000, 0, 0, false, false, false)
    
    Wait(1000)
    
    RequestAnimDict('amb@prop_human_atm@male@base')
    while not HasAnimDictLoaded('amb@prop_human_atm@male@base') do
        Wait(10)
    end
    
    TaskPlayAnim(playerPed, 'amb@prop_human_atm@male@base', 'base', 8.0, -8.0, 3000, 49, 0, false, false, false)
end

print("^2[Bank Al Habib] ATM system loaded!^7")
