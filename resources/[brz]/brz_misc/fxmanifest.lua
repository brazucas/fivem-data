fx_version 'cerulean'
game 'gta5'

ui_page "nui/index.html"

client_scripts {
    '@vrp/lib/utils.lua',
    "hansolo/hansolo.lua"
}

server_scripts {
    '@vrp/lib/utils.lua',
    "skywalker.lua",
}

files {
    "nui/*",
    "nui/**/*",
    "nui/biomp/*",
    "nui/biomp/**/*",
    "nui/build/*",
    "nui/build/**/*",
    "nui/vendor/*",
    "nui/vendor/**/*",
    "nui/vendor/**/**/*",
}
