RegisterServerEvent("brzAdminVeiculos:acessar")
AddEventHandler("brzAdminVeiculos:acessar",function()
    TriggerServerEvent('brzNui:mudar-pagina', 'admin/criar-veiculo', nil)
end)
