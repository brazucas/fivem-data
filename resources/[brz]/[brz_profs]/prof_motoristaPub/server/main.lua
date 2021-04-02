local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

motoristaPub = {}
Tunnel.bindInterface("prof_motoristaPub",motoristaPub)

RegisterNetEvent('blarglebus:finishRoute')
AddEventHandler('blarglebus:finishRoute', function(amount)
    motoristaPub.payment(amount)
end)

RegisterNetEvent('blarglebus:passengersLoaded')
AddEventHandler('blarglebus:passengersLoaded', function(amount)
    motoristaPub.payment(amount)
end)

--[[RegisterNetEvent('blarglebus:abortRoute')
AddEventHandler('blarglebus:abortRoute', function(amount)
    updateMoney(source, function(player) player.removeMoney(amount) end)
end)]]

--[[function updateMoney(_source, updateMoneyCallback)
    local player = ESX.GetPlayerFromId(_source)
    
    if player.job.name ~= 'busdriver' then
        print(_('exploit_attempted_log_message', player.identifier))
        player.kick(_U('exploit_attempted_kick_message'))
        return
    end

    updateMoneyCallback(player)
end]]
--[ FUNCTION ]------------------------------------------------------------------------------------------------------------------

function motoristaPub.payment(amount)
	local source = source
	local user_id = vRP.getUserId(source)
	local base = amount
	local payment = base
	
	if user_id then
		vRP.giveDinheirama(user_id,payment)
		TriggerClientEvent("Notify",source,"sucesso","Ganhos: <b>R$"..base.."</b>.",2000)
	end
end
