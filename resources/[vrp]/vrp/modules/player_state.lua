local cfg = module("cfg/player_state")

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	vRPclient._setFriendlyFire(source,true)

	if first_spawn then
		if data.colete then
			vRPclient.setArmour(source,data.colete)
		end

		if data.customization == nil then
			data.customization = cfg.default_customization
		end

		if data.position then
			vRPclient.teleport(source,data.position.x,data.position.y,data.position.z)
		end

		if data.customization then
			vRPclient.setCustomization(source,data.customization)
			if data.weapons then
				tvRP.giveWeapons(source,data.weapons,true)

				if data.health then
					vRPclient.setHealth(source,data.health)
					SetTimeout(5000,function()
						if vRPclient.isInComa(source) then
							vRPclient.killComa(source)
						end
					end)
				end
			end
		else
			if data.weapons then
				tvRP.giveWeapons(source,data.weapons,true)
			end

			if data.health then
				vRPclient.setHealth(source,data.health)
			end
		end
	else
		vRPclient._setHandcuffed(source,false)

		if not vRP.hasPermission(user_id,"mochila.permissao") then
			data.gaptitudes = {}
		end

		if data.customization then
			vRPclient._setCustomization(source,data.customization)
		end
	end
		vRPclient._playerStateReady(source,true)
end)

function tvRP.updatePos(x,y,z)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local tmp = vRP.getUserTmpTable(user_id)
		if data and (not tmp or not tmp.home_stype) then
			data.position = { x = tonumber(x), y = tonumber(y), z = tonumber(z) }
		end
	end
end

function tvRP.updateArmor(armor)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.colete = armor
		end
	end
end

AddEventHandler("vRP:giveWeapons", function(src, weapons, clear_before)
    tvRP.giveWeapons(src, weapons, clear_before)
end)

function tvRP.giveWeapons(src, weapons, clear_before)
	--local src = vRP.getUserSource(user_id)
	--print('chamou: ' .. src .. '\n')
	local user_id = nil
	if src == nil then
		src = source
		user_id = vRP.getUserId(src)
	else
		user_id = vRP.getUserId(src)
	end
	--print(json.encode(weapons,{indent = true}))
	if src then
		local data = vRP.getUserDataTable(user_id)
		--print(json.encode(weapons,{indent = true}) .. '\n')
		if data then
			--print('vapo\n')
			if clear_before then
				RemoveAllPedWeapons(src,true)
			end

			for k,weapon in pairs(weapons) do
				--print('arma: ' .. k .. '\n')
				data.weapons[k] = {}
				data.weapons[k].ammo = weapon.ammo or 0
				local hash = GetHashKey(k)
				GiveWeaponToPed(src,hash,data.weapons[k].ammo,false,false)
			end
		end
	end
end

function tvRP.updateWeapons(weapons)
	local src = source
	local user_id = vRP.getUserId(src)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		local ped = GetPlayerPed(src)
		for k, v in pairs(weapons) do
			if data.weapons[k] then
				if v.ammo > data.weapons[k].ammo then
					SetPedAmmo(ped, GetHashKey(k), data.weapons[k].ammo)
					--criar um check de quantidade que entrou nesta condicao para banir o usuario pro setar municao
				else
					data.weapons[k].ammo = v.ammo
				end
			else
				RemoveWeaponFromPed(ped, GetHashKey(k))
			end
		end
	end
end

--[[function tvRP.updateWeapons(weapons)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.weapons = weapons
		end
	end
end]]

function tvRP.updateCustomization(customization)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.customization = customization
		end
	end
end

function tvRP.updateHealth(health)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data then
			data.health = health
		end
	end
end

--[ MALA ]-------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("trymala")
AddEventHandler("trymala",function(nveh)
	TriggerClientEvent("syncmala",-1,nveh)
end)