--$$$$$$$\  $$\      $$\       $$$$$$$$\ $$\   $$\  $$$$$$\  $$\      $$\   $$\  $$$$$$\  $$$$$$\ $$\    $$\ $$$$$$$$\      $$$$$$\   $$$$$$\  $$$$$$$\  $$$$$$\ $$$$$$$\ $$$$$$$$\  $$$$$$\  
--$$  ____| $$$\    $$$ |      $$  _____|$$ |  $$ |$$  __$$\ $$ |     $$ |  $$ |$$  __$$\ \_$$  _|$$ |   $$ |$$  _____|    $$  __$$\ $$  __$$\ $$  __$$\ \_$$  _|$$  __$$\\__$$  __|$$  __$$\ 
--$$ |      $$$$\  $$$$ |      $$ |      \$$\ $$  |$$ /  \__|$$ |     $$ |  $$ |$$ /  \__|  $$ |  $$ |   $$ |$$ |          $$ /  \__|$$ /  \__|$$ |  $$ |  $$ |  $$ |  $$ |  $$ |   $$ /  \__|
--$$$$$$$\  $$\$$\$$ $$ |      $$$$$\     \$$$$  / $$ |      $$ |     $$ |  $$ |\$$$$$$\    $$ |  \$$\  $$  |$$$$$\ $$$$$$\\$$$$$$\  $$ |      $$$$$$$  |  $$ |  $$$$$$$  |  $$ |   \$$$$$$\  
--\_____$$\ $$ \$$$  $$ |      $$  __|    $$  $$<  $$ |      $$ |     $$ |  $$ | \____$$\   $$ |   \$$\$$  / $$  __|\______|\____$$\ $$ |      $$  __$$<   $$ |  $$  ____/   $$ |    \____$$\ 
--$$\   $$ |$$ |\$  /$$ |      $$ |      $$  /\$$\ $$ |  $$\ $$ |     $$ |  $$ |$$\   $$ |  $$ |    \$$$  /  $$ |          $$\   $$ |$$ |  $$\ $$ |  $$ |  $$ |  $$ |        $$ |   $$\   $$ |
--\$$$$$$  |$$ | \_/ $$ |      $$$$$$$$\ $$ /  $$ |\$$$$$$  |$$$$$$$$\\$$$$$$  |\$$$$$$  |$$$$$$\    \$  /   $$$$$$$$\     \$$$$$$  |\$$$$$$  |$$ |  $$ |$$$$$$\ $$ |        $$ |   \$$$$$$  |
-- \______/ \__|     \__|      \________|\__|  \__| \______/ \________|\______/  \______/ \______|    \_/    \________|     \______/  \______/ \__|  \__|\______|\__|        \__|    \______/                                                                                                                                                                                           
-- discord.gg/fivemscripts
fx_version 'adamant'

games { 'gta5' }

lua54 'yes'

client_scripts {
	'Client/Commands.lua',
	'Client/Functions.lua',
	'Client/Main.lua',
	'Client/Games/*.lua',
	'Client/Locales/*.lua',
}

server_scripts {
	'Server/Functions.lua',
	'Server/Main.lua',
	'Server/Games/*.lua'
}

shared_scripts {
	'config.lua'
}

ui_page 'ui/index.html'

files {
    "ui/index.html",
	"ui/style.css",
	"ui/*.js",
	"ui/games/**/*.js",
	"ui/games/**/*.css",
	"ui/imgs/**",
	"ui/fonts/**"
}

version '1.0'

escrow_ignore {
	'config.lua',
	'Client/Commands.lua',
	'Client/Functions.lua',
	'Client/Main.lua',
	'Client/Games/*.lua',
	'Client/Locales/*.lua',
	'Server/Functions.lua',
	'Server/Main.lua',
	'Server/Games/*.lua',
}
dependency '/assetpacks'