local menuactive = false
function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		TransitionToBlurred(1000)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		TransitionFromBlurred(1000)
		SendNUIMessage({ hidemenu = true })
	end
end

--[ BUTTON ]-----------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	if data == "comprar-canivete" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_SWITCHBLADE")

	elseif data == "comprar-faca" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_KNIFE")

	elseif data == "comprar-pt92af" then
		TriggerServerEvent("ammunation-comprar","wbody|WEAPON_PISTOL")

	elseif data == "comprar-m-pt92af" then
		TriggerServerEvent("ammunation-comprar","wammo|WEAPON_PISTOL")

	elseif data == "fechar" then
		ToggleActionMenu()
	
	end
end)

--[ LOCAIS ]-----------------------------------------------------------------------------------------------------------------------------

local lojas = {
	{ ['x'] = 22.65, ['y'] = -1106.97, ['z'] = 29.8 },
	{ ['x'] = 809.56, ['y'] = -2157.66, ['z'] = 29.62 },
	{ ['x'] = 1693.71, ['y'] = 3760.54, ['z'] = 34.71 },
	{ ['x'] = 252.31, ['y'] = -50.68, ['z'] = 69.95 },
	{ ['x'] = 841.75, ['y'] = -1033.94, ['z'] = 28.2},
	{ ['x'] = -330.19, ['y'] = 6084.47, ['z'] = 31.46 },
	{ ['x'] = -661.63, ['y'] = -934.93, ['z'] = 21.83 },
	{ ['x'] = -1305.6, ['y'] = -394.94, ['z'] = 36.7 },
	{ ['x'] = -1117.58, ['y'] = 2699.19, ['z'] = 18.56 },
	{ ['x'] = 2567.29, ['y'] = 293.96, ['z'] = 108.74 },
	{ ['x'] = -3172.03, ['y'] = 1088.45, ['z'] = 20.84 }
}

--[ MENU ]-------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local idle = 1000

		for k,v in pairs(lojas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local lojas = lojas[k]

			if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), lojas.x, lojas.y, lojas.z, true ) <= 1.5 and not menuactive then
				DrawText3D(lojas.x, lojas.y, lojas.z, "Pressione [~p~E~w~] para acessar a ~p~LOJA DE ARMAMENTOS~w~.")
			end

			if distance < 5.1 then
				DrawMarker(23, lojas.x, lojas.y, lojas.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5, 136, 96, 240, 180, 0, 0, 0, 0)
				idle = 5
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						ToggleActionMenu()
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)

--[ FUNÇÃO ]-----------------------------------------------------------------------------------------------------------------------------

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