fx_version "adamant"
games {"rdr3"}
lua54 'yes'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'HerrScaletta | Old West Creations'
version '1.0'

client_scripts {
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
}

shared_scripts {
 	'config.lua',
}

escrow_ignore {
    'config.lua',
}