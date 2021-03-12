local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("brzAdminVeiculos:acessar")
AddEventHandler("brzAdminVeiculos:acessar",function()
    TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
end)

RegisterCommand("criarveiculo", function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    print("criarveiculo1")

    if vRP.hasPermission(user_id, "administrador.permissao") then
        print("criarveiculo2")
        TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
    end
end)
