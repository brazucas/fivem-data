fx_version 'bodacious'
game 'gta5'

name 'prof_motoristaPub'
description ''

server_scripts {
	'@vrp/lib/utils.lua',
	'config/config.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'config/unloadType.lua',
    'config/busType.lua',
    'config/routes/*.lua',
    'config/config.lua',
    'client/*.lua',
}

files {
    'html/*.*'
}
