RegisterNetEvent('carwash:client:sprayWater')
AddEventHandler('carwash:client:sprayWater', function(vehicle)
    local vehCoords = GetEntityCoords(vehicle)
    
    -- Create water spray effect
    for i = 1, 30 do
        Wait(200)
        
        -- Load particle effect
        if not HasNamedPtfxAssetLoaded('core') then
            RequestNamedPtfxAsset('core')
            while not HasNamedPtfxAssetLoaded('core') do
                Wait(0)
            end
        end
        
        UseParticleFxAssetNextCall('core')
        
        -- Spray water effect around vehicle
        local particleEffect = StartParticleFxLoopedAtCoord(
            'ent_amb_water_mist',
            vehCoords.x,
            vehCoords.y,
            vehCoords.z + 2.0,
            0.0,
            0.0,
            0.0,
            1.0,
            false,
            false,
            false
        )
        
        -- Remove after short time
        Wait(500)
        StopParticleFxLooped(particleEffect, false)
    end
    
    -- Final shine effect
    UseParticleFxAssetNextCall('core')
    StartParticleFxLoopedAtCoord(
        'ent_spl_water_splash_01',
        vehCoords.x,
        vehCoords.y,
        vehCoords.z,
        0.0,
        0.0,
        0.0,
        1.0,
        false,
        false,
        false
    )
end)

print('^2[CarWash]^7 Effects System Loaded!')
