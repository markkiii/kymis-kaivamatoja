fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'markkiii / Kymis'
description 'Pohjankylä - kaiva matoja keskimaasta.'
version 'DEV'

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