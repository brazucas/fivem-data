local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRPN = {}
Tunnel.bindInterface("vrp_inventory",vRPN)
Proxy.addInterface("vrp_inventory",vRPN)

vRPCclient = Tunnel.getInterface("vrp_inventory")
local idgens = Tools.newIDGenerator()
vGARAGE = Tunnel.getInterface("vrp_garages")

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

local actived = {}

--[ MOCHILA ]----------------------------------------------------------------------------------------------------------------------------

function vRPN.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	local inventario = {}
	if data and data.inventory then
		for k,v in pairs(data.inventory) do
			if vRP.itemBodyList(k) then
				table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
			end
		end
		return inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id)
	end
end

--[ ENVIAR ITEM ]------------------------------------------------------------------------------------------------------------------------

function vRPN.sendItem(itemName,type,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = vRP.getUserIdentity(user_id)
		local identitynu = vRP.getUserIdentity(nuser_id)

		if nuser_id and vRP.itemIndexList(itemName) then
			local x,y,z = vRPclient.getPosition(source)
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount) then
						vRP.giveInventoryItem(nuser_id,itemName,amount)
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						PerformHttpRequest(config.webhookSend, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM ENVIADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{name = "**QUEM ENVIOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, { name = "**ITEM ENVIADO:**", value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..vRP.format(parseInt(amount)).."** ]"}, {name = "**QUEM RECEBEU:**", value = "**"..identitynu.name.." "..identitynu.firstname.."** [**"..nuser_id.."**]\n⠀⠀"}, { name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**", value = "⠀"}}, footer = { text = config.webhookBottom..os.date("%d/%m/%Y |: %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
						TriggerClientEvent("itensNotify",source,"sucesso","Enviou",""..vRP.itemNameList(itemName).."",""..vRP.format(parseInt(amount)).."",""..vRP.format(vRP.getItemWeight(itemName)*parseInt(amount)).."")
						TriggerClientEvent("itensNotify",nplayer,"sucesso","Recebeu",""..vRP.itemNameList(itemName).."",""..vRP.format(parseInt(amount)).."",""..vRP.format(vRP.getItemWeight(itemName)*parseInt(amount)).."")
						vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
						TriggerClientEvent('vrp_inventory:Update',nplayer,'updateMochila')
						return true
					end
				end
			end
		end
	end
	return false
end

--[ DROPAR ITEM ]------------------------------------------------------------------------------------------------------------------------

function vRPN.dropItem(itemName,type,amount)
	local source = source
	if itemName then
		if itemName == "passaporte" then
			TriggerClientEvent("Notify",source,"negado","Você não pode <b>dropar</b> seu <b>passaporte</b>.",8000)
		else
			local user_id = vRP.getUserId(source)
			local identity = vRP.getUserIdentity(user_id)
			local x,y,z = vRPclient.getPosition(source)
			if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,itemName,amount) then
				TriggerEvent("DropSystem:create",itemName,amount,x,y,z,3600)
				vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
				PerformHttpRequest(config.webhookDrop, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM DROPADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{ name = "**QUEM DROPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]" }, { name = "**ITEM DROPADO:**", value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..vRP.format(parseInt(amount)).."** ]\n⠀⠀"}, { name = "**LOCAL: "..tD(x)..", "..tD(y)..", "..tD(z).."**", value = "⠀"}}, footer = {text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon }, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				TriggerClientEvent("itensNotify",source,"sucesso","Dropou",""..vRP.itemNameList(itemName).."",""..vRP.format(parseInt(amount)).."",""..vRP.format(vRP.getItemWeight(itemName)*parseInt(amount)).."")
				TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
				return true
			end
		end
	end
	return false
end

--[ USE ITEM ]---------------------------------------------------------------------------------------------------------------------------

local pick = {}
local blips = {}

function vRPN.useItem(itemName,type,ramount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and ramount ~= nil and parseInt(ramount) >= 0 and not actived[user_id] and actived[user_id] == nil then
		if type == "usar" then
			if itemName == "mochila" then
				if vRP.getInventoryMaxWeight(user_id) >= 90 then
					TriggerClientEvent("Notify",source,"negado","Você não pode equipar mais mochilas.",8000)
				else
					if vRP.tryGetInventoryItem(user_id,"mochila",1) then
						TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
						vRP.varyExp(user_id,"physical","strength",650)

						if vRP.getExp(user_id,"physical","strength") <= 660 then
							TriggerClientEvent("inventory:mochilaoff",source)
						elseif vRP.getExp(user_id,"physical","strength") >= 680 then
							
						else
							TriggerClientEvent("inventory:mochilaon",source)
						end

						TriggerClientEvent("itensNotify",source,"usar","Equipou",""..itemName.."")
					end
				end
			elseif itemName == "maquininha" then
				local source = source
				local user_id = vRP.getUserId(source)
				local nplayer = vRPclient.getNearestPlayer(source,2)
				local nuser_id = vRP.getUserId(nplayer)
				
				TriggerClientEvent("vrp_inventory:fechar",source)

				if nplayer then
					local identity = vRP.getUserIdentity(user_id)
					local identitynu = vRP.getUserIdentity(nuser_id)
					local banco = vRP.getBankMoney(user_id)
					local banconu = vRP.getBankMoney(nuser_id)

					if vRP.getInventoryItemAmount(user_id,"maquininha") >= 1 then
						local cobranca = vRP.prompt(source,"Quanto deseja cobrar pelos serviços prestados a "..identitynu.name.." "..identitynu.firstname.."</b>?", "")
						TriggerClientEvent("emotes",source,"anotar2")

						if cobranca ~= "" then
							local valorfatura = parseInt(cobranca)
							local fatura = vRP.request(nplayer,"<b>"..identity.name.." "..identity.firstname.."</b> está cobrando <b>$"..valorfatura.." dólares</b> pelos serviços. Deseja pagar?",30)

							if fatura then
								if vRP.getInventoryItemAmount(nuser_id,"cartaocredito") >= 1 then
									if banconu >= valorfatura then
										local tax = parseInt(3/100*valorfatura)
										local pagamento	= parseInt(valorfatura-tax)

										vRP.setBankMoney(user_id,banco+pagamento)
										vRP.setBankMoney(nuser_id,banconu-valorfatura)

										TriggerClientEvent("Notify",source,"sucesso","<b>"..identitynu.name.." "..identitynu.firstname.."</b> pagou <b>$"..valorfatura.." dólares</b> pelo serviço.s")
										TriggerClientEvent("Notify",nplayer,"sucesso","Você pagou <b>$"..valorfatura.." dólares</b> a <b>"..identity.name.." "..identity.firstname.."</b> pelo serviço.")

										vRPclient._stopAnim(source,false)
										vRPclient._DeletarObjeto(source)
									else
										TriggerClientEvent("Notify",source,"negado","<b>"..identitynu.name.." "..identitynu.firstname.."</b> não tem dinheiro suficiente para o pagamento.")
										TriggerClientEvent("Notify",nplayer,"negado","Saldo insuficiente.")
										vRPclient._stopAnim(source,false)
										vRPclient._DeletarObjeto(source)
									end
								else
									TriggerClientEvent("Notify",source,"negado","O cliente não possuí cartão de crédito para fazer o pagamento.")
									TriggerClientEvent("Notify",nplayer,"negado","Você não tem um cartão de crédito na mochila.")
								end
							else
								TriggerClientEvent("Notify",source,"negado","<b>"..identitynu.name.." "..identitynu.firstname.."</b> negou o pagamento.")
								vRPclient._stopAnim(source,false)
								vRPclient._DeletarObjeto(source)
							end
						else
							TriggerClientEvent("Notify",source,"negado","Você precisa colocar o valor que deseja cobrar!")
							vRPclient._stopAnim(source,false)
							vRPclient._DeletarObjeto(source)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Você não possuí uma maquina de cobranças em sua mochila.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Não há players por perto.")
				end

			elseif itemName == "identidade" then
				local nplayer = vRPclient.getNearestPlayer(source,2)
				if nplayer then
					local identity = vRP.getUserIdentity(user_id)
					if identity then
						TriggerClientEvent("Identity2",nplayer,identity.name,identity.firstname,identity.user_id,identity.registration)
					end
				end
			elseif itemName == "colete" then
				if vRP.tryGetInventoryItem(user_id,"colete",1) then
					vRPclient.setArmour(source,100)
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					TriggerClientEvent("itensNotify",source,"usar","Equipou",""..itemName.."")
				end
			elseif itemName == "repairkit" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.hasPermission(user_id,"mecanico.permissao") then
							actived[user_id] = true
							TriggerClientEvent('cancelando',source,true)
							vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
							TriggerClientEvent("progress",source,30000,"reparando veículo")
							SetTimeout(30000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('reparar',source)
								TriggerClientEvent('repararmotor',source,vehicle)
								vRPclient._stopAnim(source,false)
							end)
						else
							if vRP.tryGetInventoryItem(user_id,"repairkit",1) then
								actived[user_id] = true
								TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
								TriggerClientEvent('cancelando',source,true)
								vRPclient._playAnim(source,false,{{"mini@repair","fixing_a_player"}},true)
								TriggerClientEvent("progress",source,30000,"reparando veículo")
								TriggerClientEvent("itensNotify",source,"usar","Usou",""..itemName.."")
								SetTimeout(30000,function()
									actived[user_id] = nil
									TriggerClientEvent('cancelando',source,false)
									TriggerClientEvent('reparar',source)
									TriggerClientEvent('repararmotor',source,vehicle)
									vRPclient._stopAnim(source,false)
								end)
							end
						end
					end
				end
			elseif itemName == "paninho" then
				if not vRPclient.isInVehicle(source) then
					local vehicle = vRPclient.getNearestVehicle(source,3.5)
					if vehicle then
						if vRP.tryGetInventoryItem(user_id,"paninho",1) then
							actived[user_id] = true
							TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
							TriggerClientEvent('cancelando',source,true)

							TriggerClientEvent("emotes",source,"pano")

							TriggerClientEvent("progress",source,10000,"limpando")
							TriggerClientEvent("itensNotify",source,"usar","Usou",""..itemName.."")

							SetTimeout(10000,function()
								actived[user_id] = nil
								TriggerClientEvent('cancelando',source,false)
								TriggerClientEvent('limpar',source)
								vRPclient._stopAnim(source,false)
								vRPclient._DeletarObjeto(src)
							end)
						end
					end
				end

				--[ ULTILITÁRIOS ILEGAIS ]------------------------------------------------------------------------------------------------------------------------

			elseif itemName == "lockpick" then
				local vehicle,vnetid,placa,vname,lock,banned,trunk,model,street = vRPclient.vehList(source,7)
				local policia = vRP.getUsersByPermission("policia.permissao")

				if #policia >= 2 then
					TriggerClientEvent("Notify",source,"aviso","Policiais insuficientes em serviço.")
					return true
				end

				if vRP.hasPermission(user_id,"policia.permissao") then
					TriggerEvent("setPlateEveryone",placa)
					vGARAGE.vehicleClientLock(-1,vnetid,lock)
					TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
					return
				end

				if vRP.getInventoryItemAmount(user_id,"lockpick") >= 1 and vRP.tryGetInventoryItem(user_id,"lockpick",1) and vehicle then
					actived[user_id] = true

					if vRP.hasPermission(user_id,"mec.permissao") then
						actived[user_id] = nil
						TriggerEvent("setPlateEveryone",placa)
						vGARAGE.vehicleClientLock(-1,vnetid,lock)
						return
					end

					TriggerClientEvent('cancelando',source,true)
					vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)
					TriggerClientEvent("progress",source,15000,"roubando")
					TriggerClientEvent("itensNotify",source,"usar","Usou",""..itemName.."")

					SetTimeout(15000,function()
						actived[user_id] = nil
						TriggerClientEvent('cancelando',source,false)
						vRPclient._stopAnim(source,false)

						if math.random(100) >= 50 then
							TriggerEvent("setPlateEveryone",placa)
							vGARAGE.vehicleClientLock(-1,vnetid,lock)
							TriggerClientEvent("vrp_sound:source",source,'lock',0.5)
						else
							TriggerClientEvent("Notify",source,"negado","Roubo do veículo falhou e as autoridades foram acionadas.",8000)
							local policia = vRP.getUsersByPermission("policia.permissao")
							local x,y,z = vRPclient.getPosition(source)
							for k,v in pairs(policia) do
								local player = vRP.getUserSource(parseInt(v))
								if player then
									async(function()
										local id = idgens:gen()
										vRPclient._playSound(player,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
										TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Roubo na ^1"..street.."^0 do veículo ^1"..model.."^0 de placa ^1"..placa.."^0 verifique o ocorrido.")
										pick[id] = vRPclient.addBlip(player,x,y,z,10,5,"Ocorrência",0.5,false)
										SetTimeout(20000,function() vRPclient.removeBlip(player,pick[id]) idgens:free(id) end)
									end)
								end
							end
						end
					end)
				end
			elseif itemName == "capuz" then
				if vRP.getInventoryItemAmount(user_id,"capuz") >= 1 then
					local nplayer = vRPclient.getNearestPlayer(source,2)
					if nplayer then
						vRPclient.setCapuz(nplayer)
						vRP.closeMenu(nplayer)
						TriggerClientEvent("Notify",source,"sucesso","Capuz utilizado com sucesso.",8000)
					end
				end
			elseif itemName == "placa" then
                if vRPclient.GetVehicleSeat(source) then
                    if vRP.tryGetInventoryItem(user_id,"placa",1) then
                        local placa = vRP.generatePlate()
                        TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
                        TriggerClientEvent('cancelando',source,true)
                        TriggerClientEvent("vehicleanchor",source)
						TriggerClientEvent("progress",source,59500,"clonando")
						TriggerClientEvent("itensNotify",source,"usar","Usou",""..itemName.."")
                        SetTimeout(60000,function()
                            TriggerClientEvent('cancelando',source,false)
                            TriggerClientEvent("cloneplates",source,placa)
                            --TriggerEvent("setPlateEveryone",placa)
                            TriggerClientEvent("Notify",source,"sucesso","Placa clonada com sucesso.",8000)
                        end)
                    end
                end

				--[ BEBIDAS ]-------------------------------------------------------------------------------------------------------------------------------------
	
			elseif itemName == "agua" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"agua",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRP.giveInventoryItem(user_id,"garrafa-vazia",1)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "leite" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"leite",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "cafe" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafe",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "cafecleite" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafecleite",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "cafeexpresso" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cafeexpresso",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-40)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "capuccino" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"capuccino",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-55)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "frappuccino" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"frappuccino",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_aa_coffee@idle_a","idle_a","prop_fib_coffee",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-65)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "cha" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cha",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-50)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "icecha" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"icecha",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-50)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "sprunk" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"sprunk",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","ng_proc_sodacan_01b",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-65)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "cola" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cola",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","ng_proc_sodacan_01a",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-70)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "energetico" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"energetico",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_energy_drink",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-100)
						vRP.varyHunger(user_id,0)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "pibwassen" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"pibwassen",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-10)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "tequilya" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"tequilya",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_logopen",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "patriot" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"patriot",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,-10)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "blarneys" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"blarneys",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "jakeys" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"jakeys",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_logopen",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "barracho" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"barracho",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_amb_beer_bottle",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "ragga" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"ragga",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "nogo" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"nogo",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_logopen",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,15)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "mount" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"mount",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,20)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "cherenkov" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"cherenkov",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_logopen",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,20)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "bourgeoix" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"bourgeoix",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","p_whiskey_notop",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,20)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "bleuterd" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"bleuterd",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_beer_logopen",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Bebendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,20)
						vRP.varyHunger(user_id,0)
						TriggerClientEvent("inventory:checkDrunk",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "sanduiche" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"sanduiche",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					TriggerClientEvent("emotes",source,"comer")
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)

				end
			elseif itemName == "rosquinha" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"rosquinha",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					TriggerClientEvent("emotes",source,"comer3")
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "hotdog" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"hotdog",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					TriggerClientEvent("emotes",source,"comer2")
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "xburguer" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"xburguer",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					TriggerClientEvent("emotes",source,"comer")
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "chips" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"chips",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","ng_proc_food_chips01b",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "batataf" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"batataf",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_food_bs_chips",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "pizza" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"pizza",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","v_res_tt_pizzaplate",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "frango" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"frango",1) then

					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_food_cb_nugets",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "bcereal" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"bcereal",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_choc_pq",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")

					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "bchocolate" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"bchocolate",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_choc_meto",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "taco" then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"taco",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@code_human_wander_eating_donut@male@idle_a","idle_c","prop_taco_01",49,28422)
					TriggerClientEvent("progress",source,10000,"comendo")
					TriggerClientEvent("itensNotify",source,"usar","Comendo",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						vRP.varyThirst(user_id,0)
						vRP.varyHunger(user_id,-40)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "paracetamil" and vRPCclient.checkVida() then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"paracetamil",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Tomando",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("remedios",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "voltarom" and vRPCclient.checkVida() then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"voltarom",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Tomando",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("remedios",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "trandrylux" and vRPCclient.checkVida() then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"trandrylux",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Tomando",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("remedios",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "dorfrex" and vRPCclient.checkVida() then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"dorfrex",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Tomando",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("remedios",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			elseif itemName == "buscopom" and vRPCclient.checkVida() then
				local src = source
				if vRP.tryGetInventoryItem(user_id,"buscopom",1) then
					actived[user_id] = true
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
					vRPclient._CarregarObjeto(src,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_cs_pills",49,28422)
					TriggerClientEvent("progress",source,10000,"tomando")
					TriggerClientEvent("itensNotify",source,"usar","Tomando",""..itemName.."")
					SetTimeout(10000,function()
						actived[user_id] = nil
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("remedios",source)
						vRPclient._DeletarObjeto(src)
					end)
				end
			end
		elseif type == "equipar" then
			if vRP.tryGetInventoryItem(user_id,itemName,1) then
				local weapons = {}
				local identity = vRP.getUserIdentity(user_id)
				local nameweapon = string.gsub(itemName,"wbody|","")
				weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
				vRPclient._giveWeapons(source,weapons)
				PerformHttpRequest(config.webhookEquip, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM EQUIPADO:\n⠀",thumbnail = {url = config.webhookIcon}, fields = {{name = "**QUEM EQUIPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, {name = "**ITEM EQUIPADO:**", value = "[ **Item: "..vRP.itemNameList(itemName).."** ]"}}, footer = {text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				TriggerClientEvent("itensNotify",source,"usar","Equipou",""..vRP.itemNameList(itemName).."")
				TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
			end
		elseif type == "recarregar" then
			local uweapons = vRPclient.getWeapons(source)
      		local weaponuse = string.gsub(itemName,"wammo|","")
      		local weaponusename = "wammo|"..weaponuse
			local identity = vRP.getUserIdentity(user_id)
      		if uweapons[weaponuse] then
        		local itemAmount = 0
        		local data = vRP.getUserDataTable(user_id)
        		for k,v in pairs(data.inventory) do
          			if weaponusename == k then
            			if v.amount > 250 then
              				v.amount = 250
            			end

            			itemAmount = v.amount

						if vRP.tryGetInventoryItem(user_id, weaponusename, parseInt(v.amount)) then
							local weapons = {}
							weapons[weaponuse] = { ammo = v.amount }
							itemAmount = v.amount
							vRPclient._giveWeapons(source,weapons,false)
							PerformHttpRequest(config.webhookEquip, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM EQUIPADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{ name = "**QUEM EQUIPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, { name = "**ITEM EQUIPADO:**", value = "[ **Item: "..vRP.itemNameList(itemName).."** ][ **Quantidade: "..vRP.format(parseInt(v.amount)).."** ]"}}, footer = {text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon},color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
							TriggerClientEvent("itensNotify",source,"usar","Recarregou",""..vRP.itemNameList(itemName).."")
							TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
						end
          			end
        		end
			end
		end
	end
end

--[ PLAYERLEAVE ]------------------------------------------------------------------------------------------------------------------------

AddEventHandler("vRP:playerLeave",function(user_id,source)
	actived[user_id] = nil
end)

--[ GARMAS ]-----------------------------------------------------------------------------------------------------------------------------

RegisterCommand('garmas',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local rtime = math.random(3,8)
	TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Suas armas estão sendo desequipadas.",9500)
	TriggerClientEvent("progress",source,10000,"guardando")
	SetTimeout(1000*rtime,function()
		if user_id then
			local weapons = vRPclient.replaceWeapons(source,{})
			for k,v in pairs(weapons) do
				vRP.giveInventoryItem(user_id,"wbody|"..k,1)
				PerformHttpRequest(config.webhookUnEquip, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM DESEQUIPADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{ name = "**QUEM DESEQUIPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"},{ name = "**ITEM EQUIPADO:**", value = "[ **Item: "..k.."** ][ **Quantidade: 1** ]"}}, footer = { text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				if v.ammo > 0 then
					vRP.giveInventoryItem(user_id,"wammo|"..k,v.ammo)
					PerformHttpRequest(config.webhookUnEquip, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM DESEQUIPADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{name = "**QUEM DESEQUIPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, {name = "**ITEM DESEQUIPADO:**", value = "[ **Item: "..k.."** ][ **Quantidade: "..vRP.format(parseInt(v.ammo)).."** ]"}}, footer = { text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon},color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				end
			end
			TriggerClientEvent("Notify",source,"sucesso","Guardou seu armamento na mochila.")
		end
	end)
	SetTimeout(10000,function()
		TriggerClientEvent("Notify",source,"sucesso","Guardou seu armamento na mochila.")
	end)
end)

--[ GCOLETE ]----------------------------------------------------------------------------------------------------------------------------

RegisterCommand('gcolete',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local rtime = math.random(3,8)
	if vRPclient.getArmour(source) <= 99 then
		TriggerClientEvent("Notify",source,"negado","Você não pode desequipar um <b>colete danificado</b>.")
	else	
		TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando seu colete.",9000)
		TriggerClientEvent("progress",source,10000,"guardando")
		SetTimeout(1000*rtime,function()
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("colete") <= vRP.getInventoryMaxWeight(user_id) then
				PerformHttpRequest(config.webhookUnEquip, function(err, text, headers) end, 'POST', json.encode({embeds = {{title = "REGISTRO DE ITEM DESEQUIPADO:\n⠀", thumbnail = {url = config.webhookIcon}, fields = {{name = "**QUEM DESEQUIPOU:**", value = "**"..identity.name.." "..identity.firstname.."** [**"..user_id.."**]"}, {name = "**ITEM DESEQUIPADO:**", value = "[ **Item: Colete** ][ **Quantidade: 1** ]"}}, footer = {text = config.webhookBottom..os.date("%d/%m/%Y | %H:%M:%S"), icon_url = config.webhookIcon}, color = config.webhookColor}}}), { ['Content-Type'] = 'application/json' })
				vRP.giveInventoryItem(user_id,"colete",1)
				vRPclient.setArmour(source,0)
			else
				TriggerClientEvent("Notify",source,"negado","Espaço insuficiente na mochila.")
			end
		end)
		SetTimeout(10000,function()
			TriggerClientEvent("itensNotify",source,"usar","Desequipou","Colete")
		end)
	end
end)

--[ GMOCHILA ]---------------------------------------------------------------------------------------------------------------------------

RegisterCommand('gmochila',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local rtime = math.random(3,8)

	if user_id then
		if vRP.getExp(user_id,"physical","strength") == 1900 then -- 90Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 15 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-580)
					vRP.giveInventoryItem(user_id,"mochila",1)
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				end)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 1320 then -- 75Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 24 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-650)
					vRP.giveInventoryItem(user_id,"mochila",1)
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("Notify",source,"sucesso","Você desequipou uma de suas mochilas.")
				end)
			else 
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 670 then -- 51Kg
			if vRP.getInventoryMaxWeight(user_id)-vRP.getInventoryWeight(user_id) >= 45 then
				TriggerClientEvent("progress",source,10000,"guardando")
				TriggerClientEvent("Notify",source,"aviso","<b>Aguarde!</b> Você está desequipando sua mochila.",9000)
				SetTimeout(1000*rtime,function()
					vRP.varyExp(user_id,"physical","strength",-650)
					vRP.giveInventoryItem(user_id,"mochila",1)
					TriggerClientEvent("inventory:mochilaoff",source)
					TriggerClientEvent('vrp_inventory:Update',source,'updateMochila')
				end)
				SetTimeout(10000,function()
					TriggerClientEvent("itensNotify",source,"usar","Desequipou","Mochila")
				end)
			else
				TriggerClientEvent("Notify",source,"negado","Você precisa esvaziar a mochila antes de fazer isso.")
			end
		elseif vRP.getExp(user_id,"physical","strength") == 20 then -- 6Kg
			TriggerClientEvent("Notify",source,"negado","Você não tem mochilas equipadas.")
		end
	end
end)

function vRPN.checkMochila()
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.getExp(user_id,"physical","strength") >= 670 then
		return true
	end
end

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end