local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

function vRP.brzNuiMudarPagina(pagina, params)
    print("brzNui:mudarPagina Comando recebido " .. pagina)
    local source = source

    SendNUIMessage({ event = 'acessar', pagina = pagina, params = params })
    TriggerClientEvent("brzNui:SetDisplay", true)
end
