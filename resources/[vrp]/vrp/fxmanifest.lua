fx_version 'cerulean'
game 'gta5'

author 'ZIRAFLIX'
contact 'E-mail: contato@ziraflix.com - Discord: discord.gg/ziraflix'

ui_page 'gui/index.html'

server_scripts {
	'lib/utils.lua',
	'base.lua',
	'queue.lua',
	'modules/gui.lua',
	'modules/group.lua',
	'modules/player_state.lua',
	'modules/map.lua',
	'modules/money.lua',
	'modules/inventory.lua',
	'modules/identity.lua',
	'modules/aptitude.lua',
	'modules/basic_items.lua',
	'modules/basic_skinshop.lua',
	'modules/survival.lua',
	'modules/cloakroom.lua',
	'modules/pass.lua'
}

client_scripts {
	'lib/utils.lua',
	'client/base.lua',
	'client/basic_garage.lua',
	'client/iplloader.lua',
	'client/gui.lua',
	'client/player_state.lua',
	'client/survival.lua',
	'client/map.lua',
	'client/identity.lua',
	'client/police.lua'
}

files {
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'lib/Luaseq.lua',
	'lib/Tools.lua',
	'gui/index.html',
	'gui/design.css',
	'gui/main.js',
	'gui/Menu.js',
	'gui/WPrompt.js',
	'gui/RequestManager.js',
	'gui/Div.js',
	'gui/dynamic_classes.js',
	'gui/bebas.ttf'
}

server_export 'AddPriority'
server_export 'RemovePriority'
