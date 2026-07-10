local QBCore = exports['qb-core']:GetCoreObject()

-- Car Wash Payment Event
RegisterServerEvent('carwash:server:washCar')
AddEventHandler('carwash:server:washCar', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then return end
    
    local money = Player.PlayerData.money.cash
    
    if money < Config.WashPrice then
        TriggerClientEvent('QBCore:Notify', source, 'You do not have enough money!', 'error')
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', Config.WashPrice, 'car-wash')
    
    -- Add to bank
    if MySQL then
        MySQL.Async.execute('INSERT INTO carwash_payments (player_id, amount, timestamp) VALUES (?, ?, ?)', {
            Player.PlayerData.citizenid,
            Config.WashPrice,
            os.date('%Y-%m-%d %H:%M:%S')
        })
    end
    
    TriggerClientEvent('QBCore:Notify', source, 'Car wash started! Pay: $' .. Config.WashPrice, 'success')
    TriggerClientEvent('carwash:client:startWash', source)
end)

-- NPC Greeting
RegisterServerEvent('carwash:server:greetPlayer')
AddEventHandler('carwash:server:greetPlayer', function()
    local source = source
    TriggerClientEvent('carwash:client:npcTalk', source, 'Welcome to car wash! Press E to start. Cost: $' .. Config.WashPrice)
end)

-- Logs
print('^2[CarWash]^7 Car Wash System Loaded!')
