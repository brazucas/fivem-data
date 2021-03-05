local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("nav_ponto-mecanico",emP)

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------

local taxiPonto = ""

--[ PONTO ]------------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("entrar-servico-mecanico")
AddEventHandler("entrar-servico-mecanico",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"mecanico.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está em serviço.")
    else
        vRP.addUserGroup(user_id,"mecanico")
        TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
    end
end)

RegisterServerEvent("sair-servico-mecanico")
AddEventHandler("sair-servico-mecanico",function()
    local user_id = vRP.getUserId(source)

    if vRP.hasPermission(user_id,"paisana-mecanico.permissao") then
        TriggerClientEvent("Notify",source,"negado","Você já está fora de serviço.")
    else
        vRP.addUserGroup(user_id,"paisana-mecanico")
        TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
    end
end)