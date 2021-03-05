local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONEXÃO ]---------------------------------------------------------------------------------------

misc = Tunnel.getInterface("vrp_misc")

--[ DISCORD ]---------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        SetDiscordAppId(751201781605990400)

	    local players = misc.discord()
		
	    SetDiscordRichPresenceAsset('brz')
		SetDiscordRichPresenceAssetText('vRPex BRZ V2')
	    SetRichPresence('')
		Citizen.Wait(10000)
	end
end)