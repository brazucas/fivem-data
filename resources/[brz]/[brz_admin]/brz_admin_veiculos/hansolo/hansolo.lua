RegisterNUICallback("CriarVeiculo", function(data, cb)
    TriggerServerEvent("brzAdminVeiculos:CriarVeiculo", json.encode(data.data), data.user_id)

    cb('ok')
end)

RegisterNetEvent("BrzSpawnVeiculo")
AddEventHandler("BrzSpawnVeiculo", function(brzVeiculoId, params)
    print("debug1 " .. params.modelo)
    local mhash = GetHashKey(params.modelo)
    while not HasModelLoaded(mhash) do
        RequestModel(mhash)
        Citizen.Wait(10)
    end
    print("debug2")
    if HasModelLoaded(mhash) then
        print("debug3")
        local ped = PlayerPedId()
        local nveh = CreateVehicle(mhash, GetEntityCoords(ped),GetEntityHeading(ped), true, false)
        print("debug4")
        NetworkRegisterEntityAsNetworked(nveh)
        while not NetworkGetEntityIsNetworked(nveh) do
            NetworkRegisterEntityAsNetworked(nveh)
            Citizen.Wait(1)
        end
        print("debug5")
        SetVehicleDoorsLocked(nveh, params.tracado) -- params.trancado
        SetVehicleEngineOn(nveh, params.motor, true, false) -- params.motor
        SetVehicleColours(nveh, params.corPrimaria, params.corSecundaria)

        SetVehicleOnGroundProperly(nveh)
        SetVehicleAsNoLongerNeeded(nveh)
        SetVehicleIsStolen(nveh, false)
        SetPedIntoVehicle(ped, nveh, -1)
        SetVehicleNeedsToBeHotwired(nveh, false)
        SetEntityInvincible(nveh, false)
        SetVehicleNumberPlateText(nveh, params.placa) -- params.placa
        Citizen.InvokeNative(0xAD738C3085FE7E11, nveh, true, true)
        SetVehicleHasBeenOwnedByPlayer(nveh, params.aVenda)
        SetVehRadioStation(nveh, "OFF")

        SetModelAsNoLongerNeeded(mhash)
        print("debug6")
    end
end)
