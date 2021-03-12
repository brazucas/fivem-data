local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("brzNui:mudar-pagina")
AddEventHandler("brzNui:mudar-pagina", function(pagina, params)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    TriggerClientEvent("brzNui:SetDisplay", true)
end)
