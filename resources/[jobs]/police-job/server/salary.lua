local QBCore = exports['qb-core']:GetCoreObject()

local DutyTimes = {}

TriggerEvent('QBCore:AddCommand', 'paysalary', 'Pay all on-duty police officers', {}, true, function(source, args, rawCommand)
    PayPoliceOfficers()
end)

function PayPoliceOfficers()
    local police = QBCore.Functions.GetPlayersWithJob('police')
    
    for _, playerId in ipairs(police) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            -- Check if on duty
            local isDuty = exports['police-job']:getDutyStatus(playerId)
            
            if isDuty then
                -- Calculate salary
                local baseSalary = math.random(Config.Salary.minimum, Config.Salary.maximum)
                local dutyBonus = Config.Salary.dutyBonus
                local totalSalary = baseSalary + dutyBonus
                
                -- Add money to player
                Player.Functions.AddMoney('bank', totalSalary, 'Police Salary')
                
                TriggerClientEvent('QBCore:Notify', playerId, 'Salary Paid: $' .. baseSalary .. ' + $' .. dutyBonus .. ' Bonus = $' .. totalSalary, 'success')
                
                -- Log salary
                MySQL.Async.execute('INSERT INTO police_salary (player_id, base_salary, bonus, total, timestamp) VALUES (?, ?, ?, ?, ?)', {
                    Player.PlayerData.citizenid,
                    baseSalary,
                    dutyBonus,
                    totalSalary,
                    os.date('%Y-%m-%d %H:%M:%S')
                })
            end
        end
    end
end

-- Auto pay every 30 minutes (1800 seconds)
SetInterval(1800000, function()
    PayPoliceOfficers()
end)
