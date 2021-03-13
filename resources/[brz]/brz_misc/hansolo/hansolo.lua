local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local dadosEventos = {}

RegisterNUICallback("AutocompleteJogadores", function(body, cb)
    if #body.data < 1 then
        cb({})
    else
        TriggerServerEvent("brzMisc:AutocompleteJogadores", body.eventId, body.data)
        esperarEvento(body.eventId, cb)
    end
end)

RegisterNetEvent("brzMisc:AutocompleteJogadores")
AddEventHandler("brzMisc:AutocompleteJogadores", function(eventId, results)
    dadosEventos[eventId] = json.decode(results)
end)

function esperarEvento(eventId, cb)
    local threadTime = 0
    local increment = 300
    Citizen.CreateThread(function()
        while threadTime < 5000 and dadosEventos[eventId] == nil do -- esperar por 5 segundos
            Citizen.Wait(increment)
            threadTime = threadTime + increment
        end

        cb(dadosEventos[eventId])
    end)
end
