local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

prof = Tunnel.getInterface("prof_pizzaboy")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = false
local working = false
local onTrash = false
local pizzaHand = false
local trashSpawn = false
local onRota = false
local onLocal = false
local trashOn = false
local selected = 0
local hour = 0
local objPizza = 0
local currentAnimDict = 'friends@frj@ig_1'
local currentAnimName = ''
local ClientePizza = nil
local recebeuPizzaCliente = false
local indoEntregarPizza = false
local spawnCliente = {}
local proximoAoCliente = false

local coordX = -349.99
local coordY = -1569.89
local coordZ = 25.23

local locs = {
	{1088.57666015625, -775.6830444335938, 58.27894973754883 - 1.0},
	{965.6817626953125, -542.8438720703125, 59.35910415649414 - 1.0},
	{335.56005859375, -1994.968505859375, 24.05843162536621 - 1.0},
	{182.77108764648438, -2028.3824462890625, 18.263368606567383- 1.0},
	{23.593910217285156, -1896.2718505859375, 22.959613800048828- 1.0},
	{-215.8455352783203, -1576.7032470703125, 38.05450439453125- 1.0},
	{-233.88204956054688, -1490.5948486328125, 32.959999084472656- 1.0},
	{-233.88204956054688, -1490.5948486328125, 32.959999084472656- 1.0},
	{-233.88204956054688, -1490.5948486328125, 32.959999084472656- 1.0},
	{-50.6439208984375, -1058.7657470703125, 27.80057716369629- 1.0},
	{7.321916103363037, -934.9170532226562, 29.905006408691406- 1.0},
	{43.98210906982422, -997.8931884765625, 29.33529281616211- 1.0},
	{329.2203369140625, -800.7277221679688, 29.266511917114258- 1.0},
	{499.20916748046875, -550.6196899414062, 24.751144409179688- 1.0},
	{-116.88402557373047, -605.9456787109375, 36.280731201171875- 1.0},
	{-236.06173706054688, -340.5564880371094, 30.06034278869629- 1.0},
	{-273.194580078125, 28.278846740722656, 54.75250244140625- 1.0},
	{-354.5012512207031, 213.75892639160156, 86.69738006591797- 1.0},
	{-627.8850708007812, 169.58694458007812, 61.15936279296875- 1.0},
	{-1038.44140625, 222.16720581054688, 64.37574005126953- 1.0},
	{-1383.516357421875, 267.3495788574219, 61.23878860473633- 1.0},
	{-1408.2099609375, -109.1984634399414, 51.66018295288086- 1.0},
	{-1821.6806640625, -405.6352233886719, 46.48472595214844- 1.0},
	{-1870.402587890625, -588.2653198242188, 11.859622955322266- 1.0},
	{-3023.957763671875, 80.33596801757812, 11.608119010925293- 1.0},
	{-1753.341064453125, -724.4586181640625, 10.383560180664062- 1.0},
	{-1351.4373779296875, -1128.50146484375, 4.119728088378906- 1.0},
	{-1031.612060546875, -1620.593017578125, 5.0097150802612305- 1.0}
}

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

function CalculateTimeToDisplay()
	hour = GetClockHours()
	if hour <= 9 then
		hour = "0" .. hour
	end
end

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand("pizzaboy", function(source, args)
    if not working then
		working = true
		--vRP._playAnim(true,{{"anim@heists@box_carry@","idle"}},true)
		--SetTaskWalk(ClientePizza, spawnCliente[1], spawnCliente[2], spawnCliente[3], 15.0)
		--TaskWanderStandard(ClientePizza)
		TriggerEvent("Notify","importante","Você está trabalhando como pizzaboy.",1000)
	else
		working = false
		--vRP._stopAnim(false)
		TriggerEvent("Notify","importante","Você não está mais trabalhando como pizzaboy.",1000)
	end
end) 

