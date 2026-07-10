local QBCore = exports['qb-core']:GetCoreObject()

-- Car Wash Payment Event
RegisterServerEvent('carwash:server:washCar')
AddEventHandler('carwash:server:washCar', function()
    local source = source
    local Player = QBCore.Functions.GetPlayer(source)
    
    if not Player then 
        TriggerClientEvent('QBCore:Notify', source, 'Player data not found', 'error')
        return 
    end
    
    if not Config then
        TriggerClientEvent('QBCore:Notify', source, 'Config not loaded', 'error')
        return
    end
    
    local money = Player.PlayerData.money.cash
    
    if money < Config.WashPrice then
        TriggerClientEvent('QBCore:Notify', source, 'You do not have enough money! Need: $' .. Config.WashPrice, 'error')
        TriggerClientEvent('carwash:client:washComplete', source)
        return
    end
    
    -- Remove money
    Player.Functions.RemoveMoney('cash', Config.WashPrice, 'car-wash')
    
    -- Add to database
    if exports.oxmysql then
        exports.oxmysql:execute('INSERT INTO carwash_payments (player_id, amount, timestamp) VALUES (?, ?, ?)', {
            Player.PlayerData.citizenid,
            Config.WashPrice,
            os.date('%Y-%m-%d %H:%M:%S')
        })
    end
    
    TriggerClientEvent('QBCore:Notify', source, 'Car wash started! Cost: $' .. Config.WashPrice, 'success')
    TriggerClientEvent('carwash:client:startWash', source)
end)

-- Wash Complete Event
RegisterServerEvent('carwash:server:washComplete')
AddEventHandler('carwash:server:washComplete', function()
    local source = source
    TriggerClientEvent('carwash:client:washComplete', source)
end)

-- NPC Greeting
RegisterServerEvent('carwash:server:greetPlayer')
AddEventHandler('carwash:server:greetPlayer', function()
    local source = source
    if not Config then return end
    TriggerClientEvent('carwash:client:npcTalk', source, 'Welcome to car wash! Press E to start. Cost: $' .. Config.WashPrice)
end)

-- Create tables on start
CreateThread(function()
    Wait(1000)
    
    -- Create payments table
    if exports.oxmysql then
        exports.oxmysql:execute([[
            CREATE TABLE IF NOT EXISTS `carwash_payments` (
              `id` int(11) NOT NULL AUTO_INCREMENT,
              `player_id` varchar(50) NOT NULL,
              `amount` int(11) NOT NULL,
              `timestamp` datetime DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              KEY `player_id` (`player_id`),
              KEY `timestamp` (`timestamp`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
        
        exports.oxmysql:execute([[
            CREATE TABLE IF NOT EXISTS `carwash_stats` (
              `id` int(11) NOT NULL AUTO_INCREMENT,
              `player_id` varchar(50) NOT NULL,
              `cars_washed` int(11) DEFAULT 0,
              `total_earned` int(11) DEFAULT 0,
              `last_wash` datetime DEFAULT CURRENT_TIMESTAMP,
              PRIMARY KEY (`id`),
              KEY `player_id` (`player_id`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]])
    end
end)

print('^2[CarWash]^7 Server Main Loaded!')
