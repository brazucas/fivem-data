RegisterServerEvent("brzNui:mudar-pagina")
AddEventHandler("brzNui:mudar-pagina", function(pagina, params)
    print("brzNui:mudar-pagina Comando recebido " .. pagina)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    TriggerClientEvent("brzNui:SetDisplay", true)
end)
