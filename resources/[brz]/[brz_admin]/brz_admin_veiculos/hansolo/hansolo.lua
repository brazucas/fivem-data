RegisterNUICallback("CriarVeiculo", function(data)
    -- Criar veículo

    print("[brzAdminVeiculos:criar] " .. tostring(data))
end)

RegisterCommand("criarveiculo", function(source, args)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") then
        TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
    end
end)
