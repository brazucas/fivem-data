RegisterServerEvent("brzNui:mudar-pagina")
AddEventHandler("brzNui:mudar-pagina", function(pagina, params)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    TriggerClientEvent("brzNui:SetDisplay", true)
end)
