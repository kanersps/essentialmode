-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- Global variables
Users = {}
commands = {}
settings = {}
settings.defaultSettings = {
	['pvpEnabled'] = false,
	['permissionDenied'] = false,
	['debugInformation'] = false,
	['startingCash'] = 0,
	['startingBank'] = 0,
	['enableRankDecorators'] = false,
	['moneyIcon'] = "$",
	['nativeMoneySystem'] = false,
	['commandDelimeter'] = '/',
	['enableLogging'] = false,
	['enableCustomData'] = GetConvar('es_enableCustomData', 'false')
}
settings.sessionSettings = {}
commandSuggestions = {}

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function startswith(String,Start)
	return string.sub(String,1,string.len(Start))==Start
end

function returnIndexesInTable(t)
	local i = 0;
	for _,v in pairs(t)do
		i = i + 1
	end
	return i;
end

function debugMsg(msg)
	if(settings.defaultSettings.debugInformation and msg)then
		print("ES_DEBUG: " .. msg)
	end
end

function logExists(date, cb)
	Citizen.CreateThread(function()
		local log = LoadResourceFile(GetCurrentResourceName(), "logs/" .. date .. ".txt")
		if log then cb(true) else cb(false) end
		return
	end)
end

function doesLogExist(cb)
	logExists(string.gsub(os.date('%x'), '(/)', '-'), function(exists)
		Citizen.CreateThread(function()
			if not exists then
				local file = SaveResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt", '-- Begin of log for ' .. string.gsub(os.date('%x'), '(/)', '-') .. ' --\n', -1)
			end
			cb(exists)

			log('== EssentialMode started, version ' .. _VERSION .. ' ==')

			return
		end)
	end)
end
Citizen.CreateThread(function()
	if settings.defaultSettings.enableLogging then doesLogExist(function()end) end
	return
end)


function log(log)
	if settings.defaultSettings.enableLogging then
		Citizen.CreateThread(function()
			local file = LoadResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt")
			if file then
				SaveResourceFile(GetCurrentResourceName(), "logs/" .. string.gsub(os.date('%x'), '(/)', '-') .. ".txt", file .. log .. "\n", -1)
				return
			end
		end)
	end
end

AddEventHandler("es:debugMsg", debugMsg)
AddEventHandler("es:logMsg", log)