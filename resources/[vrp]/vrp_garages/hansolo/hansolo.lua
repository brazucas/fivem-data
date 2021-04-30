local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_garages",src)
vSERVER = Tunnel.getInterface("vrp_garages")

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local workgarage = ""
local vehicle = {}
local vehblips = {}
local pointspawn = 1

--[ SPAWN ]------------------------------------------------------------------------------------------------------------------------------

local spawn = {}

--[ FUNCTION ]---------------------------------------------------------------------------------------------------------------------------

local menuEnabled = false
function ToggleActionMenu(name,status)
	if name and status then
		workgarage = name
		pointspawn = status
	end
	menuEnabled = not menuEnabled
	if menuEnabled then
		StartScreenEffect("MenuMGSelectionIn", 0, true)
		SetNuiFocus(true,true)
		SendNUIMessage({ action = "showMenu" })
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "hideMenu" })
		StopScreenEffect("MenuMGSelectionIn")
	end
end

--[ OPENGARAGE ]-------------------------------------------------------------------------------------------------------------------------

function src.openGarage(work,number)
	ToggleActionMenu(work,parseInt(number))
end

--[ VEHICLEMODS ]------------------------------------------------------------------------------------------------------------------------

function src.vehicleMods(veh,custom)
	if custom and veh then
		SetVehicleModKit(veh,0)
		if custom.color then
			SetVehicleColours(veh,tonumber(custom.color[1]),tonumber(custom.color[2]))
			SetVehicleExtraColours(veh,tonumber(custom.extracolor[1]),tonumber(custom.extracolor[2]))
		end

		if custom.smokecolor then
			SetVehicleTyreSmokeColor(veh,tonumber(custom.smokecolor[1]),tonumber(custom.smokecolor[2]),tonumber(custom.smokecolor[3]))
		end

		if custom.neon then
			SetVehicleNeonLightEnabled(veh,0,1)
			SetVehicleNeonLightEnabled(veh,1,1)
			SetVehicleNeonLightEnabled(veh,2,1)
			SetVehicleNeonLightEnabled(veh,3,1)
			SetVehicleNeonLightsColour(veh,tonumber(custom.neoncolor[1]),tonumber(custom.neoncolor[2]),tonumber(custom.neoncolor[3]))
		else
			SetVehicleNeonLightEnabled(veh,0,0)
			SetVehicleNeonLightEnabled(veh,1,0)
			SetVehicleNeonLightEnabled(veh,2,0)
			SetVehicleNeonLightEnabled(veh,3,0)
		end

		if custom.plateindex then
			SetVehicleNumberPlateTextIndex(veh,tonumber(custom.plateindex))
		end

		if custom.windowtint then
			SetVehicleWindowTint(veh,tonumber(custom.windowtint))
		end

		if custom.bulletProofTyres then
			SetVehicleTyresCanBurst(veh,custom.bulletProofTyres)
		end

		if custom.wheeltype then
			SetVehicleWheelType(veh,tonumber(custom.wheeltype))
		end

		if custom.spoiler then
			SetVehicleMod(veh,0,tonumber(custom.spoiler))
			SetVehicleMod(veh,1,tonumber(custom.fbumper))
			SetVehicleMod(veh,2,tonumber(custom.rbumper))
			SetVehicleMod(veh,3,tonumber(custom.skirts))
			SetVehicleMod(veh,4,tonumber(custom.exhaust))
			SetVehicleMod(veh,5,tonumber(custom.rollcage))
			SetVehicleMod(veh,6,tonumber(custom.grille))
			SetVehicleMod(veh,7,tonumber(custom.hood))
			SetVehicleMod(veh,8,tonumber(custom.fenders))
			SetVehicleMod(veh,10,tonumber(custom.roof))
			SetVehicleMod(veh,11,tonumber(custom.engine))
			SetVehicleMod(veh,12,tonumber(custom.brakes))
			SetVehicleMod(veh,13,tonumber(custom.transmission))
			SetVehicleMod(veh,14,tonumber(custom.horn))
			SetVehicleMod(veh,15,tonumber(custom.suspension))
			SetVehicleMod(veh,16,tonumber(custom.armor))
			SetVehicleMod(veh,23,tonumber(custom.tires),custom.tiresvariation)
		
			if IsThisModelABike(GetEntityModel(veh)) then
				SetVehicleMod(veh,24,tonumber(custom.btires),custom.btiresvariation)
			end
		
			SetVehicleMod(veh,25,tonumber(custom.plateholder))
			SetVehicleMod(veh,26,tonumber(custom.vanityplates))
			SetVehicleMod(veh,27,tonumber(custom.trimdesign)) 
			SetVehicleMod(veh,28,tonumber(custom.ornaments))
			SetVehicleMod(veh,29,tonumber(custom.dashboard))
			SetVehicleMod(veh,30,tonumber(custom.dialdesign))
			SetVehicleMod(veh,31,tonumber(custom.doors))
			SetVehicleMod(veh,32,tonumber(custom.seats))
			SetVehicleMod(veh,33,tonumber(custom.steeringwheels))
			SetVehicleMod(veh,34,tonumber(custom.shiftleavers))
			SetVehicleMod(veh,35,tonumber(custom.plaques))
			SetVehicleMod(veh,36,tonumber(custom.speakers))
			SetVehicleMod(veh,37,tonumber(custom.trunk)) 
			SetVehicleMod(veh,38,tonumber(custom.hydraulics))
			SetVehicleMod(veh,39,tonumber(custom.engineblock))
			SetVehicleMod(veh,40,tonumber(custom.camcover))
			SetVehicleMod(veh,41,tonumber(custom.strutbrace))
			SetVehicleMod(veh,42,tonumber(custom.archcover))
			SetVehicleMod(veh,43,tonumber(custom.aerials))
			SetVehicleMod(veh,44,tonumber(custom.roofscoops))
			SetVehicleMod(veh,45,tonumber(custom.tank))
			SetVehicleMod(veh,46,tonumber(custom.doors))
			SetVehicleMod(veh,48,tonumber(custom.liveries))
			SetVehicleLivery(veh,tonumber(custom.liveries))

			ToggleVehicleMod(veh,20,tonumber(custom.tyresmoke))
			ToggleVehicleMod(veh,22,tonumber(custom.headlights))
			ToggleVehicleMod(veh,18,tonumber(custom.turbo))
		end
		--TriggerEvent('persistent-vehicles/update-vehicle', veh)
	end
