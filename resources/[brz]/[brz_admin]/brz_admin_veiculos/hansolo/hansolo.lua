RegisterNUICallback("CriarVeiculo", function(data)
    -- Criar veículo

    print("[brzAdminVeiculos:criar] " .. tostring(data))
end)

RegisterNetEvent("MudarPagina")
AddEventHandler("MudarPagina", function(pagina, params)
    print("MudarPagina Comando recebido22 " .. pagina)

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    SetDisplay(true)
end)
