local isWashing = false

RegisterNetEvent('carwash:client:startWash')
AddEventHandler('carwash:client:startWash', function()
    if isWashing then return end
    if not Config then return end
    
    isWashing = true
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if not vehicle or vehicle == 0 then
        isWashing = false
        return
    end
    
    TriggerEvent('chat:addMessage', {
        color = {0, 150, 255},
        multiline = true,
        args = {'Car Wash', 'Starting wash... Please wait ' .. Config.WashDuration .. ' seconds'}
    })
    
    -- Play motor sound
    PlayMotorSound()
    
    -- Water animation
    TriggerEvent('carwash:client:sprayWater', vehicle)
    
    -- Wait for wash duration
    Wait(Config.WashDuration * 1000)
    
    -- Clean vehicle
    if DoesEntityExist(vehicle) then
        SetVehicleDeformationFixed(vehicle)
        SetVehicleEngineHealth(vehicle, 1000.0)
        WashDecalsFromVehicle(vehicle, 1.0)
        SetVehicleDirtLevel(vehicle, 0.0)
        
        -- Clean all windows
        for i = 0, 3 do
            if IsVehicleWindowIntact(vehicle, i) then
                RollDownWindow(vehicle, i)
            end
        end
    end
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 0},
        multiline = true,
        args = {'Car Wash', 'Your car is clean! Thank you for using Car Wash!'}
    })
    
    TriggerServerEvent('carwash:server:washComplete')
    isWashing = false
end)

function PlayMotorSound()
    PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', true)
end

print('^2[CarWash]^7 Wash System Loaded!')
