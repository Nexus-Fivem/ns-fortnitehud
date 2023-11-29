fx_version "adamant"
game "gta5"

author 'berxt.ogg & torpak.'
description 'Fortnite Inspired Hud by Nexus'
version '1.0.0'

ui_page "ui/index.html"
files {
    "ui/**/**",
}

shared_scripts {
	'config.lua'
}

client_scripts {
	"cl.lua"
}

server_scripts {
	'sv.lua'
}

