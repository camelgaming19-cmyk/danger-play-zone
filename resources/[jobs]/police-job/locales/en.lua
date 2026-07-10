local Translations = {
    success = {
        duty_on = 'You are now on duty',
        duty_off = 'You are now off duty',
        arrested = 'Player arrested and taken to jail',
        salary_paid = 'You received $%s salary + $%s bonus',
        uniform_changed = 'You changed into your uniform'
    },
    error = {
        not_police = 'You are not a police officer',
        already_on_duty = 'You are already on duty',
        already_off_duty = 'You are already off duty',
        too_far = 'You are too far away',
        player_not_found = 'Player not found',
        invalid_command = 'Invalid command'
    },
    info = {
        duty_menu = 'Police Duty Menu',
        join_duty = 'Join Duty',
        leave_duty = 'Leave Duty',
        arrest_player = 'Arrest Player',
        pay_fine = 'Pay Fine',
        duty_time = 'Duty Time: %s minutes'
    }
}

if GetConvar('qb_locale', 'en') == 'en' then
    TriggerEvent('qb-locale:getTranslation', function(cb)
        Translations = cb
    end)
end

return Translations
