RegisterNUICallback("CriarVeiculo", function(data, cb)
    TriggerServerEvent("brzAdminVeiculos:CriarVeiculo", json.encode(data))

    cb()
end)
