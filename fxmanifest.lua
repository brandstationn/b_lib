fx_version 'cerulean'
game 'gta5'
version '1.0.5'
name '^2b_lib'
author 'brandstation'
description 'Library to run ^2brandstations^1 FiveM resources'

lua54 'yes'

dependencys {
    'oxmysql' -- This can be oxmysql or mysql-async, i recommend oxmysql for better performance!
}

shared_scripts {
    'shared/*',
    'shared/auto_fetch/*',
}

client_scripts {
    'client/Funcs/*',
    'client/lib.lua',

    'client/Inits/Framework/Custom.lua',
    --'client/Inits/Framework/ESX.lua',
    --'client/Inits/Framework/QBCore.lua',
    'client/cl_callbacks.lua',
    'client/Inits/Funcs/*',
}

server_scripts {
    'wrapper.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/Config/*',
    'server/lib.lua',

    'server/Inits/Framework/Custom.lua',
    --'server/Inits/Framework/ESX.lua',
    --'server/Inits/Framework/QBCore.lua',
    'client/sv_callbacks.lua',
    'server/Inits/Funcs/*',
}

files {
    'import.lua'
}
