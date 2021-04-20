local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP")
Passos = Tunnel.getInterface("vrp_interacao")
vRPmenu_ = {}
Tunnel.bindInterface("vrp_interacao", vRPmenu_)
Proxy.addInterface("vrp_interacao", vRPmenu_)
-- Criado por [Discord: Passos#3717]
--=============================================================================================--
-- Executar Comando
--=============================================================================================--

function vRPmenu_.ExecuteCommand(comando) 
    return ExecuteCommand(comando) 
end

--=============================================================================================--
-- Cancelar Animacoes
--=============================================================================================--

function vRPmenu_.cancelAnimations()
    local ped = PlayerPedId()
    if not IsEntityDead(ped) then
        vRP.DeletarObjeto()
        ClearPedTasks(ped)
    end
end

--=============================================================================================--
-- Notificacao
--=============================================================================================--

function vRPmenu_.notify(texto)
    SetNotificationTextEntry("STRING")
	AddTextComponentString(texto)
    DrawNotification(true, false)
end

--=============================================================================================--
-- Abrir Menu
--=============================================================================================--

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(1)  
        if IsControlJustPressed(0, 311) then 
            Passos.menuInteracao() 
        end 
    end 
end)
