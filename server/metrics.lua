--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

-- Metric API
local MetricsAPIRequest = "http://127.0.0.1:8001/em/metrics?uuid=" .. _UUID

function postMetrics()
	PerformHttpRequest(MetricsAPIRequest, function(err, rText, headers) end, "POST", "", {
		pvpEnabled = settings.defaultSettings['pvpEnabled'],
		startingCash = settings.defaultSettings['startingCash'],
		startingBank = settings.defaultSettings['startingBank'],
		enableRankDecorators = settings.defaultSettings['enableRankDecorators'],
		nativeMoneySystem = settings.defaultSettings['nativeMoneySystem'],
		commandDelimeter = settings.defaultSettings['commandDelimeter'],
		enableLogging = settings.defaultSettings['enableLogging'],
		enableCustomData = settings.defaultSettings['enableCustomData'],
		defaultDatabase = settings.defaultSettings['defaultDatabase']
	})
end

-- Post metrics periodically while server is running.
Citizen.CreateThread(function()
	while true do
		postMetrics()
		Citizen.Wait(3000000)
	end
end)