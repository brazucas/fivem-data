local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_chest",src)
vSERVER = Tunnel.getInterface("vrp_chest")

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local chestTimer = 0
local chestOpen = ""

--[ STARTFOCUS ]-------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)

--[ CHESTCLOSE ]-------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("chestClose",function(data)
	TransitionFromBlurred(1000)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
end)

--[ TAKEITEM ]---------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("takeItem",function(data)
	vSERVER.takeItem(tostring(chestOpen),data.item,data.amount)
end)

--[ STOREITEM ]--------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("storeItem",function(data)
	vSERVER.storeItem(tostring(chestOpen),data.item,data.amount)
end)

--[ AUTO-UPDATE ]------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("Chest:UpdateChest")
AddEventHandler("Chest:UpdateChest",function(action)
	SendNUIMessage({ action = action })
end)

--[ REQUESTCHEST ]-----------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("requestChest",function(data,cb)
	local inventario,inventario2,peso,maxpeso,peso2,maxpeso2 = vSERVER.openChest(tostring(chestOpen))
	if inventario then
		cb({ inventario = inventario, inventario2 = inventario2, peso = peso, maxpeso = maxpeso, peso2 = peso2, maxpeso2 = maxpeso2 })
	end
end)

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local chest = {
	{ "ems",306.29,-601.52,43.29 },
	{ "policia-arsenal",-1098.8,-825.99,14.29 },
	{ "policia-evidencias",-1074.87,-821.42,11.04 },
}

--[ CHESTTIMER ]-------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		if chestTimer > 0 then
			chestTimer = chestTimer - 3
		end
	end
end)

--[ CHEST ]------------------------------------------------------------------------------------------------------------------------------

RegisterCommand("chest",function(source,args)
	local ped = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(ped))
	for k,v in pairs(chest) do
		local distance = GetDistanceBetweenCoords(x,y,z,v[2],v[3],v[4],true)
		if distance <= 2.0 and chestTimer <= 0 then
			chestTimer = 3
			if vSERVER.checkIntPermissions(v[1]) then
				TransitionToBlurred(1000)
				SetNuiFocus(true,true)
				SendNUIMessage({ action = "showMenu" })
				chestOpen = tostring(v[1])
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		local ped = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(ped))
		for k,v in pairs(chest) do
			local distance = GetDistanceBetweenCoords(x,y,z,v[2],v[3],v[4],true)

			if distance < 10.1 then
				idle = 5
				DrawMarker(23,v[2],v[3],v[4]-0.99,0,0,0,0,0,0,0.7,0.7,0.5,136, 96, 240, 180,0,0,0,0)
				if distance < 0.8 then
					if IsControlJustPressed(0,38) and chestTimer <= 0 then
						chestTimer = 3
						if vSERVER.checkIntPermissions(v[1]) then
							TransitionToBlurred(1000)
							SetNuiFocus(true,true)
							SendNUIMessage({ action = "showMenu" })
							chestOpen = tostring(v[1])
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)