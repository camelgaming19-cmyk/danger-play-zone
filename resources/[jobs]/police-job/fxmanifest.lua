fx_version 'cerulean'
game 'gta5'

author 'Police Job Script'
description 'Complete QBCore Police Job with Duty System, Arrests, Salary & Uniforms'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/duty.lua',
    'server/arrest.lua',
    'server/salary.lua'
}

client_scripts {
    'client/main.lua',
    'client/duty.lua',
    'client/arrest.lua',
    'client/uniforms.lua'
}

escrow_ignore {
    'locales/*',
    'config.lua',
    'client/*.lua',
    'server/*.lua'
}
