local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
 
--[ ARRAY ]------------------------------------------------------------------------------------------------------------------------------
 
local valores = {
	{ item = "paracetamil", quantidade = 1, compra = 67 },
	{ item = "voltarom", quantidade = 1, compra = 80 },
	{ item = "trandrylux", quantidade = 1, compra = 95 },
	{ item = "dorfrex", quantidade = 1, compra = 60 },
	{ item = "buscopom", quantidade = 1, compra = 73 }
}
 
--[ COMPRAR ]----------------------------------------------------------------------------------------------------------------------------
 
RegisterServerEvent("farmacia-comprar")
AddEventHandler("farmacia-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(valores) do
			if item == v.item then
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

					if item == "paracetamil" then
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.getInventoryItemAmount(user_id,"r-paracetamil") >= 1 then
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.tryGetInventoryItem(user_id,"r-paracetamil",1)
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","Você precisa de uma receita médica para isso.")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
						end
					elseif item == "voltarom" then
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.getInventoryItemAmount(user_id,"r-voltarom") >= 1 then
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.tryGetInventoryItem(user_id,"r-voltarom",1)
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","Você precisa de uma receita médica para isso.")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
						end
					elseif item == "trandrylux" then
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.getInventoryItemAmount(user_id,"r-trandrylux") >= 1 then
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.tryGetInventoryItem(user_id,"r-trandrylux",1)
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","Você precisa de uma receita médica para isso.")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
						end
					elseif item == "dorfrex" then
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.getInventoryItemAmount(user_id,"r-dorfrex") >= 1 then
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.tryGetInventoryItem(user_id,"r-dorfrex",1)
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","Você precisa de uma receita médica para isso.")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
						end
					elseif item == "buscopom" then
						if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.quantidade <= vRP.getInventoryMaxWeight(user_id) then
							if vRP.getInventoryItemAmount(user_id,"r-buscopom") >= 1 then
								if vRP.tryPayment(user_id,parseInt(pagamento)) then
									TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.quantidade).."x "..vRP.itemNameList(v.item).."</b> por <b>$"..vRP.format(parseInt(pagamento)).." dólares</b>.")
									vRP.tryGetInventoryItem(user_id,"r-buscopom",1)
									vRP.giveInventoryItem(user_id,v.item,parseInt(v.quantidade))
								else
									TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","Você precisa de uma receita médica para isso.")
							end
						else
							TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
						end
					end
				end
			end
		end
	end
end)