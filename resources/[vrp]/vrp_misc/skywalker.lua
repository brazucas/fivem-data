--[ vRP ]-------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]------------------------------------------------------------------------------------

misc = {}
Tunnel.bindInterface("vrp_misc",misc)

--[ VARIABLES ]-------------------------------------------------------------------------------------

local hours = 6
local minutes = 20

local day = 1
local month = 1
local year = 0

--[[local weather = "EXTRASUNNY"
local timers = {
	[1] = { "EXTRASUNNY" }
}]]

--[ REQUESTSYNC ]-----------------------------------------------------------------------------------

RegisterServerEvent("vrp_misc:requestSync")
AddEventHandler("vrp_misc:requestSync",function()
	TriggerClientEvent("vrp_misc:updateWeather",-1,activeWeatherSystems)
end)

RegisterServerEvent("dinoweather:syncWeather")
AddEventHandler("dinoweather:syncWeather", function()
	local _source = source
	TriggerClientEvent("vrp_misc:updateWeather", _source, activeWeatherSystems)
end)

RegisterServerEvent("dinoweather:setWeatherInZone")
AddEventHandler("dinoweather:setWeatherInZone", function(zoneName, weatherType)
  local _source = source
  if IsPlayerAceAllowed(_source, "dinoweather.cmds") then
    local zoneArea = findZoneBySubZone(zoneName)
    for _, weatherZone in ipairs(WeatherConfig.weatherSystems[zoneArea][1]) do
      local foundInterval = nil
      for i, activeZone in ipairs(activeWeatherSystems) do
        if activeZone[1] == weatherZone then
          foundInterval = i 
        end
      end
      if foundInterval ~= nil then
        activeWeatherSystems[foundInterval] = {zoneName, weatherType}
      else
        table.insert(activeWeatherSystems, {zoneName, weatherType})
      end
    end
    TriggerClientEvent("dinoweather:syncWeather", -1, activeWeatherSystems)
    TriggerClientEvent("chatMessage", _source, "^2Clima setado para ^3" .. weatherType .. "^2.")
  else
    TriggerClientEvent("chatMessage", _source, "^3Sem permissão.")
  end
end)

--[ UPDATECLOCK ]-----------------------------------------------------------------------------------

Citizen.CreateThread(function()
	local data = vRP.getSData("brz:date")
	local date = json.decode(data) or nil
	--if data and date ~= nil then
	if data and date ~= nil then
		hours = date.hora
		minutes = date.minutos

		day = date.dia
		month = date.mes
		year = date.ano
	else
		local svDate = { 
			hora = parseInt(hours),
			minutos = parseInt(minutes),
			dia = parseInt(day),
			mes = parseInt(month),
			ano = parseInt(year),
		}
		vRP.setSData("brz:date",json.encode(svDate))
	end

	while true do
		--Citizen.Wait(10000)
		Citizen.Wait(2000)

		if minutes == nil then
			minutes = 0;
		end

		minutes = minutes + 1
		
		if minutes >= 60 then
			minutes = 0
			hours = hours + 1

			if hours >= 24 then
				hours = 0

				day = day + 1

				if day > misc.GetDaysInCurrentMonth() then
					day = 1
					
					month = month + 1
					if month > 11 then
						month = 0
						
						year = year + 1
					end
				end
			end
			local svDate = { 
				hora = parseInt(hours),
				minutos = parseInt(minutes),
				dia = parseInt(day),
				mes = parseInt(month),
				ano = parseInt(year),
			}
			vRP.setSData("brz:date",json.encode(svDate))
		end
		TriggerClientEvent("vrp_misc:syncTimers",-1,{minutes,hours,day,month,year})
	end
end)

