fx_version 'cerulean'

game 'gta5'

description 'Enc0ded Persistent Vehicles: https://github.com/enc0ded/enc0ded-persistent-vehicles'

version '1.0.0'

client_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'client/entityiter.lua',
	'client/_utils.lua',
	'client/main.lua',
}

server_scripts {
	'@vrp/lib/utils.lua',
	'config.lua',
	'server/main.lua',
}
