local dropList = {}

RegisterNetEvent('DropSystem:remove')
AddEventHandler('DropSystem:remove',function(id)
	if dropList[id] ~= nil then
		dropList[id] = nil
	end
end)

RegisterNetEvent('DropSystem:createForAll')
AddEventHandler('DropSystem:createForAll',function(id,marker)
	dropList[id] = marker
end)

local cooldown = false
Citizen.CreateThread(function()
	while true do
		local idle = 1000
		
		for k,v in pairs(dropList) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 15 then
				idle = 5
				DrawMarker(25, v.x, v.y, cdz+0.01, 0, 0, 0, 0, 0, 0, 0.4, 0.4, 0.5, 136, 96, 240, 180, 0, 0, 2, 0, 0, 0, 0)
				DrawMarker(25, v.x, v.y, cdz+0.01, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.5, 234, 203, 102, 220, 0, 0, 2, 0, 0, 0, 0)
				if distance < 1.2 then
					drawTxt("Pressione [~p~E~w~] para pegar ~p~"..v.count.."~w~x ~p~"..string.upper(v.name).."~w~.",4,0.5,0.90,0.35,255,255,255,255)
					if distance <= 1.2 and v.count ~= nil and v.name ~= nil and not IsPedInAnyVehicle(ped) then
						if IsControlJustPressed(1,38) and not cooldown then
							cooldown = true
							TriggerServerEvent('DropSystem:take',k)
							SetTimeout(3000,function()
								cooldown = false
							end)
						end
					end
				end
			end
		end
		Citizen.Wait(idle)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
--[ FUNÇÕES ]----------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
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