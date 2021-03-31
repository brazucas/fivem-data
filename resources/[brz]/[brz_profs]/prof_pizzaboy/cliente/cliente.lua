local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

prof = Tunnel.getInterface("prof_pizzaboy")
brzNPC = Proxy.getInterface("brz_npcs")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local blips = false
local working = false
local ped = PlayerPedId()
local pizzaHand = false
local objPizza = 0
local currentAnimDict = 'friends@frj@ig_1'
local currentAnimName = ''
local ClientePizza = nil
local recebeuPizzaCliente = false
local indoEntregarPizza = false
local spawnCliente = {}
local proximoAoCliente = false
local gorjeta = 0
local HoraDeEntrega = 0
local MinutoDeEntrega = 0
local veiculoTrabalho = nil
local proximoAoVeiculo = false

local Skins = {"a_f_y_hipster_01",
    "a_f_y_hipster_02",
    "a_f_y_hipster_03",
    "a_f_y_hipster_04",
    "a_f_y_indian_01",
    "a_f_y_juggalo_01",
    "a_f_y_runner_01",
    "a_f_y_rurmeth_01",
    "a_f_y_scdressy_01",
    "a_f_y_skater_01",
    "a_f_y_soucent_01",
    "a_f_y_soucent_02",
    "a_f_y_soucent_03",
    "a_f_y_tennis_01",
    "a_f_y_topless_01",
    "a_f_y_tourist_01",
    "a_f_y_tourist_02",
    "a_f_y_vinewood_01",
    "a_f_y_vinewood_02",
    "a_f_y_vinewood_03",
    "a_f_y_vinewood_04",
    "a_f_y_yoga_01",
    "a_m_m_acult_01",
    "a_m_m_afriamer_01",
    "a_m_m_beach_01",
    "a_m_m_beach_02",
    "a_m_m_bevhills_01",
    "a_m_m_bevhills_02",
    "a_m_m_business_01",
    "a_m_m_eastsa_01",
    "a_m_m_eastsa_02",
    "a_m_m_farmer_01",
    "a_m_m_fatlatin_01",
    "a_m_m_genfat_01",
    "a_m_m_genfat_02",
    "a_m_m_golfer_01",
    "a_m_m_hasjew_01",
    "a_m_m_hillbilly_01",
    "a_m_m_hillbilly_02",
    "a_m_m_indian_01",
    "a_m_m_ktown_01",
    "a_m_m_malibu_01",
    "a_m_m_mexcntry_01",
    "a_m_m_mexlabor_01",
    "a_m_m_og_boss_01",
    "a_m_m_paparazzi_01",
    "a_m_m_polynesian_01",
    "a_m_m_prolhost_01",
    "a_m_m_rurmeth_01",
    "a_m_m_salton_01",
    "a_m_m_salton_02",
    "a_m_m_salton_03",
    "a_m_m_salton_04",
    "a_m_m_skater_01",
    "a_m_m_skidrow_01",
    "a_m_m_socenlat_01",
    "a_m_m_soucent_01",
    "a_m_m_soucent_02",
    "a_m_m_soucent_03",
    "a_m_m_soucent_04",
    "a_m_m_stlat_02",
    "a_m_m_tennis_01",
    "a_m_m_tourist_01",
    "a_m_m_tramp_01",
    "a_m_m_trampbeac_01",
    "a_m_m_tranvest_01",
    "a_m_m_tranvest_02",
    "a_m_o_acult_01",
    "a_m_o_acult_02",
    "a_m_o_beach_01",
    "a_m_o_genstreet_01",
    "a_m_o_ktown_01",
    "a_m_o_salton_01",
    "a_m_o_soucent_01",
    "a_m_o_soucent_02",
    "a_m_o_soucent_03",
    "a_m_o_tramp_01",
    "a_m_y_acult_01",
    "a_m_y_acult_02",
    "a_m_y_beach_01",
    "a_m_y_beach_02",
    "a_m_y_beach_03",
    "a_m_y_beachvesp_01",
    "a_m_y_beachvesp_02",
    "a_m_y_bevhills_01",
    "a_m_y_bevhills_02",
    "a_m_y_breakdance_01",
    "a_m_y_busicas_01",
    "a_m_y_business_01",
    "a_m_y_business_02",
    "a_m_y_business_03",
    "a_m_y_cyclist_01",
    "a_m_y_dhill_01",
    "a_m_y_downtown_01",
    "a_m_y_eastsa_01",
    "a_m_y_eastsa_02",
    "a_m_y_epsilon_01",
    "a_m_y_epsilon_02",
    "a_m_y_gay_01",
    "a_m_y_gay_02",
    "a_m_y_genstreet_01",
    "a_m_y_genstreet_02",
    "a_m_y_golfer_01",
    "a_m_y_hasjew_01",
    "a_m_y_hiker_01",
    "a_m_y_hippy_01",
    "a_m_y_hipster_01",
    "a_m_y_hipster_02",
    "a_m_y_hipster_03",
    "a_m_y_indian_01",
    "a_m_y_jetski_01",
    "a_m_y_juggalo_01",
    "a_m_y_ktown_01",
    "a_m_y_ktown_02",
    "a_m_y_latino_01",
    "a_m_y_methhead_01",
    "a_m_y_mexthug_01",
    "a_m_y_motox_01",
    "a_m_y_motox_02",
    "a_m_y_musclbeac_01",
    "a_m_y_musclbeac_02",
    "a_m_y_polynesian_01",
    "a_m_y_roadcyc_01",
    "a_m_y_runner_01",
    "a_m_y_runner_02",
    "a_m_y_salton_01",
    "a_m_y_skater_01",
    "a_m_y_skater_02",
    "a_m_y_soucent_01",
    "a_m_y_soucent_02",
    "a_m_y_soucent_03",
    "a_m_y_soucent_04",
    "a_m_y_stbla_01",
    "a_m_y_stbla_02",
    "a_m_y_stlat_01",
    "a_m_y_stwhi_01",
    "a_m_y_stwhi_02",
    "a_m_y_sunbathe_01",
    "a_m_y_surfer_01",
    "a_m_y_vindouche_01",
    "a_m_y_vinewood_01",
    "a_m_y_vinewood_02",
    "a_m_y_vinewood_03",
    "a_m_y_vinewood_04",
    "a_m_y_yoga_01"
}

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
	local horaDisplay = HoraDeEntrega
	local minutoDisplay = MinutoDeEntrega
	if HoraDeEntrega <= 9 then
		horaDisplay = "0" .. HoraDeEntrega
	end
	if MinutoDeEntrega <= 9 then
		minutoDisplay = "0" .. MinutoDeEntrega
	end
	return horaDisplay .. ":" .. minutoDisplay
