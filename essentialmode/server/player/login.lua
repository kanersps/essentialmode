-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function LoadUser(identifier, source, new, licenseNotRequired)
	local Source = source
	db.retrieveUser(identifier, function(user)
		if user.license or licenseNotRequired then
			Users[source] = CreatePlayer(source, user.permission_level, user.money, user.bank, user.identifier, user.license, user.group, user.roles or "")
			Users[Source].setSessionVar('idType', 'identifier')
			
			TriggerEvent('es:playerLoaded', Source, Users[Source])

			log('User (' .. identifier .. ') loaded')

			TriggerClientEvent('es:setPlayerDecorator', Source, 'rank', Users[Source]:getPermissions())
			TriggerClientEvent('es:setMoneyIcon', Source,settings.defaultSettings.moneyIcon)

			for k,v in pairs(commandSuggestions) do
				TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
			end

			if new then
				TriggerEvent('es:newPlayerLoaded', Source, Users[Source])
			end
		else
			local license

			for k,v in ipairs(GetPlayerIdentifiers(Source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
					break
				end
			end

			if license then
				db.updateUser(user.identifier, {license = license}, function()
					LoadUser(user.identifier, Source, false)
				end)
			else
				LoadUser(user.identifier, Source, false, true)
			end
		end
	end)
end

function LoadLicenseUser(license, source, id)
	local Source = source
	db.retrieveLicensedUser(license, function(user)
		Users[source] = CreatePlayer(source, user.permission_level, user.money, user.bank, user.identifier, user.license, user.group)
		Users[Source].setSessionVar('idType', 'license')

		TriggerEvent('es:playerLoaded', Source, Users[Source])

		log('User (' .. license .. ') loaded')

		TriggerClientEvent('es:setPlayerDecorator', Source, 'rank', Users[Source]:getPermissions())
		TriggerClientEvent('es:setMoneyIcon', Source,settings.defaultSettings.moneyIcon)

		for k,v in pairs(commandSuggestions) do
			TriggerClientEvent('chat:addSuggestion', Source, settings.defaultSettings.commandDelimeter .. k, v.help, v.params)
		end
	end)
end

function getPlayerFromId(id)
	return Users[id]
end

AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

function registerUser(identifier, source)
	local Source = source
	db.doesUserExist(identifier, function(exists)
		if exists then
			LoadUser(identifier, Source, false)
		else
			db.createUser(identifier, license, function(r, user)
				LoadUser(identifier, Source, true)
			end)
			--[[
			local license

			for k,v in ipairs(GetPlayerIdentifiers(Source))do
				if string.sub(v, 1, string.len("license:")) == "license:" then
					license = v
					break
				end
			end

			if license then
				db.doesLicensedUserExist(license, function(exists)
					if exists then
						LoadLicenseUser(license, Source, identifier)
					else
						db.createUser(identifier, license, function(r, user)
							LoadUser(identifier, Source, true)
						end)
					end
				end)
			else
				db.createUser(identifier, "", function(r, user)
					LoadUser(identifier, Source, true)
				end)
			end
			]]
		end
	end)
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		if(Users[user].get(k))then
			if(k ~= "money") then
				Users[user].set(k, v)

				db.updateUser(Users[user].get('identifier'), {[k] = v}, function(d)
					if d == true then
						cb("Player data edited", true)
					else
						cb(d, false)
					end
				end)
			end

			if(k == "group")then
				Users[user].set(k, v)
			end
		else
			cb("Column does not exist!", false)
		end
	else
		cb("User could not be found!", false)
	end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb("Player data edited.", true)
	end)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
	SetTimeout(60000, function()
		Citizen.CreateThread(function()
			for k,v in pairs(Users)do
				if Users[k] ~= nil then
					db.updateUser(v.get('identifier'), {money = v.getMoney(), bank = v.getBank()}, function()end)
				end
			end

			savePlayerMoney()
		end)
	end)
end

savePlayerMoney()