RegisterCommand("botzao", function(source, args)
	local hash = GetHashKey("a_m_y_business_01")
	RequestModel(hash)
	while not HasModelLoaded(hash) do
		Wait(1)
	end
	
	local npc = CreatePed(4, hash, -1794.861, -706.5963, 10.10494,60.0, true, false)
	
	TaskWanderInArea(npc, -1794.861, -706.5963, 10.10494, 15.0, 0.0, 2.5)
end) 


RegisterCommand("testepizza", function(source, args)
	spawnCliente = locs[ math.random( #locs ) ]
	if DoesBlipExist(blips) then RemoveBlip(blips) end
	if DoesEntityExist(ClientePizza) then DeletePed(ClientePizza) end
	indoEntregarPizza = true
	createBlip(spawnCliente[1], spawnCliente[2], spawnCliente[3])
	--CriarClientePizza(4,"a_m_y_business_01")
    --TriggerEvent("chatMessage", '', { 0, 0x99, 255}, "" .. tostring(GetEntityModel(objPizza)) )
end)
--[[Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(coordX,coordY,coordZ)
			local distance = GetDistanceBetweenCoords(coordX,coordY,cdz,x,y,z,true)
			if distance < 10.1 then
				idle = 5
				DrawMarker(23,coordX,coordY,coordZ-0.99,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
				
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coordX, coordY, coordZ, true ) < 1.3 then
					DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para iniciar a coleta de ~p~LIXO~w~.")
				end
				
				if distance < 1.1 then
					if IsControlJustPressed(1,38) then
						CalculateTimeToDisplay()
						if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
							if not working then
								working = true
							  	selected = 1
							  	createBlip(locs,selected)
						  	end
						else
							TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)]]

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 5
			local ped = PlayerPedId()
			--local x,y,z = table.unpack(GetEntityCoords(ped))

			local coord = GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,-0.94)
			--local prop = "prop_cs_rub_binbag_01"

			local vehicle = vRP.getNearestVehicle(7)

			ChecarPizzaNaMao(ped)
			
			if IsVehicleModel(vehicle,GetHashKey("faggio2")) then
				local portaMalas = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle,"exhaust"))
				local distanciaPortaMalas = GetDistanceBetweenCoords(portaMalas, coord, 2)
				if distanciaPortaMalas < 1.0 and IsPedOnFoot(ped) then
					if not pizzaHand then
						drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							vRP._playAnim(true, {{"anim@heists@box_carry@","idle"}}, true)
							objPizza = vRP.CarregarObjeto("","","prop_pizza_box_01",50,28422,0, -0.35, -0.14,0)
							pizzaHand = true
							PlaySoundFrontend(-1, "Grab_Parachute", "BASEJUMPS_SOUNDS", 1)
						end
					else 
						drawTxt("PRESSIONE ~b~E~w~ PARA GUARDAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							vRP._DeletarObjeto()
							objPizza = 0
							vRP._stopAnim(true)
							pizzaHand = false
							PlaySoundFrontend(-1, "Grab_Parachute", "BASEJUMPS_SOUNDS", 1)
						end
					end
				end
			elseif pizzaHand then
				if DoesEntityExist(ClientePizza) then
					local distancia = GetDistanceBetweenCoords(GetEntityCoords(ClientePizza), GetEntityCoords(ped), 2)
					if distancia < 1.5 and IsPedFacingPed(ClientePizza, ped, 45.0) then
						drawTxt("PRESSIONE ~b~E~w~ PARA ENTREGAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							vRP._DeletarObjeto()
							objPizza = 0
							vRP._stopAnim(true)
							pizzaHand = false
							recebeuPizzaCliente = true
							indoEntregarPizza = false
							--PlayMissionCompleteAudio("FRANKLIN_BIG_01") 
							PlaySoundFrontend(-1, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 1)
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CANCEL | THREAD ]-----------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 5
			if IsControlJustPressed(0,168) then
				working = false
				vRP._DeletarObjeto()
				objPizza = 0
				vRP._stopAnim(true)
				if DoesEntityExist(ClientePizza) then DeletePed(ClientePizza) end
				pizzaHand = false
				recebeuPizzaCliente = false
				RemoveBlip(blips)
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CRIAR PED AO ENTRAR NO RANGE | THREAD ]-----------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if indoEntregarPizza then
			idle = 500
			--Citizen.Trace(tostring(DoesEntityExist(ClientePizza)) .. "\n")
			if not DoesEntityExist(ClientePizza) then
				local ped = PlayerPedId()
				proximoAoCliente = false
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distancia = Vdist(spawnCliente[1], spawnCliente[2], spawnCliente[3], x, y, z)
				
				--local distancia = GetDistanceBetweenCoords(spawnCliente, GetEntityCoords(ped), 2)
				--Citizen.Trace(tostring(distancia) .. "\n")
				if distancia < 200 then
					if not DoesBlipExist(blips) then createBlip(blips) end
					CriarClientePizza(4,"a_m_y_business_01")
				end
			else
				local ped = PlayerPedId()
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distancia = Vdist(spawnCliente[1], spawnCliente[2], spawnCliente[3], x, y, z)
				if distancia < 30 then
					proximoAoCliente = true
				else
					proximoAoCliente = false
				end

				if proximoAoCliente then
					if not IsPedFacingPed(ClientePizza, ped, 45.0) then
						--local x,y,z = table.unpack(GetEntityCoords(ped))
						TaskLookAtEntity(ClientePizza, ped, -1, 2048, 3)
						TaskTurnPedToFaceCoord(ClientePizza, x, y, z, 2000)
					else
						if not IsEntityPlayingAnim(ClientePizza, currentAnimDict, currentAnimName, 3) and not recebeuPizzaCliente then
							RequestScriptAudioBank("SPEECH_RELATED_SOUNDS", true)
							SetTimeout(1000,function()
								if DoesEntityExist(ClientePizza) then
									PlaySoundFromEntity(1, "Franklin_Whistle_For_Chop", ClientePizza, "SPEECH_RELATED_SOUNDS", true, 0)
								end
							end)
							currentAnimDict = 'friends@frj@ig_1'
							local waveNames = {'wave_a', 'wave_b', 'wave_c', 'wave_d', 'wave_e'}
							currentAnimName = waveNames[ math.random( #waveNames ) ]
							vRP._playAnim(false, {{currentAnimDict,currentAnimName}}, false, ClientePizza)
							--Citizen.Wait(5)
	
						elseif not IsEntityPlayingAnim(ClientePizza, currentAnimDict, currentAnimName, 3) and recebeuPizzaCliente then
							local waveNames = {{'anim@mp_player_intcelebrationfemale@thumbs_up','thumbs_up'}, 
							{'anim@mp_player_intcelebrationfemale@bro_love','bro_love'}, 
							{'anim@mp_player_intcelebrationfemale@blow_kiss','blow_kiss'}, 
							{'anim@mp_player_intcelebrationfemale@salute','salute'}}
							local randomWave = waveNames[ math.random( #waveNames ) ]
							currentAnimDict = randomWave[1]
							currentAnimName = randomWave[2]
							vRP._playAnim(false, {{currentAnimDict,currentAnimName}}, false, ClientePizza)
							--[[recebeuPizzaCliente = false
							SetTimeout(10000,function()
								if DoesEntityExist(ClientePizza) then
									DeletePed(ClientePizza)
								end
							end)]]
							--Citizen.Wait(5)
						end
					end
				Citizen.Wait(5)
				else
					if IsPedNotDoingAnything(ClientePizza) then
						SetTaskWalk(ClientePizza, spawnCliente[1], spawnCliente[2], spawnCliente[3], 15.0)
						--Citizen.Wait(5000)
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriarClientePizza(type,model,pos)
    --Citizen.CreateThread(function()
		

      	-- Define variables
      	local hash = GetHashKey(model)
		--local ped = PlayerPedId()
		recebeuPizzaCliente = false
  
      	-- Loads model
      	RequestModel(hash)
      	while not HasModelLoaded(hash) do
        	Wait(1)
      	end
      
		-- Creates ped when everything is loaded
		
		local headingCliente = math.random( 0, 180 )
		ClientePizza = CreatePed(type, hash, spawnCliente[1], spawnCliente[2], spawnCliente[3],headingCliente, true, false)
		--Citizen.Wait(5)
		SetEntityHeading(ClientePizza, headingCliente)
		FreezeEntityPosition(ClientePizza, false)
		SetEntityInvincible(ClientePizza, true)
		--SetBlockingOfNonTemporaryEvents(ClientePizza, true)
		SetPedCanRagdoll(ClientePizza, true)
		SetPedCanRagdollFromPlayerImpact(ClientePizza, true)
		--createBlip(spawnCliente[1], spawnCliente[2], spawnCliente[3])
		--Citizen.Trace(tostring(DoesEntityExist(ClientePizza)))
		--while DoesEntityExist(ClientePizza) do
			
		--end
    --end)
end

function IsPedNotDoingAnything(ped)
    if IsPedOnFoot(ped) and not IsEntityInWater(ped) then
        if not IsPedSprinting(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) then
            if not GetIsTaskActive(ped, 12) and not GetIsTaskActive(ped, 307) then -- no task like walking around
                if IsPedStill(ped) then
                    return true
                else return false end
            else return false end
        else return false end
    else return false end
end

function SetTaskWalk(ped, x, y, z, radius)
    --ClearPedTasks(ped)
    TaskWanderInArea(ped, x, y, z, radius, 0.0, math.random( 2,5 ))
end

function ChecarPizzaNaMao(ped)
	if pizzaHand then
		if GetEntityModel(objPizza) ~= 604847691 then
			objPizza = vRP.CarregarObjeto("","","prop_pizza_box_01",50,28422,0, -0.35, -0.14,0)
			vRP._playAnim(true, {{"anim@heists@box_carry@","idle"}}, true) 
			Citizen.Wait(50)
		end

		if not IsEntityPlayingAnim(ped, "anim@heists@box_carry@", "idle", 3) then vRP._playAnim(true, {{"anim@heists@box_carry@","idle"}}, true) Citizen.Wait(50) end
						
		BlockWeaponWheelThisFrame()
		DisableControlAction(0,16,true)
		DisableControlAction(0,17,true)
		DisableControlAction(0,22,true)
		DisableControlAction(0,24,true)
		DisableControlAction(0,25,true)
		DisableControlAction(0,29,true)
		DisableControlAction(2, 37, true)
		DisableControlAction(0,45,true)
		DisableControlAction(0,56,true)
		DisableControlAction(0,57,true)
		DisableControlAction(0,73,true)
		DisableControlAction(0, 142, true)
		DisableControlAction(0,166,true)
		DisableControlAction(0,167,true)
		DisableControlAction(0,170,true)				
		DisableControlAction(0,182,true)	
		DisableControlAction(0,187,true)
		DisableControlAction(0,188,true)
		DisableControlAction(0,189,true)
		DisableControlAction(0,190,true)
		DisableControlAction(0,243,true)
		--DisableControlAction(0,245,true)
		DisableControlAction(0,257,true)
		DisableControlAction(0,288,true)
		DisableControlAction(0,289,true)
		DisableControlAction(0,344,true)
		--if GetVehiclePedIsTryingToEnter(ped) then ClearPedTasks(ped) end 
	end
end

function createBlip(x, y, z)
	--if DoesBlipExist(blips) then RemoveBlip(blips) end
	if DoesEntityExist(ClientePizza) then
		blips = AddBlipForEntity(ClientePizza)
	else
		blips = AddBlipForCoord(x, y, z)
	end
	--blips = AddBlipForCoord(x, y, z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Cliente")
	EndTextCommandSetBlipName(blips)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end