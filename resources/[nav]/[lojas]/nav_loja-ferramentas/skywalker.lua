local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------

local valores = {
	{ item = "garrafa-vazia", quantidade = 1, compra = 12 },
	{ item = "caixa-vazia", quantidade = 1, compra = 5 },
	{ item = "paninho", quantidade = 1, compra = 29 },
	{ item = "ponta-britadeira", quantidade = 1, compra = 45 },
	{ item = "repairkit", quantidade = 1, compra = 800 },

	{ item = "semente-blueberry", quantidade = 1, compra = 30 },
	{ item = "semente-tomate", quantidade = 1, compra = 30 },
	{ item = "semente-laranja", quantidade = 1, compra = 30 },

	{ item = "serra", quantidade = 1, compra = 650 },
	{ item = "pa", quantidade = 1, compra = 100 },
	{ item = "furadeira", quantidade = 1, compra = 450 },

	{ item = "wbody|WEAPON_HAMMER", quantidade = 1, compra = 300 },
	{ item = "wbody|WEAPON_CROWBAR", quantidade = 1, compra = 300 },
	{ item = "wbody|WEAPON_WEAPON_HATCHET", quantidade = 1, compra = 300 },
	{ item = "wbody|WEAPON_WHENCH", quantidade = 1, compra = 300 }
}

--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("ferramentas-comprar")
AddEventHandler("ferramentas-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
					local preco = parseInt(v.compra)
					if preco then
        
						if vRP.hasPermission(user_id,"ultimate.permissao") then
							desconto = math.floor(preco*20/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"platinum.permissao") then
							desconto = math.floor(preco*15/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"gold.permissao") then
							desconto = math.floor(preco*10/100)
							pagamento = math.floor(preco-desconto)
						elseif vRP.hasPermission(user_id,"standard.permissao") then
							desconto = math.floor(preco*5/100)
							pagamento = math.floor(preco-desconto)
						else
							pagamento = math.floor(preco)
						end
				

						if vRP.tryPayment(user_id,parseInt(pagamento)) then
							TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
							vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
						else
							TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
						end

					end
				else
					TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
				end
			end
		end
	end
end)