end

--[ SPAWNVEHICLE ]-----------------------------------------------------------------------------------------------------------------------

local gps = {}
function src.spawnVehicle(vehname,vehengine,vehbody,vehtank,vehdirt,vehoil,vehdrvlyt,vehwheel,vehdor,vehwin,vehtyr,vehfuel,custom)
	if vehicle[vehname] == nil then
		local checkslot = 1
		local mhash = GetHashKey(vehname)
		while not HasModelLoaded(mhash) do
			RequestModel(mhash)
			Citizen.Wait(1)
		end

		if HasModelLoaded(mhash) then
			while true do
				local checkPos = GetClosestVehicle(spawn[pointspawn][checkslot].x,spawn[pointspawn][checkslot].y,spawn[pointspawn][checkslot].z,3.001,0,71)
				if DoesEntityExist(checkPos) and checkPos ~= nil then
					checkslot = checkslot + 1
					if checkslot > #spawn[pointspawn] then
						checkslot = -1
						TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.",10000)
						break
					end
				else
					break
				end
				Citizen.Wait(10)
			end

			if checkslot ~= -1 then
				local nveh = CreateVehicle(mhash,spawn[pointspawn][checkslot].x,spawn[pointspawn][checkslot].y,spawn[pointspawn][checkslot].z+0.5,spawn[pointspawn][checkslot].h,true,false)

				--TriggerEvent('persistent-vehicles/register-vehicle', nveh)

				SetVehicleIsStolen(nveh,false)
				SetVehicleNeedsToBeHotwired(nveh,false)
				SetVehicleOnGroundProperly(nveh)
				SetVehicleNumberPlateText(nveh,vRP.getPublicPlateNumber())
				SetEntityAsMissionEntity(nveh,true,true)
				SetVehRadioStation(nveh,"OFF")

				SetVehicleEngineHealth(nveh,vehengine+0.0)
				SetVehicleBodyHealth(nveh,vehbody+0.0)
				SetVehicleFuelLevel(nveh,vehfuel+0.0)

				--vehdrvlyt,vehpaslyt,vehdor,vehwin,vehtyr
				SetVehiclePetrolTankHealth(nveh, vehtank+0.0)
				SetVehicleDirtLevel(nveh, vehdirt+0.0)
				SetVehicleOilLevel(nveh, vehoil+0.0)

				if vehdor ~= 0 then
					for i = 0,4,1 do
						if vehdor[tostring(i)] then
							SetVehicleDoorBroken(nveh, i, true)
						end
					end
				end
				if vehwin ~= 0 then
					for i = 0,12,1 do
						if vehwin[tostring(i)] then
							SmashVehicleWindow(nveh, i)
						end
					end
				end
				if vehtyr ~= 0 then
					Citizen.Trace(tostring(vehtyr['0']).. "\n")
					for i = 0,6,1 do
						Citizen.Trace(tostring(vehtyr[tostring(i)]).. "\n")
						if vehtyr[tostring(i)] == 'popped' then
							SetVehicleTyreBurst(nveh, i, 0, 100.0)
						elseif vehtyr[tostring(i)] == 'gone' then
							SetVehicleTyreBurst(nveh, i, true, 1000.0)
						end
					end
				end

				src.vehicleMods(nveh,custom)
				src.syncBlips(nveh,vehname)

				vehicle[vehname] = true
				gps[vehname] = true

				SetModelAsNoLongerNeeded(mhash)

				return true,VehToNet(nveh)
			end
		end
	end
	return false
