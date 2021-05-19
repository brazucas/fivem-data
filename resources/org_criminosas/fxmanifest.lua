fx_version 'cerulean'
game 'gta5'

author 'German Budnikar'
contact 'Discord: GermanB#6187'

ui_page 'nui/interface.html'

client_scripts {
	'@vrp/lib/utils.lua',
	'cliente/*.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config/*.lua',
	'servidor/*.lua'
}

files {
	'nui/*.html',
	'nui/*.css',
	'nui/*.js'
}