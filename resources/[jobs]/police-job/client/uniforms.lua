local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('police-job:client:openWardrobe')
AddEventHandler('police-job:client:openWardrobe', function()
    local playerPed = PlayerPedId()
    local isMale = GetEntityModel(playerPed) == GetHashKey("a_m_m_business_1")
    
    -- Apply uniform
    if isMale then
        ApplyUniform(playerPed, Config.Uniforms.duty.male)
    else
        ApplyUniform(playerPed, Config.Uniforms.duty.female)
    end
    
    TriggerEvent('QBCore:Notify', 'Uniform changed', 'success')
end)

function ApplyUniform(ped, uniform)
    ClearAllPedProps(ped)
    
    -- Apply clothing
    SetPedComponentVariation(ped, 11, uniform.torso_1, uniform.torso_2, 2)
    SetPedComponentVariation(ped, 8, uniform.tshirt_1, uniform.tshirt_2, 2)
    SetPedComponentVariation(ped, 4, uniform.pants_1, uniform.pants_2, 2)
    SetPedComponentVariation(ped, 6, uniform.shoes_1, uniform.shoes_2, 2)
    SetPedComponentVariation(ped, 9, uniform.bproof_1, uniform.bproof_2, 2)
    SetPedComponentVariation(ped, 1, uniform.mask_1, uniform.mask_2, 2)
    
    -- Add accessories
    if uniform.chain_1 ~= -1 then
        SetPedComponentVariation(ped, 7, uniform.chain_1, uniform.chain_2, 2)
    end
    
    -- Add weapons
    GiveWeaponToPed(ped, GetHashKey('WEAPON_PISTOL'), 120, false, true)
    GiveWeaponToPed(ped, GetHashKey('WEAPON_NIGHTSTICK'), 1, false, true)
end
