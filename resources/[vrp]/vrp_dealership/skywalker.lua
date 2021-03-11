local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("vrp_dealership", src)
vCLIENT = Tunnel.getInterface("vrp_dealership")

--[ VARIAVEIS ]--------------------------------------------------------------------------------------------------------------------------

local motos = {}
local carros = {}
local import = {}

--[ SYSTEM ]-----------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    for k, v in pairs(vRP.vehicleGlobal()) do
        if v.tipo == "carros" then
            local vehicle = vRP.getEstoque(k)
            if vehicle[1] ~= nil then
                table.insert(carros, { k = k, nome = v.name, price = v.price, chest = v.mala, stock = parseInt(vehicle[1].quantidade) })
            end
        end
        if v.tipo == "motos" then
            local vehicle = vRP.getEstoque(k)
            if vehicle[1] ~= nil then
                table.insert(motos, { k = k, nome = v.name, price = v.price, chest = v.mala, stock = parseInt(vehicle[1].quantidade) })
            end
        end
        if v.tipo == "import" then
            local vehicle = vRP.getEstoque(k)
            if vehicle[1] ~= nil then
                table.insert(import, { k = k, nome = v.name, price = v.price, chest = v.mala, stock = parseInt(vehicle[1].quantidade) })
            end
        end
    end
end)

--[ UPDATEVEHICLES ]---------------------------------------------------------------------------------------------------------------------

