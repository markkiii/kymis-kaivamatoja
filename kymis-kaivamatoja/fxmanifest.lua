fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'markkiii / Kymis'
description 'Kaiva matoja keskimaasta.'
version '1.0.0'

client_scripts {
    'client/digging_worms.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    'server/digging_worms.lua'
}

dependencies {
    'ox_lib'
}
