RegisterNUICallback("CriarVeiculo", function(data, cb)
    -- Criar veículo

    TriggerServerEvent("brzAdminVeiculos:CriarVeiculo", json.encode(data))

    cb(true)
end)
