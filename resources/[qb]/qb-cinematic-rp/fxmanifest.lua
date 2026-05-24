fx_version 'cerulean'
game 'gta5'

author 'Danger Play Zone'
description 'Advanced Cinematic RP - Complete Mission & Gang/Police System'
version '1.0.0'
repository 'https://github.com/camelgaming19-cmyk/danger-play-zone'

shared_scripts {
    'shared/config.lua',
    'shared/utils.lua'
}

client_scripts {
    'client/client.lua',
    'client/npc_system.lua',
    'client/gang_system.lua',
    'client/police_system.lua',
    'client/target_system.lua',
    'client/animations.lua',
    'client/vehicle_system.lua',
    'client/mission_system.lua'
}

server_scripts {
    'server/server.lua',
    'server/events.lua'
}