end

--[ SYNCBLIPS ---------------------------------------------------------------------------------------------------------------------------
function src.syncBlips(nveh,vehname,pos)
	--Citizen.CreateThread(function()
		gps[vehname] = true
		
		--[[if not DoesEntityExist(nveh) then
			nveh = NetToVeh(nveh)
		end]]
		print(json.encode(pos,{indent = true}))
		--while true do
			print('test ' .. tostring(DoesEntityExist(nveh)))
			if GetBlipFromEntity(nveh) == 0 and gps[vehname] ~= nil and DoesEntityExist(nveh) then
				--if DoesBlipExist(vehblips[vehname]) then RemoveBlip(vehblips[vehname]) end
				print('vapo')
				vehblips[vehname] = AddBlipForEntity(nveh)
				SetBlipSprite(vehblips[vehname],1)
				SetBlipAsShortRange(vehblips[vehname],false)
				SetBlipColour(vehblips[vehname],80)
				SetBlipScale(vehblips[vehname],0.4)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("~b~Rastreador: ~g~"..GetDisplayNameFromVehicleModel(GetEntityModel(nveh)))
				EndTextCommandSetBlipName(vehblips[vehname])
			elseif pos and gps[vehname] ~= nil then
				if DoesBlipExist(vehblips[vehname]) then
					print('entrou')
					if GetBlipCoords(vehblips[vehname]) ~= pos then SetBlipCoords(vehblips[vehname], pos.x, pos.y, pos.z) end
				else
					vehblips[vehname] = AddBlipForCoord(pos.x, pos.y, pos.z)
					SetBlipSprite(vehblips[vehname],1)
					SetBlipAsShortRange(vehblips[vehname],false)
					SetBlipColour(vehblips[vehname],80)
					SetBlipScale(vehblips[vehname],0.4)
					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString("~b~Rastreador: ~g~"..vehname)
					EndTextCommandSetBlipName(vehblips[vehname])
				end
			end
			--Citizen.Wait(100)
		--end
	--end)
end

function src.hasBlip(vehname)
	if DoesBlipExist(vehblips[vehname]) then
		return true
	else
		return false
	end
end

--[ DELETEVEHICLE -----------------------------------------------------------------------------------------------------------------------

function src.deleteVehicle(vehicle)
	if IsEntityAVehicle(vehicle) then
		vSERVER.tryDelete(VehToNet(vehicle))
	end
end

--[ DELETEVEHICLE ]----------------------------------------------------------------------------------------------------------------------

function src.removeGpsVehicle(vehname)
	if vehicle[vehname] then
		RemoveBlip(vehblips[vehname])
		vehblips[vehname] = nil
		gps[vehname] = nil
	end
end

--[ NOTEBOOKREMOVE ]---------------------------------------------------------------------------------------------------------------------

function src.freezeVehicleNotebook(vehicle)
	while not HasAnimDictLoaded(animDict) do
		RequestAnimDict(animDict)
		Citizen.Wait(1)
	end

	if IsEntityAVehicle(vehicle) then
		FreezeEntityPosition(vehicle,true)
		TaskPlayAnim(PlayerPedId(),animDict,anim,3.0,3.0,-1,49,5.0,0,0,0)
		SetTimeout(60000,function()
			FreezeEntityPosition(vehicle,false)
			StopAnimTask(PlayerPedId(),animDict,anim,1.0)
		end)
	end
end

--[ SYNCVEHICLE ]------------------------------------------------------------------------------------------------------------------------

function src.syncVehicle(vehicle)
	if NetworkDoesNetworkIdExist(vehicle) then
		local v = NetToVeh(vehicle)
		if DoesEntityExist(v) and IsEntityAVehicle(v) then
			--vehicle[GetDisplayNameFromVehicleModel(GetEntityModel(v))] = nil
			Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
			SetEntityAsMissionEntity(v,true,true)
			SetVehicleHasBeenOwnedByPlayer(v,true)
			NetworkRequestControlOfEntity(v)
			Citizen.InvokeNative(0xEA386986E786A54F,Citizen.PointerValueIntInitialized(v))
			DeleteEntity(v)
			DeleteVehicle(v)
			SetEntityAsNoLongerNeeded(v)
		end
	end
end

function src.getVehicleStates(vehicle)
	local veh = NetToVeh(vehicle)
	local states = {}
	if DoesEntityExist(veh) and IsEntityAVehicle(veh) then
		states = src.getVehicleState(veh)
		states.rotation = {}
		states.rotation.x, states.rotation.y, states.rotation.z = table.unpack(GetEntityRotation(veh))
	end
	return states
end

function src.getVehicleCustomization(veh)
	local custom = {}
  
	custom.colours = {GetVehicleColours(veh)}
	custom.extra_colours = {GetVehicleExtraColours(veh)}
	custom.plate_index = GetVehicleNumberPlateTextIndex(veh)
	custom.wheel_type = GetVehicleWheelType(veh)
	custom.tyre_armor = GetVehicleTyresCanBurst(veh)
	custom.window_tint = GetVehicleWindowTint(veh)
	custom.livery = GetVehicleLivery(veh)
	custom.neons = {}
	for i=0,3 do
	  custom.neons[i] = IsVehicleNeonLightEnabled(veh, i)
	end
	custom.neon_colour = {GetVehicleNeonLightsColour(veh)}
	custom.tyre_smoke_color = {GetVehicleTyreSmokeColor(veh)}
  
	custom.mods = {}
	for i=0,49 do
	  custom.mods[i] = GetVehicleMod(veh, i)
	end
  
	custom.turbo_enabled = IsToggleModOn(veh, 18)
	custom.smoke_enabled = IsToggleModOn(veh, 20)
	custom.xenon_enabled = IsToggleModOn(veh, 22)
  
	return custom
end

function src.getVehicleState(veh)
	local state = {
	  customization = src.getVehicleCustomization(veh),
	  condition = {
		health = GetEntityHealth(veh),
		engine_health = GetVehicleEngineHealth(veh),
		body_health = GetVehicleBodyHealth(veh),
		fuel_level = GetVehicleFuelLevel(veh),
		oil_level = GetVehicleOilLevel(veh),
		petrol_tank_health = GetVehiclePetrolTankHealth(veh),
		dirt_level = GetVehicleDirtLevel(veh)
	  }
	}
  
	state.condition.windows = {}
	for i=0,7 do
	  state.condition.windows[i] = IsVehicleWindowIntact(veh, i)
	end
  
	state.condition.tyres = {}
	for i=0,7 do
	  local tyre_state = 2 -- 2: fine, 1: burst, 0: completely burst
	  if IsVehicleTyreBurst(veh, i, true) then
		tyre_state = 0
	  elseif IsVehicleTyreBurst(veh, i, false) then
		tyre_state = 1
	  end
  
	  state.condition.tyres[i] = tyre_state
	end
  
	state.condition.doors = {}
	for i=0,5 do
	  state.condition.doors[i] = not IsVehicleDoorDamaged(veh, i)
	end
  
	state.locked = (GetVehicleDoorLockStatus(veh) >= 2)
  
	return state
end

RegisterNetEvent('applyMissingVehicleCustomizations')
AddEventHandler('applyMissingVehicleCustomizations',function(vehicleNet, state, firstspawn)
	local w = 0
	while not NetworkDoesNetworkIdExist(vehicleNet) and w < 10000 do
		Wait(10)
		w = w+1
	end
	if NetworkDoesNetworkIdExist(vehicleNet) then
		local veh = NetToVeh(vehicleNet)
		if DoesEntityExist(veh) and IsEntityAVehicle(veh) then
			--print('entrou')
			if state ~= nil then
				if state.locked ~= nil then 
					if state.locked then -- lock
						SetVehicleDoorsLocked(veh,true)
						SetVehicleDoorsLockedForAllPlayers(veh,true)
						
					else -- unlock
						SetVehicleDoorsLocked(veh,false)
						SetVehicleDoorsLockedForAllPlayers(veh,false)
					end
				end

				if state.condition then
					if state.condition.health then
						SetEntityHealth(veh, state.condition.health)
					end
				
					if state.condition.engine_health then
						SetVehicleEngineHealth(veh, state.condition.engine_health)
					end

					if state.condition.fuel_level then
						SetVehicleFuelLevel(veh,state.condition.fuel_level)
					end

					if state.condition.oil_level then
						SetVehicleOilLevel(veh, state.condition.oil_level)
					end
				
					if state.condition.petrol_tank_health then
						SetVehiclePetrolTankHealth(veh, state.condition.petrol_tank_health)
					end
					if state.condition.windows then
						for i, window_state in pairs(state.condition.windows) do
							if not window_state then
								SmashVehicleWindow(veh, parseInt(i))
							end
						end
					end
					if state.condition.tyres then
						for i, tyre_state in pairs(state.condition.tyres) do
							if tyre_state < 2 then
								SetVehicleTyreBurst(veh, parseInt(i), (tyre_state == 1), 1000.01)
							end
							
						end
					end
				end

				if GetVehicleModKit(veh) ~= 0 then
					SetVehicleModKit(veh, 0)
				end
			
				if state.customization.extra_colours then
					SetVehicleExtraColours(veh, table.unpack(state.customization.extra_colours))
				end
			
				if state.customization.plate_index then 
					SetVehicleNumberPlateTextIndex(veh, state.customization.plate_index)
				end
			
				if state.customization.wheel_type then
					SetVehicleWheelType(veh, state.customization.wheel_type)
				end

				if state.customization.tyre_armor then
					SetVehicleWheelType(veh, state.customization.tyre_armor)
				end
			
				if state.customization.window_tint then
					SetVehicleWindowTint(veh, state.customization.window_tint)
				end
			
				if state.customization.livery then
					SetVehicleLivery(veh, state.customization.livery)
				end
			
				if state.customization.neons then
					for i=0,3 do
						SetVehicleNeonLightEnabled(veh, i, state.customization.neons[i])
					end
				end
			
				if state.customization.neon_colour then
					SetVehicleNeonLightsColour(veh, table.unpack(state.customization.neon_colour))
				end
			
				if state.customization.tyre_smoke_color then
					SetVehicleTyreSmokeColor(veh, table.unpack(state.customization.tyre_smoke_color))
				end
			
				if state.customization.mods then
					for i, mod in pairs(state.customization.mods) do
						SetVehicleMod(veh, parseInt(i), mod, false)
					end
				end
			
				if state.customization.turbo_enabled ~= nil then
					ToggleVehicleMod(veh, 18, state.customization.turbo_enabled)
				end
			
				if state.customization.smoke_enabled ~= nil then
					ToggleVehicleMod(veh, 20, state.customization.smoke_enabled)
				end
			
				if state.customization.xenon_enabled ~= nil then
					ToggleVehicleMod(veh, 22, state.customization.xenon_enabled)
				end
			end

			if firstspawn then
				SetVehicleIsStolen(veh,false)
				SetVehicleNeedsToBeHotwired(veh,false)
				SetVehicleOnGroundProperly(veh)
				SetEntityAsMissionEntity(veh,true,true)
				SetVehRadioStation(veh,"OFF")

				--if state.name then
					--src.syncBlips(veh,state.name)

					vehicle[state.name] = true
					gps[state.name] = true
				--end
			end
		end
	end
end)

RegisterNetEvent('brz:sendVehicleSpawns')
AddEventHandler('brz:sendVehicleSpawns',function(spawns)
	spawn = spawns
end)

--[ SYNCNAMEDELETE ]---------------------------------------------------------------------------------------------------------------------

function src.syncNameDelete(vehname)
	print(vehname)
	if vehicle[vehname] then
		print(vehname)
		vehicle[vehname] = nil
		if DoesBlipExist(vehblips[vehname]) then
			RemoveBlip(vehblips[vehname])
			vehblips[vehname] = nil
		end
	end
end

--[ RETURNVEHICLE ]----------------------------------------------------------------------------------------------------------------------

function src.returnVehicle(name)
	return vehicle[name]
end

--[ VEHICLEANCHOR ]----------------------------------------------------------------------------------------------------------------------

local vehicleanchor = false
function src.vehicleAnchor(vehicle)
	local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),393.26,-1618.58,29.3,true)
	if IsEntityAVehicle(vehicle) then
		if distance <= 20 then
			if vehicleanchor then
				TriggerEvent("Notify","importante","Veículo destravado.",8000)
				FreezeEntityPosition(vehicle,false)
				vehicleanchor = false
			else
				TriggerEvent("Notify","importante","Veículo travado.",8000)
				FreezeEntityPosition(vehicle,true)
				vehicleanchor = true
			end
		end
	end
