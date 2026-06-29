fx_version 'cerulean'
game 'gta5'

author 'Al Habib Bank System'
description 'Al Habib Bank - Complete Banking System with QBCore Integration'
version '1.0.0'
repository 'https://github.com/camelgaming19-cmyk/danger-play-zone'

shared_scripts {
    'shared/config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/main.lua',
    'client/menu.lua',
    'client/banking.lua',
    'client/atm.lua',
    'client/target.lua'
}

server_scripts {
    'server/main.lua',
    'server/banking.lua',
    'server/events.lua',
    'server/database.lua'
}

dependencies {
    'qb-core',
    'qb-target'
}
