-- ============================================
-- CINEMATIC RP - Server Side
-- ============================================

print("^2[Cinematic RP] v1.0.0 Server starting...^7")

local QBCore = nil

-- Try to get QBCore
if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

if QBCore then
    print("^2[Cinematic RP] QBCore loaded!^7")
else
    print("^3[Cinematic RP] QBCore not available - Running in standalone mode^7")
end

-- Server events
RegisterNetEvent('qb-cinematic-rp:server:missionComplete', function(missionType, reward)
    local src = source
    
    print("^2[Cinematic RP] Mission completed by player " .. src .. " - Type: " .. missionType .. "^7")
    
    if QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddMoney('cash', reward)
        end
    end
end)

RegisterNetEvent('qb-cinematic-rp:server:logEvent', function(eventType, details)
    print("^2[Cinematic RP] Event: " .. eventType .. " - " .. details .. "^7")
end)

print("^2[Cinematic RP] Server script loaded successfully!^7")