end

--[ BOATANCHOR ]-------------------------------------------------------------------------------------------------------------------------

local boatanchor = false
function src.boatAnchor(vehicle)
	if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) == 14 then
		if boatanchor then
			TriggerEvent("Notify","importante","Barco desancorado.",8000)
			FreezeEntityPosition(vehicle,false)
			boatanchor = false
		else
			TriggerEvent("Notify","importante","Barco ancorado.",8000)
			FreezeEntityPosition(vehicle,true)
			boatanchor = true
		end
	end
end

--[ BUTTONCLICK ]------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "exit" then
		ToggleActionMenu()
	end
end)

--[ REQUESTVEHICLES ]--------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("myVehicles",function(data,cb)
	local vehicles = vSERVER.myVehicles(workgarage)
	if vehicles then
		cb({ vehicles = vehicles })
	end
end)

--[ COOLDOWN ]---------------------------------------------------------------------------------------------------------------------------

local cooldown = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

--[ SPAWNVEHICLES ]----------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('spawnVehicles',function(data)
    if cooldown < 1 then
        cooldown = 3
		vSERVER.spawnVehicles(data.name,parseInt(pointspawn))
	end
end)

--[ DELETEVEHICLES ]---------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('deleteVehicles',function(data)
    if cooldown < 1 then
        cooldown = 3
		vSERVER.deleteVehicles()
    end
end)

