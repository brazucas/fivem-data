local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_garages", src)
vCLIENT = Tunnel.getInterface("vrp_garages")
local idgens = Tools.newIDGenerator()

--[ FUNÇÕES ]---------------------------------------

function vRP.getUsers(user_id)
    local p = promise.new()
    exports.mongodb:find({ collection = "vrp_users", query = { _id = user_id } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(result))
            return
        end
    end)
    return Citizen.Await(p)
end

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------

local logAdminCar = ""
local logAdminDv = ""

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local brzVehs = {}

local police = {}
local vehlist = {}
local trydoors = {}
trydoors["CLONADOS"] = true
trydoors["CREATIVE"] = true

--[ RETURNVEHICLESEVERYONE ]-------------------------------------------------------------------------------------------------------------

function src.returnVehicleEveryone(placa)
    return trydoors[placa]
end

--[ SETPLATEEVERYONE ]-------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("setPlateEveryone")
AddEventHandler("setPlateEveryone", function(placa)
    trydoors[placa] = true
end)

--[ GARAGENS ]---------------------------------------------------------------------------------------------------------------------------

local garages = ConfigGaragens.garages

--[ GARAGEMS ]---------------------------------------------------------------------------------------------------------------------------

local workgarage = ConfigGaragens.workgarage

--[ SPAWNS ]------------------------------------------------------------------------------------------------------------------------------

local spawn = ConfigGaragens.spawn

--[ INIT SETUP ]----------------------------------------------------------------------------------------------------------------------------

AddEventHandler("onResourceStart", function(resName)
	if GetCurrentResourceName() ~= resName then
		return
	end

    SetTimeout(1000, function()
        TriggerClientEvent('brz:sendVehicleSpawns', -1, spawn)
    end)

    while not exports.mongodb:isConnected() do
        Wait(1)
    end
    local p = promise.new()
    exports.mongodb:find({ collection = "brz_vehicles", query = {}}, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(result))
            return
        end
    end)
    local vehs = Citizen.Await(p)

    if vehs then
        local vehCriado = 0
        print('mongo vehicles result: '..#vehs)
        for k, state in pairs(vehs) do
            if state.position ~= 'garagem' then
                local vehParams = {}
                vehParams.dono = state.dono
                vehParams.placa = state.placa
                vehParams.name = state.name
                local spawnveh = true
                print(json.encode(state.position,{indent = true}))
                local vehid = CriarVeiculo(GetHashKey(state.name),state.position,vehParams)
                print(vehParams.name)
                if brzVehs[vehid] ~= nil then
                    local vehnet = brzVehs[vehid].networkId
                    if spawnveh then
                        vehlist[vehnet] = { state.dono, state.name }
                        TriggerEvent("setPlateEveryone", state.placa)
                    end
                    vehCriado = vehCriado + 1
                end
            end
        end
        print(vehCriado .. ' veículos criados pelo servidor.')
    end
end)

AddEventHandler("onResourceStop", function(resource)
    print(resource)
    if GetCurrentResourceName() ~= resource then
		return
	end
    print(GetCurrentResourceName())
    for vehid, state in pairs(brzVehs) do
        print(vehid)
        if brzVehs[vehid].networkId then
            print(brzVehs[vehid].networkId)
            --src.tryDelete(brzVehs[vehid].networkId)
            SalvarVeiculo(vehid, true)
            brzVehs[vehid] = nil
            DeleteEntity(vehid)

        end
    end
end)

--[ MYVEHICLES ]-------------------------------------------------------------------------------------------------------------------------

function vRP.getUserVehicle(user_id, publico)
    if not publico then
        local p = promise.new()
        exports.mongodb:findOne({ collection = "vrp_user_vehicles", query = { user_id = user_id } }, function(success, results)
            if success then
                p:resolve(results or {})
            else
                p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
                return
            end
        end)

        local vehicles = Citizen.Await(p)

        return vehicles
    else
        local data = vRP.getUData(user_id, "veiculoPublico")
        local vehParams = json.decode(data) or nil
        --if data and date ~= nil then
        if data and vehParams ~= nil then
            return vehParams
        else
            return false
        end
    end
end

function vRP.getUserVehicles(user_id, vehicle)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_user_vehicles", query = { user_id = user_id, vehicle = vehicle } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    local vehicles = Citizen.Await(p)

    return vehicles
end

function vRP.modeloVehForaDaGaragem(user_id, name)
    for vehid, state in pairs(brzVehs) do
        if state.dono == user_id and state.name == name then
            return true
        end
    end

    return false
end

