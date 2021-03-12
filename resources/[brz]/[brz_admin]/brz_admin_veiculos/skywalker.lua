local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterCommand("criarveiculo", function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    print("criarveiculo1")

    if vRP.hasPermission(user_id, "administrador.permissao") then
        print("criarveiculo2")

        TriggerClientEvent("Notify",source,"sucesso","Criando veículo.",8000)
        TriggerClientEvent("brzNui:MudarPagina", source, "admin/criar-veiculo", { })
    end
end)