--[ VEHICLECLIENTLOCK ]------------------------------------------------------------------------------------------------------------------

function src.vehicleClientLock(index,lock)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToEnt(index)
		if DoesEntityExist(v) then
			SetEntityAsMissionEntity(v,true,true)
			if lock == 1 then
				SetVehicleDoorsLocked(v,false)
				SetVehicleDoorsLockedForAllPlayers(v,false)
			else
				SetVehicleDoorsLocked(v,true)
				SetVehicleDoorsLockedForAllPlayers(v,true)
			end
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
			Wait(200)
			SetVehicleLights(v,2)
			Wait(200)
			SetVehicleLights(v,0)
		end
	end
end

--[ VEHICLECLIENTTRUNK ]-----------------------------------------------------------------------------------------------------------------

function src.vehicleClientTrunk(vehid,trunk)
	if NetworkDoesNetworkIdExist(vehid) then
		local v = NetToVeh(vehid)
		if DoesEntityExist(v) and IsEntityAVehicle(v) then
			if trunk then
				SetVehicleDoorShut(v,5,0)
			else
				SetVehicleDoorOpen(v,5,0,0)
			end
		end
	end
end

--[ BUTTONS ]----------------------------------------------------------------------------------------------------------------------------

RegisterKeyMapping('vrp_garages:lock', '[V] Trancar/destrancar veiculo', 'keyboard', 'L')

