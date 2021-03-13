local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

autocompletes = {}

RegisterNUICallback("AutocompleteJogadores", function(texto, cb)
    if #texto < 1 then
        cb({})
    else
        autocompletes = {}

        TriggerServerEvent("brzMisc:AutocompleteJogadores", texto)

        local threadTime = 0
        local increment = 300
        Citizen.CreateThread(function()
            while threadTime < 5000 and #autocompletes == 0 do -- esperar por 5 segundos
                Citizen.Wait(increment)
                threadTime = threadTime + increment
            end

            cb(autocompletes)
        end)
    end
end)

RegisterNetEvent("brzMisc:AutocompleteJogadores")
AddEventHandler("brzMisc:AutocompleteJogadores", function(results)
    autocompletes = json.decode(results)
end)
