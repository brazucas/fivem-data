local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterCommand("criarveiculo", function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    print("criarveiculo1")

    if vRP.hasPermission(user_id, "administrador.permissao") then
        print("criarveiculo2 " .. user_id)

        TriggerClientEvent("Notify", source, "sucesso", "Criando veículo.", 8000)
        TriggerClientEvent("brzNui:MudarPagina", source, "admin/criar-veiculo", {}, user_id)
    end
end)

RegisterServerEvent("brzAdminVeiculos:CriarVeiculo")
AddEventHandler("brzAdminVeiculos:CriarVeiculo", function(paramsStr, user_id)
    local params = json.decode(paramsStr)

    print("[Criar Veículo] Solicitação recebida: " .. tostring(params))

    if not vRP.hasPermission(user_id, "administrador.permissao") then
        print("O jogador " .. user_id .. " não possui permissão para criar veículos")
        return
    end

    --    {
    --        "modelo":"adder",
    --        "corPrimaria":"123123",
    --        "corSecundaria":"123123",
    --        "placa":"JIS6612",
    --        "proprietario":"60496cce047a3a22c089b2a3",
    --        "trancado":"true",
    --        "motor":false,
    --        "transparencia":100,
    --        "tamanho":"1",
    --        "valorOriginal":"100",
    --        "valorVenda":"100",
    --        "aVenda":true
    --    }

    local ped = GetPlayerPed(vRP.getUserSource(user_id))

    params["coords"] = GetEntityCoords(ped)
    params["heading"] = GetEntityHeading(ped)

    local p = promise.new()
    exports.mongodb:insertOne({
        collection = "brz_veiculos",
        document = params
    }, function(success, result, insertedIds)
        if success then
            p:resolve(insertedIds[1])
        else
            p:reject("[MongoDB] ERROR " .. tostring(result))
        end
    end)
    local brzVeiculoId = Citizen.Await(p)

    print("vRP.rusers[user_id] " .. user_id)

    local source = vRP.getUserSource(user_id)

    if brzVeiculoId then
        TriggerClientEvent('BrzSpawnVeiculo', source, brzVeiculoId, params)
    else
        TriggerClientEvent("Notify", source, "Oops!", "Um erro ocorreu ao tentar salvar o veículo")
    end
end)