--[ BUTTONS ]----------------------------------------------------------------------------------------------------------------------------

RegisterCommand('vrp_garages:lock', function()
	local ped = PlayerPedId()
	local vehicle = vRP.getNearestVehicle(5)
	if vehicle and not IsPedInAnyVehicle(ped) then
		if cooldown < 1 then
			cooldown = 3
			vSERVER.vehicleLock()
		end
	end
end, false)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000

		if cooldown < 1 then
			local ped = PlayerPedId()
			
			if not IsPedInAnyVehicle(ped) then
				local x,y,z = table.unpack(GetEntityCoords(ped))
				for k,v in pairs(spawn) do
					if Vdist(x,y,z,v.x,v.y,v.z) <= 10.5 then
						idle = 5
						DrawMarker(23,v.x,v.y,v.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
						if Vdist(x,y,z,v.x,v.y,v.z) <= 1 then
							DrawText3D(v.x, v.y, v.z, "Pressione [~p~E~w~] para acessar o ~p~GARAGEM~w~.")
							if IsControlJustPressed(0,38) then
								vSERVER.returnHouses(v.name,k)
							end
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ SYNCDOORSEVERYONE ]------------------------------------------------------------------------------------------------------------------

function src.syncVehiclesEveryone(veh,status)
	SetVehicleDoorsLocked(veh,status)
