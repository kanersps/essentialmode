--       Licensed under: AGPLv3        --
--  GNU AFFERO GENERAL PUBLIC LICENSE  --
--     Version 3, 19 November 2007     --

local enablePositionSending = true
local UpdateTickTime = 5000
CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('es:firstJoinProper')
			TriggerEvent('es:allowedToSpawn')
			return
		end
	end
end)

local oldPos = vector3(0, 0, 0)
CreateThread(function()
	while enablePositionSending do
		Wait(UpdateTickTime)
		local playerPed = PlayerPedId()
		local pos = GetEntityCoords(playerPed)
		if #(oldPos - pos) > 10 then
			TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)
			oldPos = pos
		end
	end
end)

local myDecorators = {}
RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
		DecorSetInt(PlayerPedId(), key, value)
	end
end)

AddEventHandler("playerSpawned", function()
	for k,v in pairs(myDecorators)do
		DecorSetInt(PlayerPedId(), k, v)
	end

	TriggerServerEvent('playerSpawn')
end)

RegisterNetEvent("es:disableClientPosition")
AddEventHandler("es:disableClientPosition", function()
	enablePositionSending = false
end)
