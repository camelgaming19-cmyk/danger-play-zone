-- Server-side events for qb-ai-menu v2.0.0

print("^2[qb-ai-menu] v2.0.0 Server script loaded successfully!^7")

-- Log NPC spawn
RegisterNetEvent('qb-ai-menu:LogSpawn', function(model)
    print("^2[qb-ai-menu] NPC spawned: " .. model .. " by " .. GetPlayerName(source) .. "^7")
end)

-- Clean up on player drop
AddEventHandler('playerDropped', function()
    print("^3[qb-ai-menu] Player disconnected^7")
end)

-- Health check
RegisterCommand('aimenustatus', function(source, args, rawCommand)
    TriggerClientEvent('chat:addMessage', source, {
        color = {0, 255, 0},
        multiline = true,
        args = {"AI Menu", "✅ Status: Online and Ready!"}
    })
end)