end

--[ EVENTS ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand("pizzaboy", function(source, args)
	
	Citizen.Trace(tostring(GetEntityModel(GetVehiclePedIsIn(ped))) .. "\n")
	--MissionText("Hi, ~o~orange~w~.", 1500)
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
	CreateBlipNPC(spawnCliente[1], spawnCliente[2], spawnCliente[3])
	--CriarClientePizza(4,"a_m_y_business_01")
    --TriggerEvent("chatMessage", '', { 0, 0x99, 255}, "" .. tostring(GetEntityModel(objPizza)) )
end)

--[ INTERAÇÃO NPC ]------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if not IsPedInAnyVehicle(ped) then
			local npcPizza = brzNPC.maisProximo("pizzaboy")
			if DoesEntityExist(npcPizza) then
				local coordX,coordY,coordZ = table.unpack(GetEntityCoords(npcPizza))
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(coordX,coordY,coordZ)
				local distance = GetDistanceBetweenCoords(coordX,coordY,cdz,x,y,z,true)

				if distance < 10.1 then
					idle = 5
					--DrawMarker(23,coordX,coordY,coordZ-0.99,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
					
					if not working then
						if GetDistanceBetweenCoords(GetEntityCoords(ped), coordX, coordY, coordZ, true ) < 1.3 then
							DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para iniciar as entregas de ~p~PIZZA~w~.")
						end
					else
						if GetDistanceBetweenCoords(GetEntityCoords(ped), coordX, coordY, coordZ, true ) < 1.3 then
							DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para pegar outra ~p~PIZZA~w~.")
						end
					end
					
					if distance < 1.3 then
						if IsControlJustPressed(1,38) then
							--CalculateTimeToDisplay()
							--if parseInt(hour) >= 06 and parseInt(hour) <= 20 then
								if not working then
									IniciarMissaoPizza()
									TriggerEvent("Notify","importante","Você agora está trabalhando como pizzaboy. Vá até o cliente para entregar está pizza!",2000)
								else
									if not indoEntregarPizza then
										IniciarMissaoPizza()
										TriggerEvent("Notify","importante","Vá até o cliente para entregar está pizza!",2000)
									end
								end
							--else
								--TriggerEvent("Notify","importante","Funcionamento é das <b>06:00</b> as <b>20:00</b>.",8000)
							--end
						end
					end
				end
			end
			
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			idle = 5
			--local ped = PlayerPedId()
			--local x,y,z = table.unpack(GetEntityCoords(ped))
			
			--local prop = "prop_cs_rub_binbag_01"

			

			if IsPedInAnyVehicle(ped) then
				if pizzaHand then
					TaskLeaveVehicle(ped,GetVehiclePedIsIn(ped),0)
				end
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR O SERVIÇO",4,0.218,0.963,0.35,255,255,255,120)
			else
				drawTxt("PRESSIONE ~r~F7~w~ PARA ENCERRAR O SERVIÇO",4,0.068,0.963,0.35,255,255,255,120)
			end

			if indoEntregarPizza then				
				drawTxt("Entregue a pizza no local marcado até o seguinte horário: ~r~" .. CalculateTimeToDisplay(),4,0.5,0.93,0.50,255,255,255,180)
				ChecarPizzaNaMao(ped)
				if GetClockHours() == HoraDeEntrega and GetClockMinutes() == MinutoDeEntrega then
					TriggerEvent("Notify","importante","Você demorou muito para entregar a pizza! O serviço foi encerrado!",2000)
					EncerrarMissaoPizza()
				end
			else
				drawTxt("Vá até o local marcado para buscar outra pizza!",4,0.5,0.93,0.50,255,255,255,180)
			end
			
			if proximoAoVeiculo then
				local coord = GetOffsetFromEntityInWorldCoords(ped,0.0,1.0,-0.94)
				local portaMalas = GetWorldPositionOfEntityBone(veiculoTrabalho, GetEntityBoneIndexByName(veiculoTrabalho,"exhaust"))
				local distanciaPortaMalas = GetDistanceBetweenCoords(portaMalas, coord, 2)
				if distanciaPortaMalas < 1.0 and IsPedOnFoot(ped) then
					if not pizzaHand then
						if indoEntregarPizza then
							--drawTxt("PRESSIONE ~b~E~w~ PARA PEGAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
							DrawText3D(portaMalas[1], portaMalas[2], portaMalas[3], "PRESSIONE ~b~E~w~ PARA PEGAR A PIZZA")
							if IsControlJustPressed(0,38) then
								if prof.checkPlate(GetEntityModel(veiculoTrabalho)) then
									vRP._playAnim(true, {{"anim@heists@box_carry@","idle"}}, true)
									objPizza = vRP.CarregarObjeto("","","prop_pizza_box_01",50,28422,0, -0.35, -0.14,0)
									pizzaHand = true
									PlaySoundFrontend(-1, "Grab_Parachute", "BASEJUMPS_SOUNDS", 1)
								end
							end
						end
					else 
						--drawTxt("PRESSIONE ~b~E~w~ PARA GUARDAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						DrawText3D(portaMalas[1], portaMalas[2], portaMalas[3], "PRESSIONE ~b~E~w~ PARA GUARDAR A PIZZA")
						if IsControlJustPressed(0,38) then
							if prof.checkPlate(GetEntityModel(veiculoTrabalho)) then
								vRP._DeletarObjeto()
								objPizza = 0
								vRP._stopAnim(true)
								pizzaHand = false
								PlaySoundFrontend(-1, "Grab_Parachute", "BASEJUMPS_SOUNDS", 1)
							end
						end
					end
				end
			elseif pizzaHand then
				if DoesEntityExist(ClientePizza) then
					local posCliente = GetEntityCoords(ClientePizza)
					local distancia = GetDistanceBetweenCoords(posCliente, GetEntityCoords(ped), 2)
					if distancia < 1.5 and IsPedFacingPed(ClientePizza, ped, 45.0) then
						--drawTxt("PRESSIONE ~b~E~w~ PARA ENTREGAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						DrawText3D(posCliente[1], posCliente[2], posCliente[3], "PRESSIONE ~b~E~w~ PARA ENTREGAR A PIZZA")
						if IsControlJustPressed(0,38) then
							vRP._DeletarObjeto()
							objPizza = 0
							vRP._stopAnim(true)
							pizzaHand = false
							recebeuPizzaCliente = true
							indoEntregarPizza = false
							local npc = brzNPC.maisProximo("pizzaboy")
							local x,y,z = table.unpack(GetEntityCoords(npc))
							if DoesBlipExist(blips) then RemoveBlip(blips) end
							CreateBlipPizza(x, y, z)
							prof.payment(gorjeta)
							Citizen.Trace("entregou: "..tostring(GetClockMinutes()) .. "\n")
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

--[ CHECKING VEHICLE OWNER | THREAD ]-----------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		if working then
			if indoEntregarPizza then
				local vehicle = vRP.getNearestVehicle(2)
				if GetEntityModel(vehicle) == 55628203 then
					veiculoTrabalho = vehicle
					proximoAoVeiculo = true
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
				EncerrarMissaoPizza()
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ CRIAR PED AO ENTRAR NO RANGE | THREAD ]-----------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		--Citizen.Trace(tostring(GetVehiclePedIsTryingToEnter(PlayerPedId())) .. "\n")
		if working then
			--idle = 500
			--Citizen.Trace(tostring(DoesEntityExist(ClientePizza)) .. "\n")
			if not DoesEntityExist(ClientePizza) then
				--local ped = PlayerPedId()
				proximoAoCliente = false
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local distancia = Vdist(spawnCliente[1], spawnCliente[2], spawnCliente[3], x, y, z)
				
				--local distancia = GetDistanceBetweenCoords(spawnCliente, GetEntityCoords(ped), 2)
				--Citizen.Trace(tostring(distancia) .. "\n")
				if distancia < 200 and indoEntregarPizza then
					if not DoesBlipExist(blips) then CreateBlipNPC(blips) end
					CriarClientePizza(4,math.random( #Skins ) )
				end
			else
				--local ped = PlayerPedId()
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

function CalcularGorjeta()
	--local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distancia = Vdist(spawnCliente[1], spawnCliente[2], spawnCliente[3], x, y, z)
	Citizen.Trace("iniciou: "..tostring(GetClockMinutes()) .. "\n")
	Citizen.Trace("iniciou: "..tostring(distancia) .. "\n")
	local velocidadeMedia = GetVehicleModelMaxSpeed(GetHashKey("faggio2")) * 3.6
	Citizen.Trace("iniciou: "..tostring(velocidadeMedia) .. "\n")
	Citizen.Trace("iniciou: "..tostring(distancia / velocidadeMedia) .. "\n")
	if distancia > 100 then
		gorjeta = math.floor((distancia / 100) + 0.5)

	else
		gorjeta = 0
	end
	local TempoEntrega = (math.floor((distancia / velocidadeMedia) + 0.5) * 6)
	local TempoEntregaH = math.floor(TempoEntrega / 60)
	local TempoEntregaM = math.floor((math.fmod(TempoEntrega / 60,1) * 60) + 0.5)

	local Hrs = GetClockHours()
	local Min = GetClockMinutes()
	if Hrs + TempoEntregaH >= 24 then
		HoraDeEntrega= Hrs+TempoEntregaH-24
	else
		HoraDeEntrega= Hrs+TempoEntregaH
	end
	if Min + TempoEntregaM >= 60 then
		HoraDeEntrega = HoraDeEntrega + 1
		MinutoDeEntrega=Min+TempoEntregaM-60
	else
		MinutoDeEntrega=Min+TempoEntregaM
	end
	--[[if MinutoDeEntrega >= 60 then
		MinutoDeEntrega = MinutoDeEntrega - 60
		HoraDeEntrega = HoraDeEntrega + 1
	end]]
end

function IniciarMissaoPizza()
	working = true
	
	spawnCliente = locs[ math.random( #locs ) ]
	if DoesBlipExist(blips) then RemoveBlip(blips) end
	if DoesEntityExist(ClientePizza) then DeletePed(ClientePizza) end
	indoEntregarPizza = true
	CreateBlipNPC(spawnCliente[1], spawnCliente[2], spawnCliente[3])
	vRP._playAnim(true, {{"anim@heists@box_carry@","idle"}}, true)
	objPizza = vRP.CarregarObjeto("","","prop_pizza_box_01",50,28422,0, -0.35, -0.14,0)
	pizzaHand = true
	CalcularGorjeta()
	PlaySoundFrontend(-1, "Grab_Parachute", "BASEJUMPS_SOUNDS", 1)
end

function EncerrarMissaoPizza()
	working = false
	vRP._DeletarObjeto()
	objPizza = 0
	vRP._stopAnim(true)
	if DoesEntityExist(ClientePizza) then DeletePed(ClientePizza) end
	pizzaHand = false
	recebeuPizzaCliente = false
	indoEntregarPizza = false
	veiculoTrabalho = nil
	proximoAoVeiculo = false
	RemoveBlip(blips)
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
		--CreateBlipNPC(spawnCliente[1], spawnCliente[2], spawnCliente[3])
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
		DisableControlAction(0, 140, true)
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
		if GetVehiclePedIsTryingToEnter(ped) ~= 0 then ClearPedTasks(ped) end
	end
end

function CreateBlipNPC(x, y, z)
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

function CreateBlipPizza(x, y, z)
	--if DoesBlipExist(blips) then RemoveBlip(blips) end
	blips = AddBlipForCoord(x, y, z)
	--blips = AddBlipForCoord(x, y, z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Pizza")
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