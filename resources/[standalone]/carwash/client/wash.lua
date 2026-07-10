local isWashing = false

RegisterNetEvent('carwash:client:startWash')
AddEventHandler('carwash:client:startWash', function()
    if isWashing then return end
    
    isWashing = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if not vehicle or vehicle == 0 then
        isWashing = false
        return
    end
    
    -- Stop vehicle
    SetVehicleEngineHealth(vehicle, 1000.0)
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    SmashVehicleWindow(vehicle, 2)
    SmashVehicleWindow(vehicle, 3)
    
    -- Play motor sound
    PlayMotorSound()
    
    -- Water animation
    TriggerEvent('carwash:client:sprayWater', vehicle)
    
    -- Wait for wash duration
    Wait(Config.WashDuration * 1000)
    
    -- Clean vehicle
    SetVehicleDeformationFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SmashVehicleWindow(vehicle, 0)
    SmashVehicleWindow(vehicle, 1)
    SmashVehicleWindow(vehicle, 2)
    SmashVehicleWindow(vehicle, 3)
    WashDecalsFromVehicle(vehicle, 1.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Car Wash', 'Your car is clean! Thank you!'}
    })
    
    isWashing = false
end)

function PlayMotorSound()
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
end

print('^2[CarWash]^7 Wash System Loaded!')