--[ MUDAR DATA ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('tempo', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
		if args[1] == nil then
			--msg de erro
		else
			if hours == nil then
				hours = 0;
			end

			if day == nil then
				day = 0;
			end

			if minutes == nil then
				minutes = 0;
			end

			local dia = parseInt(args[1])
			if dia >= 0 and dia <= misc.GetDaysInCurrentMonth() then
				local horas = parseInt(args[2])
				if horas >= 0 and horas < 24 then
					local minutos = parseInt(args[3])
					if minutos >= 0 and minutos < 60 then
						hours = horas
						minutes = minutos
						day = dia
						TriggerClientEvent("vrp_misc:syncTimers",-1,{minutes,hours,day,month,year})
					end
				end
			end
		end
    end
end)

--[ UPDATETIMERS ]----------------------------------------------------------------------------------

--[[Citizen.CreateThread(function()
	while true do
		Citizen.Wait(600000)
		weather = timers[math.random(1)][1]
		TriggerClientEvent("vrp_misc:updateWeather",-1,weather)
	end
end)]]

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  randomizeSystems()
	  Citizen.Wait(WeatherConfig.randomizeTime)
	end
end)

--[[RegisterCommand('clima',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	
	if user_id then
		if vRP.hasPermission(user_id,"manager.permissao") or vRP.hasPermission(user_id,"administrador.permissao") then
			TriggerClientEvent("vrp_misc:updateWeather",-1,args[1])
		end
	end
end)]]

--[ GET DAYS IN MONTH | FUNCTION ]-----------------------------------------------------------------------

function misc.GetCurrentYear()
	return year
end

function misc.GetCurrentMonth()
	return month
end

function misc.GetCurrentDay()
	return day
end

--[ GET DAYS IN MONTH | FUNCTION ]-----------------------------------------------------------------------

function misc.GetDaysInCurrentMonth()
	if month == 1 then
		return 28
	elseif month == 3 or month == 5 or month == 8 or month == 10 then
		return 30
	elseif month == 0 or month == 2 or month == 4 or month == 6 or month == 7 or month == 9 or month == 11 then
		return 31
	end
end

--[ RICHPRESENCE | FUNCTION ]-----------------------------------------------------------------------

function misc.discord()
	local quantidade = 0
	local users = vRP.getUsers()

	for k,v in pairs(users) do
		quantidade = quantidade + 1
	end

	return parseInt(quantidade)
end

--[ RADIO PERMISSION | FUNCTION ]-------------------------------------------------------------------

function misc.permissaoDpla()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"policia.permissao")
end

function misc.permissaoDmla()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"ems.permissao")
end

function misc.permissaoTaxista()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"taxista.permissao")
end

function misc.permissaoMecanico()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"mecanico.permissao")
end

function misc.permissaoBennys()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"bennys.permissao")
end

function misc.permissaoBallas()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"ballas.permissao")
end

function misc.permissaoGrove()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"grove.permissao")
end

function misc.permissaoFamilies()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"families.permissao")
end

function misc.permissaoMedellin()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"medellin.permissao")
end

function misc.permissaoMotoclub()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"motoclub.permissao")
end

function misc.permissaoBratva()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"bratva.permissao")
end

function misc.permissaoNdrangheta()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"ndrangheta.permissao")
end

function misc.permissaoNynax()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"nynax.permissao")
end

function misc.permissaoSemantic()
	local source = source
	local user_id = vRP.getUserId(source)
	
	return vRP.hasPermission(user_id,"semantic.permissao")
end

--[ /RADIO | COMMAND ]------------------------------------------------------------------------------

RegisterCommand('radio',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	
	if vRP.getInventoryItemAmount(user_id,"radio") >= 1 then
		if args[1] == "f" then
			TriggerClientEvent("vrp_misc:onRadio",source,parseInt(args[2]))
		else
			TriggerClientEvent("vrp_misc:onGroupRadio",source)
		end
	else
		TriggerClientEvent("Notify",source,"aviso","Você <b>não possui</b> um <b>rádio</b> na mochila.") 
	end
end)

--[ SEARCH TRASH | VARIABLES ]----------------------------------------------------------------------

local amount = {}
local amountMoney = {}
local pagamento = ""

local comidas = {
	[1] = { ['item'] = "agua" },
	[2] = { ['item'] = "sanduiche" }
}

local roupas = { 
	[1] = { ['item'] = "oculos" },
	[2] = { ['item'] = "mascara" }
}

local itens = {
	[1] = { ['item'] = "celular-queimado" },
	[2] = { ['item'] = "radio-queimado" },
	[3] = { ['item'] = "tablet-queimado" }
}

--[ SEARCH TRASH | THREAD ]-------------------------------------------------------------------------

local timers = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
	end
end)

--[ SEARCH TRASH | FUNCTION ]-----------------------------------------------------------------------

