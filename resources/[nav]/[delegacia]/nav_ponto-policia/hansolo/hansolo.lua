local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Policia = Tunnel.getInterface("nav_ponto-policia")

--[ FUNCTION ]---------------------------------------------------------------------------------------------------------------------------

local menuactive = false

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "entrar-servico-policia" then
		TriggerServerEvent("entrar-servico-policia")
	
	elseif data == "sair-servico-policia" then
		TriggerServerEvent("sair-servico-policia")

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local ponto = {
	{ ['x'] = -1077.96, ['y'] = -817.26, ['z'] = 27.04 },
	{ ['x'] = -1103.04, ['y'] = -829.22, ['z'] = 14.29 }
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000

		for k,v in pairs(ponto) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local ponto = ponto[k]
			
			if distance < 5.1 then
				DrawMarker(23, ponto.x, ponto.y, ponto.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				idle = 5
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) and Policia.checkPermissao() then
						ToggleActionMenu()
					end
				end
			end
		end

		Citizen.Wait(idle)
	end
end)

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