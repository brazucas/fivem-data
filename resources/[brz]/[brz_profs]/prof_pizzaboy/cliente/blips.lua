BlipsPizza = {}
BlipsPizza.blip = nil

function BlipsPizza.RemoverBlip()
	if DoesBlipExist(BlipsPizza.blip) then RemoveBlip(BlipsPizza.blip) end
end

function BlipsPizza.CreateBlipNPC(x, y, z)
	--if DoesBlipExist(BlipsPizza.blip) then RemoveBlip(BlipsPizza.blip) end
	if DoesEntityExist(PedsPizza.ClientePizza) then
		BlipsPizza.blip = AddBlipForEntity(PedsPizza.ClientePizza)
	else
		BlipsPizza.blip = AddBlipForCoord(x, y, z)
	end
	--blips = AddBlipForCoord(x, y, z)
	SetBlipSprite(BlipsPizza.blip,1)
	SetBlipColour(BlipsPizza.blip,5)
	SetBlipScale(BlipsPizza.blip,0.4)
	SetBlipAsShortRange(BlipsPizza.blip,false)
	SetBlipRoute(BlipsPizza.blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Cliente")
	EndTextCommandSetBlipName(BlipsPizza.blip)
end

function BlipsPizza.CreateBlipPizza(x, y, z)
	--if DoesBlipExist(BlipsPizza.blip) then RemoveBlip(BlipsPizza.blip) end
	BlipsPizza.blip = AddBlipForCoord(x, y, z)
	--BlipsPizza.blip = AddBlipForCoord(x, y, z)
	SetBlipSprite(BlipsPizza.blip,1)
	SetBlipColour(BlipsPizza.blip,5)
	SetBlipScale(BlipsPizza.blip,0.4)
	SetBlipAsShortRange(BlipsPizza.blip,false)
	SetBlipRoute(BlipsPizza.blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Buscar Pizza")
	EndTextCommandSetBlipName(BlipsPizza.blip)
end