-- ============================================
-- CINEMATIC RP - Server Events
-- ============================================

local QBCore = nil

if GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
end

-- NPC death event
RegisterNetEvent('qb-cinematic-rp:server:npcDied', function(npcEntity)
    print("^1[Cinematic RP] NPC died: " .. npcEntity .. "^7")
end)

-- Player arrested event
RegisterNetEvent('qb-cinematic-rp:server:playerArrested', function(player, officer)
    print("^3[Cinematic RP] Player " .. player .. " arrested by " .. officer .. "^7")
end)

-- Gang activity event
RegisterNetEvent('qb-cinematic-rp:server:gangActivity', function(gang, activity)
    print("^1[Cinematic RP] Gang Activity - " .. gang .. ": " .. activity .. "^7")
end)

-- Police activity event
RegisterNetEvent('qb-cinematic-rp:server:policeActivity', function(activity)
    print("^2[Cinematic RP] Police Activity: " .. activity .. "^7")
end)

print("^2[Cinematic RP] Server events loaded!^7")