function misc.amount()
	local source = source
	if amount[source] == nil then
		amount[source] = math.random(1,2)
	end
end

function misc.amountMoney()
	local source = source
	if amountMoney[source] == nil then
		amountMoney[source] = math.random(30,150)
	end
end

function misc.searchTrash(id)
	misc.amount()
	misc.amountMoney()

	local source = source
	local user_id = vRP.getUserId(source)
	local chance = math.random(1,1000)

	if user_id then
		if timers[id] == 0 or not timers[id] then
			if chance >= 985 then
				if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(pagamento)*amountMoney[source] <= vRP.getInventoryMaxWeight(user_id) then
					TriggerClientEvent("vrp_misc:trashAnim",source)
					pagamento = "dinheiro"
					timers[id] = 600
					return true
				else
					TriggerClientEvent("Notify",source,"negado","Sua mochila está <b>cheia</b>.")
					return false
				end
			elseif chance >= 930 and chance <= 984 then
				if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(pagamento)*amount[source] <= vRP.getInventoryMaxWeight(user_id) then
					TriggerClientEvent("vrp_misc:trashAnim",source)
					pagamento = itens[math.random(3)].item
					timers[id] = 600
					return true
				else
					TriggerClientEvent("Notify",source,"negado","Sua mochila está <b>cheia</b>.")
					return false
				end
			elseif chance >= 850 and chance <= 929 then
				if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(pagamento)*amount[source] <= vRP.getInventoryMaxWeight(user_id) then
					TriggerClientEvent("vrp_misc:trashAnim",source)
					pagamento = roupas[math.random(2)].item
					timers[id] = 600
					return true
				else
					TriggerClientEvent("Notify",source,"negado","Sua mochila está <b>cheia</b>.")
					return false
				end
			elseif chance >= 700 and chance <= 849 then
				if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(pagamento)*amount[source] <= vRP.getInventoryMaxWeight(user_id) then
					TriggerClientEvent("vrp_misc:trashAnim",source)
					pagamento = comidas[math.random(2)].item
					timers[id] = 600
					return true
				else
					TriggerClientEvent("Notify",source,"negado","Sua mochila está <b>cheia</b>.")
					return false
				end
			elseif chance >= 450 and chance <= 699 then
				TriggerClientEvent("vrp_misc:trashAnim",source)
				pagamento = "rato"
				timers[id] = 600	
				return true
			else
				TriggerClientEvent("vrp_misc:trashAnim",source)
				pagamento = ""
				timers[id] = 600
				return true
			end
		else
			TriggerClientEvent("Notify",source,"negado","Lixeira está <b>vazia</b>.")
		end
	end
end

function misc.trashPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	
	if user_id then
		if pagamento ~= "" and pagamento ~= "rato" then
			if pagamento == "dinheiro" then
				vRP.giveInventoryItem(user_id,pagamento,amountMoney[source])
				TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>$"..amountMoney[source].." dólares</b>.")
			else
				vRP.giveInventoryItem(user_id,pagamento,amount[source])
				TriggerClientEvent("Notify",source,"sucesso","Você encontrou <b>x"..amount[source].." "..vRP.itemNameList(pagamento).."</b>.")
			end
			amount[source] = nil
			amountMoney[source] = nil
		elseif pagamento == "rato" then
			TriggerClientEvent("Notify",source,"negado","Não havia nada na lixeira, além de ratos que te morderam.")
			TriggerClientEvent("vrp_misc:Ragdoll",source)
			vRPclient.varyHealth(user_id,-100)
			Wait(5000)
			TriggerClientEvent("vrp_misc:Ragdoll",source)
			amount[source] = nil
			amountMoney[source] = nil
		else
			TriggerClientEvent("Notify",source,"negado","Não havia nada na lixeira.")
			amount[source] = nil
			amountMoney[source] = nil
		end
	end
end

--[ WATHER COOLER | FUNCTION ]----------------------------------------------------------------------

function misc.searchCooler()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,"garrafa-vazia") >= 1 then
		if vRP.getInventoryWeight(user_id) + vRP.getItemWeight("agua") <= vRP.getInventoryMaxWeight(user_id) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function misc.coolerPayment()
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.tryGetInventoryItem(user_id,"garrafa-vazia",1) then
		SetTimeout(6000,function()
			vRP.giveInventoryItem(user_id,"agua",1)
		end)
	end
