local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local display = false

RegisterCommand("nui", function(source, args)
    SetDisplay(not display)
end)

--very important cb
RegisterNUICallback("Fechar", function(data)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        event = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        SetDisplay(false)
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[
            inputGroup -- integer ,
	        control --integer ,
            disable -- boolean
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

RegisterNetEvent("brzNui:MudarPagina")
AddEventHandler("brzNui:MudarPagina", function(pagina, params)
    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    SetDisplay(true)
end)
