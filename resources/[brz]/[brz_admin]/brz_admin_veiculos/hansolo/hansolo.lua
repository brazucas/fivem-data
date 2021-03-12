RegisterNUICallback("CriarVeiculo", function(data)
    -- Criar veículo

    print("[brzAdminVeiculos:criar] " .. tostring(data))
end)

RegisterNetEvent("brzNui:MudarPagina")
AddEventHandler("brzNui:MudarPagina", function(pagina, params)
    print("brzNui:MudarPagina Comando recebido22 " .. pagina)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    SetDisplay(true)
end)