end

--[ WATHER ITEM DAMAGE | EVENT ]--------------------------------------------------------------------

local damageItens = {
	{ item = "celular", damageItem = "celular-queimado" },
	{ item = "jbl", damageItem = "jbl-queimada" },
	{ item = "calculadora", damageItem = "calculadora-queimada" },
	{ item = "tablet", damageItem = "tablet-queimado" },
	{ item = "notebook", damageItem = "notebook-queimado" },
	{ item = "controleremoto", damageItem = "controleremoto-queimado" },
	{ item = "baterias", damageItem = "baterias-queimadas" },
	{ item = "radio", damageItem = "radio-queimado" },
	
	{ item = "portearmas", damageItem = nil },
	{ item = "identidade", damageItem = nil },
	{ item = "cnh", damageItem = nil },
	{ item = "repairkit", damageItem = nil },
	{ item = "dinheiro", damageItem = nil },
	{ item = "cartao-debito", damageItem = nil },
	{ item = "maquininha", damageItem = "maquininha-queimada" },

	{ item = "drone-basic1", damageItem = nil },
	{ item = "drone-basic2", damageItem = nil },
	{ item = "drone-basic3", damageItem = nil },
	{ item = "drone-advanced1", damageItem = nil },
	{ item = "drone-advanced2", damageItem = nil },
	{ item = "drone-advanced3", damageItem = nil },
	{ item = "drone-police", damageItem = nil },
	{ item = "carrinho", damageItem = nil },

	{ item = "camisinha", damageItem = nil },
	{ item = "vibrador", damageItem = nil },
	{ item = "kit", damageItem = nil },
	
	{ item = "dinheiro-sujo", damageItem = nil },
	{ item = "algema", damageItem = nil },
	{ item = "lockpick", damageItem = nil },
	{ item = "capuz", damageItem = nil },
	{ item = "placa", damageItem = nil },

	{ item = "serra", damageItem = nil },
	{ item = "furadeira", damageItem = nil },
	{ item = "pa-jardinagem", damageItem = nil },

	{ item = "garrafa-vazia", damageItem = nil },
	{ item = "ponta-britadeira", damageItem = nil },

	{ item = "minerio-diamante", damageItem = nil },
	{ item = "minerio-ouro", damageItem = nil },
	{ item = "minerio-prata", damageItem = nil },
	{ item = "minerio-ferro", damageItem = nil },

	{ item = "diamante", damageItem = nil },
	{ item = "barra-ouro", damageItem = nil },
	{ item = "barra-prata", damageItem = nil },
	{ item = "barra-ferro", damageItem = nil },
	
	{ item = "agua", damageItem = nil },
	{ item = "leite", damageItem = nil },
	{ item = "cafe", damageItem = nil },
	{ item = "cafecleite", damageItem = nil },
	{ item = "cafeexpresso", damageItem = nil },
	{ item = "capuccino", damageItem = nil },
	{ item = "frappuccino", damageItem = nil },
	{ item = "cha", damageItem = nil },
	{ item = "icecha", damageItem = nil },
	{ item = "sprunk", damageItem = nil },
	{ item = "cola", damageItem = nil },
	{ item = "energetico", damageItem = nil },

	{ item = "pibwassen", damageItem = nil },
	{ item = "tequilya", damageItem = nil },
	{ item = "patriot", damageItem = nil },
	{ item = "blarneys", damageItem = nil },
	{ item = "jakeys", damageItem = nil },
	{ item = "barracho", damageItem = nil },
	{ item = "ragga", damageItem = nil },
	{ item = "nogo", damageItem = nil },
	{ item = "mount", damageItem = nil },
	{ item = "cherenkov", damageItem = nil },
	{ item = "bourgeoix", damageItem = nil },
	{ item = "bleuterd", damageItem = nil },

	{ item = "sanduiche", damageItem = nil },
	{ item = "rosquinha", damageItem = nil },
	{ item = "hotdog", damageItem = nil },
	{ item = "xburguer", damageItem = nil },
	{ item = "chips", damageItem = nil },
	{ item = "batataf", damageItem = nil },
	{ item = "pizza", damageItem = nil },
	{ item = "frango", damageItem = nil },
	{ item = "bcereal", damageItem = nil },
	{ item = "bchocolate", damageItem = nil },
	{ item = "taco", damageItem = nil },

	{ item = "paracetamil", damageItem = nil },
	{ item = "voltarom", damageItem = nil },
	{ item = "trandrylux", damageItem = nil },
	{ item = "dorfrex", damageItem = nil },
	{ item = "buscopom", damageItem = nil },

	{ item = "r-paracetamil", damageItem = nil },
	{ item = "r-voltarom", damageItem = nil },
	{ item = "r-trandrylux", damageItem = nil },
	{ item = "r-dorfrex", damageItem = nil },
	{ item = "r-buscopom", damageItem = nil },

	{ item = "metanfetamina", damageItem = nil },
	{ item = "composito", damageItem = nil },

	{ item = "nitrato-amonia", damageItem = nil },
	{ item = "hidroxido-sodio", damageItem = nil },
	{ item = "pseudoefedrina", damageItem = nil },
	{ item = "eter", damageItem = nil },

	{ item = "cocaina", damageItem = nil },
	{ item = "pasta-base", damageItem = nil },

	{ item = "acido-sulfurico", damageItem = nil },
	{ item = "folhas-coca", damageItem = nil },
	{ item = "calcio-po", damageItem = nil },
	{ item = "querosene", damageItem = nil },

	{ item = "marijuana", damageItem = nil },
	{ item = "folha-marijuana", damageItem = nil },

	{ item = "corpo-ak47", damageItem = nil },
	{ item = "corpo-aks74u", damageItem = nil },
	{ item = "corpo-uzi", damageItem = nil },
	{ item = "corpo-glock", damageItem = nil },
	{ item = "corpo-magnum", damageItem = nil },

	{ item = "molas", damageItem = nil },
	{ item = "placa-metal", damageItem = nil },
	{ item = "gatilho", damageItem = nil },
	{ item = "capsulas", damageItem = nil },
	{ item = "polvora", damageItem = nil },

	{ item = "garrafa-leite", damageItem = nil },

	{ item = "isca", damageItem = nil },

	{ item = "tora", damageItem = nil },

	{ item = "saco-lixo", damageItem = nil },

	{ item = "caixa-pizza", damageItem = nil },

	{ item = "encomenda", damageItem = nil },
	{ item = "caixa-vazia", damageItem = nil },

	{ item = "malote", damageItem = nil },

	{ item = "semente-marijuana", damageItem = nil },
	{ item = "semente-blueberry", damageItem = nil },

	{ item = "laranja", damageItem = nil },
	{ item = "tomate", damageItem = nil },
	{ item = "blueberry", damageItem = nil },

	{ item = "transmissao", damageItem = nil },
	{ item = "suspensao", damageItem = nil },
	{ item = "portas", damageItem = nil },
	{ item = "borrachas", damageItem = nil },
	{ item = "pneus", damageItem = nil },
	{ item = "capo", damageItem = nil },
	{ item = "bateria-carro", damageItem = nil },
	{ item = "motor", damageItem = nil }
}

RegisterServerEvent('vrp_misc:damageItem')
AddEventHandler('vrp_misc:damageItem',function()
	local source = source
	local user_id = vRP.getUserId(source)
	for k,v in pairs(damageItens) do
		local item = v.item
		local damageItem = v.damageItem

		if vRP.getInventoryItemAmount(user_id,item) > 0 then
			local itemAmmount = parseInt(vRP.getInventoryItemAmount(user_id,item))
			local itemName = vRP.itemNameList(item)

			if damageItem == nil then
				if vRP.tryGetInventoryItem(user_id,item,itemAmmount) then
					TriggerClientEvent("Notify",source,"negado","<b>Sua mochila abriu!</b> Você perdeu <b>"..itemName.."</b> ao entrar na água.",8000)
				end
			else
				if vRP.tryGetInventoryItem(user_id,item,itemAmmount) then
					vRP.giveInventoryItem(user_id,damageItem,itemAmmount)
					TriggerClientEvent("Notify",source,"negado","Seu <b>"..itemName.." queimou</b> quando você entrou na água.",8000)
				end
			end
		end
	end
end)