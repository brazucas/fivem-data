local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

prof = Tunnel.getInterface("prof_pizzaboy")
brzNPC = Proxy.getInterface("brz_npcs")

--[ VARIABLES ]-----------------------------------------------------------------------------------------------------------------

local working = false
local npcPizza = false
local pizzaHand = false
local objPizza = 0
local indoEntregarPizza = false
local gorjeta = 0
local HoraDeEntrega = 0
local MinutoDeEntrega = 0
local veiculoTrabalho = nil
local proximoAoVeiculo = false

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
	Citizen.Trace(GetClockDayOfWeek().." "..GetClockDayOfMonth().." "..GetClockMonth().." "..GetClockYear().. "\n")
	--MissionText("Hi, ~o~orange~w~.", 1500)
end)

RegisterCommand("testehorario", function(source, args)
	SetClockDate(30, 11, 0)
	SetClockTime(23, 58, 0)
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
	PedsPizza.spawnCliente = ConfigPizza.SpawnPedLoc[ math.random( #ConfigPizza.SpawnPedLoc ) ]
	BlipsPizza.RemoverBlip()
	PedsPizza.RemoverClientePizza()
	indoEntregarPizza = true
	BlipsPizza.CreateBlipNPC(PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3])
	--CriarClientePizza(4,"a_m_y_business_01")
    --TriggerEvent("chatMessage", '', { 0, 0x99, 255}, "" .. tostring(GetEntityModel(objPizza)) )
end)

--[ INTERAÇÃO NPC ]------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			if DoesEntityExist(npcPizza) then
				local coordX,coordY,coordZ = table.unpack(GetEntityCoords(npcPizza))
				local x,y,z = table.unpack(GetEntityCoords(ped))
				local bowz,cdz = GetGroundZFor_3dCoord(coordX,coordY,coordZ)
				local distance = GetDistanceBetweenCoords(coordX,coordY,cdz,x,y,z,true)

				if distance < 1.3 then
					idle = 5
					--DrawMarker(23,coordX,coordY,coordZ-0.99,0,0,0,0,0,0,1.0,1.0,0.5,136, 96, 240, 180,0,0,0,0)
					
					if not working then
						DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para iniciar as entregas de ~p~PIZZA~w~.")
					else
						DrawText3D(coordX, coordY, coordZ, "Pressione [~p~E~w~] para pegar outra ~p~PIZZA~w~.")
					end

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
				else
					npcPizza = nil
				end
			else
				npcPizza = brzNPC.maisProximo("pizzaboy", 1.3)
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
			local ped = PlayerPedId()
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
				local distanciaPortaMalas = GetDistanceBetweenCoords(portaMalas, coord, true)
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
				if DoesEntityExist(PedsPizza.ClientePizza) then
					local posCliente = GetEntityCoords(PedsPizza.ClientePizza)
					local distancia = GetDistanceBetweenCoords(posCliente, GetEntityCoords(ped), true)
					DrawMarker(2, posCliente.x, posCliente.y, posCliente.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.25, 0.25, 0.25, 121, 206, 121, 100, false, true, 2, false, false, false, false)
					if distancia < 1.5 and IsPedFacingPed(PedsPizza.ClientePizza, ped, 45.0) then
						--drawTxt("PRESSIONE ~b~E~w~ PARA ENTREGAR A PIZZA",4,0.5,0.93,0.50,255,255,255,180)
						DrawText3D(posCliente[1], posCliente[2], posCliente[3], "PRESSIONE ~b~E~w~ PARA ENTREGAR A PIZZA")
						if IsControlJustPressed(0,38) then
							vRP._DeletarObjeto()
							objPizza = 0
							vRP._stopAnim(true)
							pizzaHand = false
							PedsPizza.recebeuPizzaCliente = true
							indoEntregarPizza = false
							SetEntityAsNoLongerNeeded(PedsPizza.ClientePizza)
							local npc = brzNPC.maisProximo("pizzaboy")
							local x,y,z = table.unpack(GetEntityCoords(npc))
							BlipsPizza.RemoverBlip()
							BlipsPizza.CreateBlipPizza(x, y, z)
							prof.payment(gorjeta)
							--Citizen.Trace("entregou: "..tostring(GetClockMinutes()) .. "\n")
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
				else
					proximoAoVeiculo = false
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
			PedsPizza.ExecutarComportamentoCliente(indoEntregarPizza)
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
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	local distancia = Vdist(PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3], x, y, z)
	--Citizen.Trace("iniciou: "..tostring(GetClockMinutes()) .. "\n")
	--Citizen.Trace("iniciou: "..tostring(distancia) .. "\n")
	local velocidadeMedia = GetVehicleModelMaxSpeed(GetHashKey("faggio2")) * 3.6
	--Citizen.Trace("iniciou: "..tostring(velocidadeMedia) .. "\n")
	--Citizen.Trace("iniciou: "..tostring(distancia / velocidadeMedia) .. "\n")
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
		if TempoEntregaH < 2 then HoraDeEntrega = HoraDeEntrega + 1 end
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
	PedsPizza.spawnCliente = ConfigPizza.SpawnPedLoc[ math.random( #ConfigPizza.SpawnPedLoc ) ]
	BlipsPizza.RemoverBlip()
	PedsPizza.RemoverClientePizza()
	indoEntregarPizza = true
	BlipsPizza.CreateBlipNPC(PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3])
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
	PedsPizza.RemoverClientePizza()
	pizzaHand = false
	PedsPizza.recebeuPizzaCliente = false
	indoEntregarPizza = false
	veiculoTrabalho = nil
	proximoAoVeiculo = false
	BlipsPizza.RemoverBlip()
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