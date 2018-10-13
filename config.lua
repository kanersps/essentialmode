-- Don't MODIFY, just look, MODIFY IN YOUR SERVER CONFIGURATION! --
-- Don't MODIFY, just look, MODIFY IN YOUR SERVER CONFIGURATION! --
-- Don't MODIFY, just look, MODIFY IN YOUR SERVER CONFIGURATION! --
-- Don't MODIFY, just look, MODIFY IN YOUR SERVER CONFIGURATION! --

ip = GetConvar('es_couchdb_url', '127.0.0.1') 	-- Change to wherever your DB is hosted, use convar
port = GetConvar('es_couchdb_port', '5984') 	-- Change to whatever port you have CouchDB running on, use convar
auth = GetConvar('es_couchdb_password', 'root:1202') 	-- "user:password", if you have auth setup, use convar