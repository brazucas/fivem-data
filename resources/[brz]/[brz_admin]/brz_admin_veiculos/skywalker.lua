RegisterServerEvent("brzAdminVeiculos:acessar")
AddEventHandler("brzAdminVeiculos:acessar",function()
    TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
end)

RegisterCommand("criarveiculo", function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") then
        TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
    end
end)