end

--[ LIMPAR ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('limpar')
AddEventHandler('limpar',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trylimpar",VehToNet(vehicle))
	end
end)

RegisterNetEvent('synclimpar')
AddEventHandler('synclimpar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleDirtLevel(v,0.0)
				Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)

--[ REPARAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('reparar')
AddEventHandler('reparar',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("tryreparar",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncreparar')
AddEventHandler('syncreparar',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		local fuel = GetVehicleFuelLevel(v)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleFixed(v)
				--SetVehicleDirtLevel(v,0.0)
				SetVehicleUndriveable(v,false)
				Citizen.InvokeNative(0xAD738C3085FE7E11,v,true,true)
				SetVehicleOnGroundProperly(v)
				SetVehicleFuelLevel(v,fuel)
			end
		end
	end
end)

--[ REPARAR MOTOR ]----------------------------------------------------------------------------------------------------------------------

RegisterNetEvent('repararmotor')
AddEventHandler('repararmotor',function()
	local vehicle = vRP.getNearestVehicle(3)
	if IsEntityAVehicle(vehicle) then
		TriggerServerEvent("trymotor",VehToNet(vehicle))
	end
end)

RegisterNetEvent('syncmotor')
AddEventHandler('syncmotor',function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToVeh(index)
		if DoesEntityExist(v) then
			if IsEntityAVehicle(v) then
				SetVehicleEngineHealth(v,1000.0)
			end
		end
	end
end)

--[ SETLIVERY ]--------------------------------------------------------------------------------------------------------------------------

RegisterCommand("setlivery",function(source,args,custom)
	local ped = PlayerPedId()
	local vehicle = vRP.getNearestVehicle(5)
	SetVehicleLivery(vehicle,parseInt(args[1]))
end)

--[ RETURNLIVERY ]-----------------------------------------------------------------------------------------------------------------------

function src.returnlivery(vehicle,livery)
	local ped = PlayerPedId()
	local vehicle = vRP.getNearestVehicle(5)
	local livery = GetVehicleLivery(vehicle)
	return livery
end

--[ GET HASH ]---------------------------------------------------------------------------------------------------------------------------

function src.getHash(vehiclehash)
    local vehicle = vRP.getNearestVehicle(7)
    local vehiclehash = GetEntityModel(vehicle)
    return vehiclehash
end

--[ FUNÇÃO DE TEXTO ]--------------------------------------------------------------------------------------------------------------------

function DrawText3D(x,y,z, text) -- some useful function, use it if you want! 
	SetDrawOrigin(x, y, z, 0)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextScale(0.28, 0.28)
	SetTextColour(255, 255, 255, 215)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end