RegisterServerEvent("brzNui:mudarPagina")
AddEventHandler("brzNui:mudarPagina", function(pagina, params)
    print("brzNui:mudarPagina Comando recebido " .. pagina)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    TriggerClientEvent("brzNui:SetDisplay", true)
end)
