fx_version 'cerulean'
game 'gta5'

author 'Car Wash System'
description 'Complete Car Wash System with NPC, Animations, Payment, and Effects'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

client_scripts {
    'client/main.lua',
    'client/npc.lua',
    'client/wash.lua',
    'client/effects.lua'
}

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'server/*.lua'
}
