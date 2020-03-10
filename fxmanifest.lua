--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

fx_version 'bodacious'
games { 'gta5' }

description 'EssentialMode by Kanersps.'

server_scripts {
	'server/sqlite/SQLite.net.dll',
	'server/sqlite/sqlite.js',
	'config.lua',
	'server/util.lua',
	'server/main.lua',
	'server/db.lua',
	'server/classes/player.lua',
	'server/classes/groups.lua',
	'server/player/login.lua',
	'server/metrics.lua'
}

client_scripts {
	'client/main.lua'
}

exports {
	'getUser'
}

server_exports {
	'getPlayerFromId',
	'addAdminCommand',
	'addCommand',
	'addGroupCommand',
	'addACECommand',
	'canGroupTarget',
	'log',
	'debugMsg',
}