function src.updateVehicles(vname, vehtype)
    if vehtype == "carros" then
        for k, v in pairs(carros) do
            if v.k == vname then
                table.remove(carros, k)
                local vehicle = vRP.getEstoque(vname)
                if vehicle[1] ~= nil then
                    table.insert(carros, { k = vname, nome = vRP.vehicleName(vname), price = (vRP.vehiclePrice(vname)), chest = (vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
                end
            end
        end
    elseif vehtype == "motos" then
        for k, v in pairs(motos) do
            if v.k == vname then
                table.remove(motos, k)
                local vehicle = vRP.getEstoque(vname)
                if vehicle[1] ~= nil then
                    table.insert(motos, { k = vname, nome = vRP.vehicleName(vname), price = (vRP.vehiclePrice(vname)), chest = (vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
                end
            end
        end
    elseif vehtype == "import" then
        for k, v in pairs(import) do
            if v.k == vname then
                table.remove(import, k)
                local vehicle = vRP.getEstoque(vname)
                if vehicle[1] ~= nil then
                    table.insert(import, { k = vname, nome = vRP.vehicleName(vname), price = vRP.vehiclePrice(vname), chest = (vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
                end
            end
        end
    end
end

--[ CARROS ]-----------------------------------------------------------------------------------------------------------------------------

function src.Carros()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        return carros
    end
end

--[ MOTOS ]------------------------------------------------------------------------------------------------------------------------------

function src.Motos()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        return motos
    end
end

--[ IMPORT ]-----------------------------------------------------------------------------------------------------------------------------

function src.Import()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        return import
    end
end

--[ FUNÇÕES ]---------------------------------------

function vRP.getConMaxVehs(user_id)
    local p = promise.new()
    exports.mongodb:count({ collection = "vrp_user_vehicles", query = { user_id = user_id } }, function(success, count)
        if success then
            p:resolve(count)
        else
            p:reject("[vRP.getUserAddress] ERROR ")
            return
        end
    end)

    local count = Citizen.Await(p)

    return count
end

--[ BUYDEALER ]--------------------------------------------------------------------------------------------------------------------------

function src.buyDealer(name)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local maxvehs = vRP.getConMaxVehs(parseInt(user_id))
        local maxgars = vRP.getUsers(parseInt(user_id))
        local vehicle = vRP.getUserVehicles(parseInt(user_id), name)

        if vRP.hasPermission(user_id, "ultimate.permissao") then
            if parseInt(maxvehs) >= parseInt(maxgars[1].garagem) + 15 then
                TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
                return
            end
        elseif vRP.hasPermission(user_id, "platinum.permissao") then
            if parseInt(maxvehs) >= parseInt(maxgars[1].garagem) + 10 then
                TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
                return
            end
        elseif vRP.hasPermission(user_id, "gold.permissao") then
            if parseInt(maxvehs) >= parseInt(maxgars[1].garagem) + 5 then
                TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
                return
            end
        elseif vRP.hasPermission(user_id, "standard.permissao") then
            if parseInt(maxvehs) >= parseInt(maxgars[1].garagem) + 3 then
                TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
                return
            end
        else
            if parseInt(maxvehs) >= parseInt(maxgars[1].garagem) + 1 then
                TriggerClientEvent("Notify", source, "importante", "Atingiu o número máximo de veículos em sua garagem.", 8000)
                return
            end
        end

        if vehicle[1] then
            TriggerClientEvent("Notify", source, "importante", "Você já possui um <b>" .. vRP.vehicleName(name) .. "</b> em sua garagem.", 10000)
            return
        else
            local rows2 = vRP.getEstoque(name)
            if parseInt(rows2[1].quantidade) <= 0 then
                TriggerClientEvent("Notify", source, "aviso", "Estoque de <b>" .. vRP.vehicleName(name) .. "</b> indisponível.", 8000)
                return
            end

            local preco = vRP.vehiclePrice(name)

            if preco then
                if vRP.hasPermission(user_id, "ultimate.permissao") then
                    desconto = math.floor(preco * 20 / 100)
                    pagamento = math.floor(preco - desconto)
                elseif vRP.hasPermission(user_id, "platinum.permissao") then
                    desconto = math.floor(preco * 15 / 100)
                    pagamento = math.floor(preco - desconto)
                elseif vRP.hasPermission(user_id, "gold.permissao") then
                    desconto = math.floor(preco * 10 / 100)
                    pagamento = math.floor(preco - desconto)
                elseif vRP.hasPermission(user_id, "standard.permissao") then
                    desconto = math.floor(preco * 5 / 100)
                    pagamento = math.floor(preco - desconto)
                else
                    pagamento = math.floor(preco)
                end
            end

            if vRP.tryPayment(user_id, parseInt(pagamento)) then
                local p = promise.new()
                exports.mongodb:updateOne({
                    collection = "vrp_estoque",
                    query = { vehicle = name },
                    update = { ["$set"] = { quantidade = parseInt(rows2[1].quantidade) - 1, } }
                }, function(success, result)
                    if success then
                        p:resolve()
                    else
                        p:reject("[MongoDB] ERROR " .. tostring(result))
                    end
                end)
                Citizen.Await(p)

                local p = promise.new()
                exports.mongodb:insertOne({
                    collection = "vrp_user_vehicles",
                    document = {
                        user_id = parseInt(user_id),
                        vehicle = name,
                        ipva = os.time()
                    }
                }, function(success, result, insertedIds)
                    if success then
                        p:resolve(insertedIds[1])
                    else
                        p:reject("[MongoDB] ERROR " .. tostring(result))
                    end
                end)
                Citizen.Await(p)

                TriggerClientEvent("Notify", source, "sucesso", "Você comprou um <b>" .. vRP.vehicleName(name) .. "</b> por <b>$ " .. vRP.format(parseInt(pagamento)) .. " dólares</b>. <b>( Dinheiro )</b>", 10000)
                src.updateVehicles(name, vRP.vehicleType(name))
                if vRP.vehicleType(name) == "carros" then
                    TriggerClientEvent('dealership:Update', source, 'updateCarros')
                elseif vRP.vehicleType(name) == "motos" then
                    TriggerClientEvent('dealership:Update', source, 'updateMotos')
                elseif vRP.vehicleType(name) == "import" then
                    TriggerClientEvent('dealership:Update', source, 'updateImport')
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Dinheiro insuficiente.")
            end
        end
    end
end

--[ SELLDEALER ]-------------------------------------------------------------------------------------------------------------------------

function src.sellDealer(name)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local vehicle = vRP.getUserVehicles(parseInt(user_id), name)
        local rows2 = vRP.getEstoque(name)
        if vehicle[1] then
            exports.mongodb:deleteOne({ collection = "vrp_user_vehicles", query = { user_id = parseInt(user_id), vehicle = name } })
            exports.mongodb:deleteOne({ collection = "vrp_srv_data", query = { dkey = "custom:u" .. parseInt(user_id) .. "veh_" .. name } })
            exports.mongodb:deleteOne({ collection = "vrp_srv_data", query = { dkey = "chest:u" .. parseInt(user_id) .. "veh_" .. name } })

            local p = promise.new()
            exports.mongodb:updateOne({
                collection = "vrp_estoque",
                query = { vehicle = name },
                update = { ["$set"] = { quantidade = parseInt(rows2[1].quantidade) + 1 } }
            }, function(success, result)
                if success then
                    p:resolve()
                else
                    p:reject("[MongoDB] ERROR " .. tostring(result))
                end
            end)
            Citizen.Await(p)

            vRP.giveBankMoney(user_id, parseInt(vRP.vehiclePrice(name) * 0.75))
            TriggerClientEvent("Notify", source, "sucesso", "Você vendeu um <b>" .. vRP.vehicleName(name) .. "</b> por <b>$" .. vRP.format(parseInt(vRP.vehiclePrice(name) * 0.75)) .. " dólares</b>.", 10000)
            src.updateVehicles(name, vRP.vehicleType(name))
            TriggerClientEvent('dealership:Update', source, 'updatePossuidos')
        end
    end
end

function src.permissao()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, "concessionaria.permissao")
end
