local hora = 6
local minuto = 20
--local currentweather = "EXRTASUNNY"
--local lastWeather = currentweather
local activeWeather = {}
local lastZone = 0

--[ UPDATEWEATHER ]----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vrp_misc:updateWeather")
AddEventHandler("vrp_misc:updateWeather",function(activeWeathers)
	activeWeather = activeWeathers
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000 * 60)
		TriggerServerEvent("dinoweather:syncWeather")
	end
end)

--[ FUNCTIONWEATHER ]--------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlayerId())))
		local zone = GetNameOfZone(x, y, z)
		for i, weatherZone in ipairs(activeWeather) do
		  if weatherZone[1] == zone and lastZone ~= zone then
			Citizen.Wait(15000)
			ClearOverrideWeather()
			ClearWeatherTypePersist()
			SetWeatherTypeOverTime(weatherZone[2], 15.0)
			SetWeatherTypePersist(weatherZone[2])
			SetWeatherTypeNow(weatherZone[2])
			SetWeatherTypeNowPersist(weatherZone[2])
			TriggerEvent("chatMessage", "^1Clima atual: "..weatherZone[2])
			lastZone = zone
		  end
		end
	end
end)

RegisterCommand("SetZoneWeather", function(source, args, rawCommand)
	if args[1] == nil then
	  TriggerEvent("chatMessage", "^1Você não especificou o clima.")
	else
	  for i, weatherType in ipairs(WeatherConfig.weatherTypes) do
		if weatherType == args[1] then
		  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(PlayerId())))
		  local zoneName = GetNameOfZone(x, y, z)
		  TriggerServerEvent("dinoweather:setWeatherInZone", zoneName, weatherType)
		  return
		end
	  end
	  TriggerEvent("chatMessage", "^3O tipo de clima que você escreveu não existe!")
	end
end, false)

--[ PLAYERSPAWNED ]----------------------------------------------------------------------------------------------------------------------

AddEventHandler("playerSpawned",function()
	TriggerServerEvent("vrp_misc:requestSync")
end)

--[ SYNCTIMERS ]-------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("vrp_misc:syncTimers")
AddEventHandler("vrp_misc:syncTimers",function(timer)
	hora = timer[2]
	minuto = timer[1]
end)

--[ NETWORKCLOCK ]-----------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		NetworkOverrideClockTime(hora,minuto,00)
	end
end)