function src.myVehicles(work)
    local source = source
    local user_id = vRP.getUserId(source)
    local myvehicles = {}
    local ipva = ""
    local status = ""
    if user_id then
        if workgarage[work] then
            local vehicleParams = vRP.getUserVehicle(user_id, true)
            for k, v in pairs(workgarage) do
                if k == work then
                    for k2, v2 in pairs(v) do
                        if k == "Aluguel" then
                            status = "Veículo de aluguel"
                            ipva = "<span class=\"green\">N/A</span>"
                            if not vehicleParams then
                                table.insert(myvehicles,{ name = v2, name2 = vRP.vehicleName(v2), engine = 100, body = 100, fuel = 100, status = status, ipva = ipva })
                            else
                                table.insert(myvehicles, { name = v2, name2 = vRP.vehicleName(v2), engine = parseInt(vehicleParams.eng * 0.1),
                                body = parseInt(vehicleParams.bod * 0.1), fuel = 100, status = status, ipva = ipva })
                            end
                        else
                            status = "<span class=\"green\">" .. k .. "</span>"
                            ipva = "<span class=\"green\">Pago</span>"
                            if not vehicleParams then
                                table.insert(myvehicles,{ name = v2, name2 = vRP.vehicleName(v2), engine = 100, body = 100, fuel = 100, status = status, ipva = ipva })
                            else
                                table.insert(myvehicles, { name = v2, name2 = vRP.vehicleName(v2), engine = parseInt(vehicleParams.eng * 0.1),
                                body = parseInt(vehicleParams.bod * 0.1), fuel = 100, status = status, ipva = ipva })
                            end
                        end
                    end
                end
            end
            return myvehicles
        else
            local vehicle = vRP.getUserVehicle(user_id)
            local address = vRP.getHomeUserId(parseInt(user_id))
            if #address > 0 then
                for k, v in pairs(address) do
                    if v.home == work then
                        for k2, v2 in pairs(vehicle) do
                            if parseInt(os.time()) <= parseInt(vehicle[k2].time + 24 * 60 * 60) then
                                status = "<span class=\"red\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle) * 0.5)) .. "</span>"
                            elseif vehicle[k2].detido == 1 then
                                status = "<span class=\"orange\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle) * 0.1)) .. "</span>"
                            else
                                status = "<span class=\"green\">Gratuita</span>"
                            end

                            if parseInt(os.time()) >= parseInt(vehicle[k2].ipva + 24 * 15 * 60 * 60) then
                                ipva = "<span class=\"red\">Atrasado</span>"
                            else
                                ipva = "<span class=\"green\">Pago</span>"
                            end
                            table.insert(myvehicles, { name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine * 0.1), body = parseInt(vehicle[k2].body * 0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
                        end
                        return myvehicles
                    else
                        for k2, v2 in pairs(vehicle) do
                            if parseInt(os.time()) <= parseInt(vehicle[k2].time + 24 * 60 * 60) then
                                status = "<span class=\"red\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle) * 0.5)) .. "</span>"
                            elseif vehicle[k2].detido == 1 then
                                status = "<span class=\"orange\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle) * 0.1)) .. "</span>"
                            else
                                status = "<span class=\"green\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k2].vehicle) * 0.005)) .. "</span>"
                            end

                            if parseInt(os.time()) >= parseInt(vehicle[k2].ipva + 24 * 15 * 60 * 60) then
                                ipva = "<span class=\"red\">Atrasado</span>"
                            else
                                ipva = "<span class=\"green\">Pago</span>"
                            end
                            table.insert(myvehicles, { name = vehicle[k2].vehicle, name2 = vRP.vehicleName(vehicle[k2].vehicle), engine = parseInt(vehicle[k2].engine * 0.1), body = parseInt(vehicle[k2].body * 0.1), fuel = parseInt(vehicle[k2].fuel), status = status, ipva = ipva })
                        end
                        return myvehicles
                    end
                end
            else
                for k, v in pairs(vehicle) do
                    if parseInt(os.time()) <= parseInt(vehicle[k].time + 24 * 60 * 60) then
                        status = "<span class=\"red\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle) * 0.5)) .. "</span>"
                    elseif vehicle[k].detido == 1 then
                        status = "<span class=\"orange\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle) * 0.1)) .. "</span>"
                    else
                        status = "<span class=\"green\">$" .. vRP.format(parseInt(vRP.vehiclePrice(vehicle[k].vehicle) * 0.005)) .. "</span>"
                    end

                    if parseInt(os.time()) >= parseInt(vehicle[k].ipva + 24 * 15 * 60 * 60) then
                        ipva = "<span class=\"red\">Atrasado</span>"
                    else
                        ipva = "<span class=\"green\">Pago</span>"
                    end
                    table.insert(myvehicles, { name = vehicle[k].vehicle, name2 = vRP.vehicleName(vehicle[k].vehicle), engine = parseInt(vehicle[k].engine * 0.1), body = parseInt(vehicle[k].body * 0.1), fuel = parseInt(vehicle[k].fuel), status = status, ipva = ipva })
                end
                return myvehicles
            end
        end
    end
end

--[ SPAWNVEHICLES ]----------------------------------------------------------------------------------------------------------------------

function src.spawnVehicles(name, use)
    if name then
        local source = source
        local user_id = vRP.getUserId(source)
        if user_id then
            local identity = vRP.getUserIdentity(user_id)
            local value = vRP.getUData(parseInt(user_id), "vRP:multas")
            local multas = json.decode(value) or 0
            if multas >= 10000 then
                TriggerClientEvent("Notify", source, "negado", "Você tem multas pendentes.", 10000)
                return true
            end
            if not vRP.modeloVehForaDaGaragem(user_id, name) then
                local vehicle = vRP.getUserVehicles(parseInt(user_id), name)
                local tuning = vRP.getSData("custom:u" .. user_id .. "veh_" .. name) or {}
                local custom = json.decode(tuning) or {}
                if vehicle[1] ~= nil then
                    if parseInt(os.time()) <= parseInt(vehicle[1].time + 24 * 60 * 60) then
                        local ok = vRP.request(source, "Veículo na retenção, deseja acionar o seguro pagando <b>$" .. vRP.format(parseInt(vRP.vehiclePrice(name) * 0.5)) .. "</b> dólares ?", 60)
                        if ok then
                            if vRP.tryFullPayment(user_id, parseInt(vRP.vehiclePrice(name) * 0.5)) then
                                exports.mongodb:updateOne({
                                    collection = "vrp_user_vehicles",
                                    query = { user_id = parseInt(user_id), vehicle = name },
                                    update = { ["$set"] = { detido = 0, time = 0 } }
                                })

                                TriggerClientEvent("Notify", source, "sucesso", "Veículo liberado.", 10000)
                            else
                                TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
                            end
                        end
                    elseif parseInt(vehicle[1].detido) >= 1 then
                        local ok = vRP.request(source, "Veículo na detenção, deseja acionar o seguro pagando <b>$" .. vRP.format(parseInt(vRP.vehiclePrice(name) * 0.1)) .. "</b> dólares ?", 60)
                        if ok then
                            if vRP.tryFullPayment(user_id, parseInt(vRP.vehiclePrice(name) * 0.1)) then
                                exports.mongodb:updateOne({
                                    collection = "vrp_user_vehicles",
                                    query = { user_id = parseInt(user_id), vehicle = name },
                                    update = { ["$set"] = { detido = 0, time = 0 } }
                                })
                                TriggerClientEvent("Notify", source, "sucesso", "Veículo liberado.", 10000)
                            else
                                TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
                            end
                        end
                    else
                        if parseInt(os.time()) <= parseInt(vehicle[1].ipva + 24 * 15 * 60 * 60) then
                            if garages[use].payment then
                                if vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental" then
                                    local spawnveh, vehid = vCLIENT.spawnVehicle(source, name, vehicle[1].engine, vehicle[1].body, vehicle[1].fuel, custom)
                                    vehlist[vehid] = { parseInt(user_id), name }
                                    TriggerEvent("setPlateEveryone", identity.public_plate)
                                    TriggerClientEvent("Notify", source, "sucesso", "Veículo <b>Exclusivo ou Alugado</b>, Não será cobrado a taxa de liberação.", 10000)
                                end
                                if (vRP.getBankMoney(user_id) + vRP.getMoney(user_id)) >= parseInt(vRP.vehiclePrice(name) * 0.005 and not vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental") then
                                    local spawnveh, vehid = vCLIENT.spawnVehicle(source, name, vehicle[1].engine, vehicle[1].body, vehicle[1].fuel, custom)
                                    if spawnveh and vRP.tryFullPayment(user_id, parseInt(vRP.vehiclePrice(name) * 0.005)) then
                                        vehlist[vehid] = { parseInt(user_id), name }
                                        TriggerEvent("setPlateEveryone", identity.public_plate)
                                    end
                                else
                                    TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
                                end
                            else
                                local spawnveh, vehid = vCLIENT.spawnVehicle(source, name, vehicle[1].engine, vehicle[1].body, vehicle[1].fuel, custom, parseInt(vehicle[1].colorR), parseInt(vehicle[1].colorG), parseInt(vehicle[1].colorB), parseInt(vehicle[1].color2R), parseInt(vehicle[1].color2G), parseInt(vehicle[1].color2B), false)
                                if spawnveh then
                                    vehlist[vehid] = { user_id, name }
                                    TriggerEvent("setPlateEveryone", identity.public_plate)
                                end
                            end
                        else
                            if vRP.vehicleType(tostring(name)) == "exclusive" or vRP.vehicleType(tostring(name)) == "rental" then
                                local ok = vRP.request(source, "Deseja pagar o <b>Vehicle Tax</b> do veículo <b>" .. vRP.vehicleName(name) .. "</b> por <b>$" .. vRP.format(parseInt(vRP.vehiclePrice(name) * 0.00)) .. "</b> dólares?", 60)
                                if ok then
                                    if vRP.tryFullPayment(user_id, parseInt(vRP.vehiclePrice(name) * 0.00)) then
                                        exports.mongodb:updateOne({
                                            collection = "vrp_user_vehicles",
                                            query = { user_id = parseInt(user_id), vehicle = name },
                                            update = { ["$set"] = { ipva = parseInt(os.time()) } }
                                        })
                                        TriggerClientEvent("Notify", source, "sucesso", "Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.", 10000)
                                    else
                                        TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
                                    end
                                end
                            else
                                local price_tax = parseInt(vRP.vehiclePrice(name) * 0.10)
                                if price_tax > 100000 then
                                    price_tax = 100000
                                end
                                local ok = vRP.request(source, "Deseja pagar o <b>Vehicle Tax</b> do veículo <b>" .. vRP.vehicleName(name) .. "</b> por <b>$" .. vRP.format(price_tax) .. "</b> dólares?", 60)
                                if ok then
                                    if vRP.tryFullPayment(user_id, price_tax) then
                                        exports.mongodb:updateOne({
                                            collection = "vrp_user_vehicles",
                                            query = { user_id = parseInt(user_id), vehicle = name },
                                            update = { ["$set"] = { ipva = parseInt(os.time()) } }
                                        })

                                        TriggerClientEvent("Notify", source, "sucesso", "Pagamento do <b>Vehicle Tax</b> conclúido com sucesso.", 10000)
                                    else
                                        TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 10000)
                                    end
                                end
                            end
                        end
                    end
                else
                    if vRP.vehicleType(tostring(name)) == "rental" then
                        local pagamento = parseInt(vRP.vehiclePrice(name) * 1 / 100)

                        if vRP.tryFullPayment(user_id, pagamento) then
                            local spawnveh, vehid = vCLIENT.spawnVehicle(source, name, 1000, 1000, 1000, 0, 1000, 0, 0, 0, 0, 0, 100, custom, 0, 0, 0, 0, 0, 0, true)
                            if spawnveh then
                                vehlist[vehid] = { user_id, name }
                                TriggerEvent("setPlateEveryone", identity.public_plate)
                            end
                            TriggerClientEvent("Notify", source, "sucesso", "Você pagou <b>$" .. pagamento .. " dólares</b> no aluguel do veículo.")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.")
                        end
                    else
                        local spawnID = ChecarCriarVeiculo(use)
                        if spawnID ~= -1 then
                            local vehParams = {}
                            vehParams.dono = user_id
                            vehParams.placa = identity.public_plate
                            vehParams.name = name
                            local spawnveh = true
                            local vehid = CriarVeiculo(GetHashKey(name),spawn[use][spawnID],vehParams)
                            if brzVehs[vehid] ~= nil then
                                local vehnet = brzVehs[vehid].networkId
                                if spawnveh then
                                    vehlist[vehnet] = { user_id, name }
                                    TriggerEvent("setPlateEveryone", identity.public_plate)
                                end
                            end
                        else
                            TriggerClientEvent("Notify", source, "negado", "Erro ao retirar veículo da garagem.")
                        end
                    end
                end
            else
                TriggerClientEvent("Notify", source, "aviso", "Já possui um veículo deste modelo fora da garagem.", 10000)
            end
        end
    end
end

--[ SPAWNVEHICLES SERVERSIDE ]----------------------------------------------------------------------------------------------------------------------
function src.getVehicleState(placa)
    local state = vRP.getVData(placa) or nil
	--local state = json.decode(data) or nil
	if state ~= nil then
        return state
    else
        state = nil
    end
    return state
end

function SalvarVeiculo(veh, guardou)
    print('salvando veh')
    if not DoesEntityExist(veh) then
        brzVehs[veh] = nil
        return
    end
    local owner = NetworkGetEntityOwner(veh)
    print('owner: ' .. owner)
    if owner ~= -1 then
        local state = vCLIENT.getVehicleStates(owner, brzVehs[veh].networkId)

        --state = VerificarVeiculo(veh, owner, state)

        state.placa = brzVehs[veh].placa
        state.dono = brzVehs[veh].dono
        state.name = brzVehs[veh].name

        --if brzVehs[veh].networkOwner ~= owner then
            --brzVehs[veh].networkOwner = owner
            local src = vRP.getUserSource(brzVehs[veh].dono)
            if src then
                --if not vCLIENT.hasBlip(src, state.name) then
                    vCLIENT.syncBlips(src, brzVehs[veh].networkId, state.name, state.position)
                --end
            end
        --end

        if guardou then
            state.position = 'garagem'
            state.rotation = 'garagem'
        else
            state.position = {}
            state.position.x, state.position.y, state.position.z = table.unpack(GetEntityCoords(veh))
        end

        brzVehs[veh].state = state
        vRP.setVData(brzVehs[veh].placa,brzVehs[veh].state)
    else
        --if brzVehs[veh].networkOwner ~= owner then
            --brzVehs[veh].networkOwner = owner

            local src = vRP.getUserSource(brzVehs[veh].dono)
            if src then
                --if not vCLIENT.hasBlip(src, brzVehs[veh].name) then
                local position = {}
                position.x, position.y, position.z = table.unpack(GetEntityCoords(veh))
                    vCLIENT.syncBlips(src, brzVehs[veh].networkId, ConfigGaragens.vehicleHashesToString[GetEntityModel(veh)], position)
                --end
            end
        --end
    end
end

function VerificarVeiculo(veh, owner, state)
    if state ~= nil then
        if state.condition then
            if state.condition.health > brzVehs[veh].state.condition.health then
                state.condition.health = brzVehs[veh].state.condition.health
            end

            if state.condition.body_health > brzVehs[veh].state.condition.body_health  then
                state.condition.body_health = brzVehs[veh].state.condition.body_health
                SetVehicleBodyHealth(veh, state.condition.body_health)
            end

            if state.condition.dirt_level > brzVehs[veh].state.condition.dirt_level then
                state.condition.dirt_level = brzVehs[veh].state.condition.dirt_level
                SetVehicleDirtLevel(veh, state.condition.dirt_level)
            end

            --[[if state.condition.doors then
                for i, door_state in pairs(state.condition.doors) do
                    if door_state ~= brzVehs[veh].state.condition.doors[i] then
                        state.condition.doors[i] = brzVehs[veh].state.condition.doors[i]
                        if state.condition.doors[i] then
                            SetVehicleDoorBroken(veh, parseInt(i), true)
                        end
                    end
                end
            end]]

            if state.condition.engine_health > brzVehs[veh].state.condition.engine_health then
                state.condition.engine_health = brzVehs[veh].state.condition.engine_health
            end

            if state.condition.fuel_level > brzVehs[veh].state.condition.fuel_level then
                state.condition.fuel_level = brzVehs[veh].state.condition.fuel_level
            end

            if state.condition.oil_level > brzVehs[veh].state.condition.oil_level then
                state.condition.oil_level = brzVehs[veh].state.condition.oil_level
            end

            if state.condition.petrol_tank_health > brzVehs[veh].state.condition.petrol_tank_health then
                state.condition.petrol_tank_health = brzVehs[veh].state.condition.petrol_tank_health
            end

            if state.condition.tyres then
                for i, tyre_state in pairs(state.condition.tyres) do
                    if tyre_state and brzVehs[veh].state.condition.tyres[i] then
                        if tyre_state > brzVehs[veh].state.condition.tyres[i] then
                            state.condition.tyres[i] = brzVehs[veh].state.condition.tyres[i]
                        end
                    end
                end
            end
        end

        if state.customization.colours then
            local changedColors = false
            for i, colours in pairs(state.customization.colours) do
                if colours ~= brzVehs[veh].state.customization.colours[i] then
                    state.customization.colours[i] = brzVehs[veh].state.customization.colours[i]
                    changedColors = true
                end
            end
            if changedColors then SetVehicleColours(veh, table.unpack(state.customization.colours)) end
        end

        if state.customization.extra_colours then
            for i, extra_colours in pairs(state.customization.extra_colours) do
                if extra_colours ~= brzVehs[veh].state.customization.extra_colours[i] then
                    state.customization.extra_colours[i] = brzVehs[veh].state.customization.extra_colours[i]
                end
            end
        end

        if state.customization.plate_index then
            if state.customization.plate_index ~= brzVehs[veh].state.customization.plate_index then
                state.customization.plate_index = brzVehs[veh].state.customization.plate_index
            end
        end

        if state.customization.wheel_type then
            if state.customization.wheel_type ~= brzVehs[veh].state.customization.wheel_type then
                state.customization.wheel_type = brzVehs[veh].state.customization.wheel_type
            end
        end

        if state.customization.tyre_armor then
            if state.customization.tyre_armor ~= brzVehs[veh].state.customization.tyre_armor then
                state.customization.tyre_armor = brzVehs[veh].state.customization.tyre_armor
            end
        end

        if state.customization.window_tint then
            if state.customization.window_tint ~= brzVehs[veh].state.customization.window_tint then
                state.customization.window_tint = brzVehs[veh].state.customization.window_tint
            end
        end

        if state.customization.livery then
            if state.customization.livery ~= brzVehs[veh].state.customization.livery then
                state.customization.livery = brzVehs[veh].state.customization.livery
            end
        end

        if state.customization.neons then
            for i=0,3 do
                if state.customization.neons[i] ~= brzVehs[veh].state.customization.neons[i] then
                    state.customization.neons[i] = brzVehs[veh].state.customization.neons[i]
                end
            end
        end

        if state.customization.neon_colour then
            for i, neon_colour in pairs(state.customization.neon_colour) do
                if neon_colour ~= brzVehs[veh].state.customization.neon_colour[i] then
                    state.customization.neon_colour[i] = brzVehs[veh].state.customization.neon_colour[i]
                end
            end
        end

        if state.customization.tyre_smoke_color then
            for i, tyre_smoke_color in pairs(state.customization.tyre_smoke_color) do
                if tyre_smoke_color ~= brzVehs[veh].state.customization.tyre_smoke_color[i] then
                    state.customization.tyre_smoke_color[i] = brzVehs[veh].state.customization.tyre_smoke_color[i]
                end
            end
        end

        if state.customization.mods then
            for i, mod in pairs(state.customization.mods) do
                if mod ~= brzVehs[veh].state.customization.mods[i] then
                    state.customization.mods[i] = brzVehs[veh].state.customization.mods[i]
                end
            end
        end

        if state.customization.turbo_enabled ~= nil then
            if state.customization.turbo_enabled ~= brzVehs[veh].state.customization.turbo_enabled then
                state.customization.turbo_enabled = brzVehs[veh].state.customization.turbo_enabled
            end
        end

        if state.customization.smoke_enabled ~= nil then
            if state.customization.smoke_enabled ~= brzVehs[veh].state.customization.smoke_enabled then
                state.customization.smoke_enabled = brzVehs[veh].state.customization.smoke_enabled
            end
        end

        if state.customization.xenon_enabled ~= nil then
            if state.customization.xenon_enabled ~= brzVehs[veh].state.customization.xenon_enabled then
                state.customization.xenon_enabled = brzVehs[veh].state.customization.xenon_enabled
            end
        end

        if NetworkGetEntityOwner(veh) ~= -1 then TriggerClientEvent('applyMissingVehicleCustomizations', NetworkGetEntityOwner(veh), NetworkGetNetworkIdFromEntity(veh), state) end
        return state
    end
end

function ChecarCriarVeiculo(idG)
    local checkslot = 1
    for veh, state in pairs(brzVehs) do
        if DoesEntityExist(veh) then
            if vRP.DistanceBetweenCoords(spawn[idG][checkslot], GetEntityCoords(veh)) < 0.5 and checkslot > #spawn[idG] then
                checkslot = -1
                TriggerEvent("Notify","importante","Todas as vagas estão ocupadas no momento.",10000)
                break
            end
            checkslot = checkslot + 1
        end
    end
    return checkslot
end

function CriarVeiculo(modelHashed, position, vehParams)
    local state = src.getVehicleState(vehParams.placa)
    local rotation = nil
    if state ~= nil then
        if state.position ~= 'garagem' then
            position = state.position
        end
        if state.rotation ~= 'garagem' then
            rotation = state.rotation
        end
    end
    local vehicleHnd = Citizen.InvokeNative(`CREATE_AUTOMOBILE`,modelHashed, position.x, position.y, position.z, position.h or 0.0, true)

    SetVehicleNumberPlateText(vehicleHnd, vehParams.placa)
    if rotation ~= nil then
        SetEntityRotation(vehicleHnd, rotation.x, rotation.y, rotation.z)
    end

    local networkId = NetworkGetNetworkIdFromEntity(vehicleHnd)

    brzVehs[vehicleHnd] = {}
    brzVehs[vehicleHnd].networkId = networkId
    brzVehs[vehicleHnd].modelo = modelHashed
    brzVehs[vehicleHnd].placa = vehParams.placa
    brzVehs[vehicleHnd].dono = vehParams.dono
    brzVehs[vehicleHnd].name = ConfigGaragens.vehicleHashesToString[GetEntityModel(vehicleHnd)]
    brzVehs[vehicleHnd].state = state

    --print(json.encode(brzVehs[vehicleHnd].state,{indent = true}))

    Citizen.CreateThread(function()
        while brzVehs[vehicleHnd] ~= nil do
            if not DoesEntityExist(vehicleHnd) then
                brzVehs[vehicleHnd] = nil
                break
            end
            if NetworkGetEntityOwner(vehicleHnd) ~= -1 then SalvarVeiculo(vehicleHnd) end
            Citizen.Wait(5000) --salvar status do veiculo a cada 5s
        end
    end)

    Citizen.CreateThread(function()
        while true do
            if DoesEntityExist(vehicleHnd) and NetworkGetEntityOwner(vehicleHnd) ~= -1 then
                SetVehicleState(vehicleHnd, brzVehs[vehicleHnd].state)
                break
            end
            Citizen.Wait(500)
        end
    end)

    return vehicleHnd
end

-- partial update per property
function SetVehicleState(veh, state)
    if state ~= nil then
        -- apply state
        if state.customization.colours then
            SetVehicleColours(veh, table.unpack(state.customization.colours))
        end

        if state.condition then

            if state.condition.body_health then
                SetVehicleBodyHealth(veh, state.condition.body_health)
            end

            if state.condition.dirt_level then
                SetVehicleDirtLevel(veh, state.condition.dirt_level)
            end

            if state.condition.doors then
                for i, door_state in pairs(state.condition.doors) do
                    if not door_state then
                        SetVehicleDoorBroken(veh, parseInt(i), true)
                    end
                end
            end
        end

        --[[if state.locked ~= nil then
            if state.locked then -- lock
                SetVehicleDoorsLocked(veh,2)
            else -- unlock
                SetVehicleDoorsLocked(veh,1)
            end
        end]]
    end

    --Citizen.CreateThread(function()
        local owner = NetworkGetEntityOwner(veh)
        local pos = GetEntityCoords(veh)
        --[[while owner == -1 do
            owner = NetworkGetEntityOwner(veh)
            vCLIENT.syncBlips(owner, brzVehs[veh].networkId, brzVehs[veh].name, pos)
            Citizen.Wait(100)
        end]]
    if brzVehs[veh] ~= nil then
        

        --print(veh)
        --print(NetworkGetNetworkIdFromEntity(veh))
        vCLIENT.syncBlips(owner, brzVehs[veh].networkId, brzVehs[veh].name, brzVehs[veh].state.position)
        TriggerClientEvent('applyMissingVehicleCustomizations', owner, NetworkGetNetworkIdFromEntity(veh), brzVehs[veh].state, true)
        SalvarVeiculo(veh)
    end
    --end)
end

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    if user_id then
        TriggerClientEvent('brz:sendVehicleSpawns', source, spawn)

        for vehid, state in pairs(brzVehs) do
            if state.dono == user_id then
                print(state.name)
                print(json.encode(GetEntityCoords(vehid),{indent = true}))
                vCLIENT.syncBlips(source, state.networkId, state.name, GetEntityCoords(vehid))
            end
        end
    end
    --[[if user_id then
        for k, v in pairs(vehlist) do
            if user_id == v[1] then
                vCLIENT.setBlipsOwner(source, k, v[2])
                Citizen.Wait(10)
            end
        end
    end]]
end)

--[ DELETEVEHICLES ]---------------------------------------------------------------------------------------------------------------------

function src.deleteVehicles()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local vehicle = vRPclient.getNearestVehicle(source, 30)
        if vehicle then
            vCLIENT.deleteVehicle(source, vehicle)
        end
    end
end

--[ VEHPRICE ]---------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("desmancheVehicles")
AddEventHandler("desmancheVehicles", function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
        if vehicle and placa then
            local puser_id = vRP.getUserByPublicPlate(placa)
            if puser_id then
                exports.mongodb:updateOne({
                    collection = "vrp_user_vehicles",
                    query = { user_id = parseInt(puser_id), vehicle = vname },
                    update = { ["$set"] = { detido = 1, time = parseInt(os.time()) } }
                })
                vRP.giveInventoryItem(user_id, "dinheirosujo", parseInt(vRP.vehiclePrice(vname) * 0.1))
                vCLIENT.deleteVehicle(source, vehicle)
                local identity = vRP.getUserIdentity(user_id)
            end
        end
    end
end)

--[ DV ]---------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('dv', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        local vehicle = vRPclient.getNearestVehicle(source, 7)
        if vehicle then

            PerformHttpRequest(logAdminDv, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE DV⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/Wp2QrV7.png"
                        },
                        fields = {
                            {
                                name = "**IDENTIFICAÇÃO:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            }
                        },
                        footer = {
                            text = "Los Anjos RP - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/Wp2QrV7.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vCLIENT.deleteVehicle(source, vehicle)
        end
    end
end)

--[ VEHICLELOCK ]------------------------------------------------------------------------------------------------------------------------

function src.vehicleLock()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
        if vehicle and placa then
            local placa_user_id = vRP.getUserByPublicPlate(placa)
            if user_id == placa_user_id then
                print(vnetid)
                print(lock)
                print(NetworkGetEntityFromNetworkId(vnetid))

                --[[if lock then -- lock
                    brzVehs[NetworkGetEntityFromNetworkId(vnetid)].locked = true
                else -- unlock
                    brzVehs[NetworkGetEntityFromNetworkId(vnetid)].locked = false
                end]]
                vCLIENT.vehicleClientLock(-1, vnetid, lock)
                TriggerClientEvent("vrp_sound:source", source, 'lock', 0.5)
                vRPclient.playAnim(source, true, { "anim@mp_player_intmenu@key_fob@", "fob_click" }, false)
                if lock == 1 then
                    TriggerClientEvent("Notify", source, "importante", "Veículo <b>destrancado</b> com sucesso.", 8000)
                else
                    TriggerClientEvent("Notify", source, "importante", "Veículo <b>trancado</b> com sucesso.", 8000)
                end
            end
        end
    end
end

--[ TRYDELETE ]--------------------------------------------------------------------------------------------------------------------------

function src.tryDelete(vehid)
    local veh = NetworkGetEntityFromNetworkId(vehid)
    if brzVehs[veh] ~= nil and vehid ~= 0 then
        if vehlist[vehid] then
            local user_id = brzVehs[veh].dono
            local vehname = brzVehs[veh].name
            local player = vRP.getUserSource(user_id)

            if player then
                vCLIENT.syncNameDelete(player, vehname)
            end
        end
        SalvarVeiculo(veh, true)
        brzVehs[veh] = nil
        DeleteEntity(veh)
    else
        if vehlist[vehid] then
            local user_id = vehlist[vehid][1]
            local vehname = vehlist[vehid][2]
            local player = vRP.getUserSource(user_id)

            if player then
                vCLIENT.syncNameDelete(player, vehname)
            end
        end
        vCLIENT.syncVehicle(-1, vehid)
    end
end

--[ TRYDELETEVEH ]-----------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("trydeleteveh")
AddEventHandler("trydeleteveh", function(vehid)
    --vCLIENT.syncVehicle(-1, vehid)
    local veh = NetworkGetEntityFromNetworkId(vehid)
    if brzVehs[veh] ~= nil and DoesEntityExist(veh) then
        SalvarVeiculo(veh, true)
        brzVehs[veh] = nil
        DeleteEntity(veh)
    else
        vCLIENT.syncVehicle(-1, vehid)
    end
end)

--[ RETURNHOUSES ]-----------------------------------------------------------------------------------------------------------------------

function src.returnHouses(nome, garage)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRP.searchReturn(source, user_id) then
            local address = vRP.getHomeUserId(parseInt(user_id))
            if #address > 0 then
                for k, v in pairs(address) do
                    if v.home == garages[garage].name then
                        if parseInt(v.garage) == 1 then
                            local resultOwner = vRP.getHomeUserIdOwner(tostring(nome))
                            if resultOwner[1] then
                                if parseInt(os.time()) >= parseInt(resultOwner[1].tax + 24 * 15 * 60 * 60) then
                                    TriggerClientEvent("Notify", source, "aviso", "A <b>Property Tax</b> da residência está atrasada.", 10000)
                                    return false
                                else
                                    vCLIENT.openGarage(source, nome, garage)
                                end
                            end
                        end
                    end
                end
            end
            if garages[garage].perm == "livre" then
                return vCLIENT.openGarage(source, nome, garage)
            elseif garages[garage].perm then
                if vRP.hasPermission(user_id, garages[garage].perm) then
                    return vCLIENT.openGarage(source, nome, garage)
                end
            elseif garages[garage].public then
                return vCLIENT.openGarage(source, nome, garage)
            end
        end
        return false
    end
end

--[ VEHICLE ANCORAR ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand('travar', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "policia.permissao") then
            if vRPclient.isInVehicle(source) then
                local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
                if vehicle then
                    TriggerClientEvent("progress", source, 5000, "travar/destravar")
                    SetTimeout(5000, function()
                        vCLIENT.vehicleAnchor(source, vehicle)
                    end)
                end
            end
        end
    end
end)

--[ BOAT ANCORAR ]-----------------------------------------------------------------------------------------------------------------------

RegisterCommand('ancorar', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRPclient.isInVehicle(source) then
            local vehicle, vnetid, placa, vname, lock, banned = vRPclient.vehList(source, 7)
            if vehicle then
                vCLIENT.boatAnchor(source, vehicle)
            end
        end
    end
end)

--[ POLICEALERT ]------------------------------------------------------------------------------------------------------------------------

function src.policeAlert()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local vehicle, vnetid, placa, vname, lock, banned, trunk, model, street = vRPclient.vehList(source, 7)
        if vehicle then
            if math.random(100) >= 50 then
                local policia = vRP.getUsersByPermission("policia.permissao")
                local x, y, z = vRPclient.getPosition(source)
                for k, v in pairs(policia) do
                    local player = vRP.getUserSource(parseInt(v))
                    if player then
                        async(function()
                            local id = idgens:gen()
                            TriggerClientEvent('chatMessage', player, "911", { 64, 64, 255 }, "Roubo na ^1" .. street .. "^0 do veículo ^1" .. model .. "^0 de placa ^1" .. placa .. "^0 verifique o ocorrido.")
                            police[id] = vRPclient.addBlip(player, x, y, z, 304, 3, "Ocorrência", 0.6, false)
                            SetTimeout(60000, function() vRPclient.removeBlip(player, police[id]) idgens:free(id) end)
                        end)
                    end
                end
            end
        end
    end
end

--[ CAR ]--------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('car', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        local identity = vRP.getUserIdentity(user_id)
        if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
            if args[1] then

                PerformHttpRequest(logAdminCar, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            ------------------------------------------------------------
                            title = "REGISTRO DE SPAWNCAR⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/Wp2QrV7.png"
                            },
                            fields = {
                                {
                                    name = "**COLABORADOR DA EQUIPE:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                },
                                {
                                    name = "**CARRO SPAWNADO: **" .. args[1],
                                    value = "⠀"
                                }
                            },
                            footer = {
                                text = "Los Anjos RP - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = "https://i.imgur.com/Wp2QrV7.png"
                            },
                            color = 15906321
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                TriggerClientEvent('spawnarveiculo', source, args[1])
                TriggerEvent("setPlateEveryone", identity.public_plate)
            end
        end
    end
end)

--[ VEHS ]-------------------------------------------------------------------------------------------------------------------------------

RegisterCommand('vehs', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if args[1] and parseInt(args[2]) > 0 then
            local nplayer = vRP.getUserSource(parseInt(args[2]))
            local myvehicles = vRP.getUserVehicles(parseInt(user_id), tostring(args[1]))
            if myvehicles[1] then
                if vRP.vehicleType(tostring(args[1])) == "exclusive" or vRP.vehicleType(tostring(args[1])) == "rental" and not vRP.hasPermission(user_id, "administrador.permissao") then
                    TriggerClientEvent("Notify", source, "negado", "<b>" .. vRP.vehicleName(tostring(args[1])) .. "</b> não pode ser transferido por ser um veículo <b>Exclusivo ou Alugado</b>.", 10000)
                else
                    local identity = vRP.getUserIdentity(parseInt(args[2]))
                    local identity2 = vRP.getUserIdentity(user_id)
                    local price = tonumber(sanitizeString(vRP.prompt(source, "Valor:", ""), "\"[]{}+=?!_()#@%/\\|,.", false))
                    if vRP.request(source, "Deseja vender um <b>" .. vRP.vehicleName(tostring(args[1])) .. "</b> para <b>" .. identity.name .. " " .. identity.firstname .. "</b> por <b>$" .. vRP.format(parseInt(price)) .. "</b> dólares ?", 30) then
                        if vRP.request(nplayer, "Aceita comprar um <b>" .. vRP.vehicleName(tostring(args[1])) .. "</b> de <b>" .. identity2.name .. " " .. identity2.firstname .. "</b> por <b>$" .. vRP.format(parseInt(price)) .. "</b> dólares ?", 30) then
                            local vehicle = vRP.getUserVehicles(parseInt(args[2]), tostring(args[1]))
                            if parseInt(price) > 0 then
                                if vRP.tryFullPayment(parseInt(args[2]), parseInt(price)) then
                                    if vehicle[1] then
                                        TriggerClientEvent("Notify", source, "negado", "<b>" .. identity.name .. " " .. identity.firstname .. "</b> já possui este modelo de veículo.", 10000)
                                    else
                                        exports.mongodb:updateOne({
                                            collection = "vrp_user_vehicles",
                                            query = { user_id = parseInt(user_id), vehicle = tostring(args[1]) },
                                            update = { ["$set"] = { user_id = parseInt(args[2]) } }
                                        })

                                        local custom = vRP.getSData("custom:u" .. parseInt(user_id) .. "veh_" .. tostring(args[1]))
                                        local custom2 = json.decode(custom)
                                        if custom2 then
                                            vRP.setSData("custom:u" .. parseInt(args[2]) .. "veh_" .. tostring(args[1]), json.encode(custom2))
                                            exports.mongodb:deleteOne({ collection = "brz_srv_data", query = { dkey = "custom:u" .. parseInt(user_id) .. "veh_" .. tostring(args[1]) } })
                                        end

                                        local chest = vRP.getSData("chest:u" .. parseInt(user_id) .. "veh_" .. tostring(args[1]))
                                        local chest2 = json.decode(chest)
                                        if chest2 then
                                            vRP.setSData("chest:u" .. parseInt(args[2]) .. "veh_" .. tostring(args[1]), json.encode(chest2))
                                            exports.mongodb:deleteOne({ collection = "brz_srv_data", query = { dkey = "chest:u" .. parseInt(user_id) .. "veh_" .. tostring(args[1]) } })
                                        end

                                        TriggerClientEvent("Notify", source, "sucesso", "Você Vendeu <b>" .. vRP.vehicleName(tostring(args[1])) .. "</b> e Recebeu <b>$" .. vRP.format(parseInt(price)) .. "</b> dólares.", 20000)
                                        TriggerClientEvent("Notify", nplayer, "importante", "Você recebeu as chaves do veículo <b>" .. vRP.vehicleName(tostring(args[1])) .. "</b> de <b>" .. identity2.name .. " " .. identity2.firstname .. "</b> e pagou <b>$" .. vRP.format(parseInt(price)) .. "</b> dólares.", 40000)
                                        vRPclient.playSound(source, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
                                        vRPclient.playSound(nplayer, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
                                        local consulta = vRP.getUData(user_id, "vRP:paypal")
                                        local resultado = json.decode(consulta) or 0
                                        vRP.setUData(user_id, "vRP:paypal", json.encode(parseInt(resultado + price)))
                                        SendWebhookMessage(webhookvehs, "```prolog\n[ID]: " .. user_id .. " " .. identity2.name .. " " .. identity2.firstname .. " \n[VENDEU]: " .. vRP.vehicleName(tostring(args[1])) .. " \n[PARA]: " .. (args[2]) .. " " .. identity.name .. " " .. identity.firstname .. " \n[VALOR]: $" .. vRP.format(parseInt(price)) .. " " .. os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. " \r```")
                                    end
                                else
                                    TriggerClientEvent("Notify", nplayer, "negado", "Dinheiro insuficiente.", 8000)
                                    TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.", 8000)
                                end
                            end
                        end
                    end
                end
            end
        else
            local vehicle = vRP.getUserVehicle(parseInt(user_id))
            if #vehicle > 0 then
                local car_names = {}
                for k, v in pairs(vehicle) do
                    table.insert(car_names, "<b>" .. vRP.vehicleName(v.vehicle) .. "</b> (" .. v.vehicle .. ")")
                    --TriggerClientEvent("Notify",source,"importante","<b>Modelo:</b> "..v.vehicle,10000)
                end
                car_names = table.concat(car_names, ", ")
                TriggerClientEvent("Notify", source, "importante", "Seus veículos: " .. car_names, 20000)
            else
                TriggerClientEvent("Notify", source, "importante", "Você não possui nenhum veículo.", 20000)
            end
        end
    end
end)

--[ LIMPAR ]-----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("trylimpar")
AddEventHandler("trylimpar", function(nveh)
    TriggerClientEvent("synclimpar", -1, nveh)
end)

--[ REPARAR ]----------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("tryreparar")
AddEventHandler("tryreparar", function(nveh)
    TriggerClientEvent("syncreparar", -1, nveh)
end)

--[ MOTOR ]------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("trymotor")
AddEventHandler("trymotor", function(nveh)
    TriggerClientEvent("syncmotor", -1, nveh)
end)

--[ SAVELIVERY ]-------------------------------------------------------------------------------------------------------------------------

RegisterCommand('savelivery', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
        local vehicle, vnetid, placa, vname = vRPclient.vehList(source, 7)
        if vehicle and placa then
            local puser_id = vRP.getUserByPublicPlate(placa)
            if puser_id then
                local custom = json.decode(vRP.getSData("custom:u" .. parseInt(puser_id) .. "veh_" .. vname))
                local livery = vCLIENT.returnlivery(source, livery)
                custom.liveries = livery
                print(json.encode(custom))
                vRP.setSData("custom:u" .. parseInt(puser_id) .. "veh_" .. vname, json.encode(custom))
            end
        end
    end
end)

--[ CHECK LIVERY PERMISSION ]------------------------------------------------------------------------------------------------------------

function src.CheckLiveryPermission()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, "manager.permissao")
end
