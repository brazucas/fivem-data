local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("org_criminosas",src)

orgSERVER = Tunnel.getInterface("org_criminosas")

--[ VARIÁVEIS ]--------------------------------------------------------------------------------------------------------------------------

--[ NUI ORGS ]--------------------------------------------------------------------------------------------------------------------------
local menuEnabled = false
function src.ToggleActionMenu(org, valores)
	menuEnabled = not menuEnabled
	if menuEnabled then
		if org then
			StartScreenEffect("MenuMGSelectionIn", 0, true)
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showOrgMenu", nomeORG = org, valoresORG = valores})
		else
			StartScreenEffect("MenuMGSelectionIn", 0, true)
			SetNuiFocus(true,true)
			SendNUIMessage({ action = "showCriarOrgMenu" })
		end
	else
		SetNuiFocus(false,false)
		SendNUIMessage({ action = "hideMenu" })
		StopScreenEffect("MenuMGSelectionIn")
		menuEnabled = false
	end
end

function src.atualizarDataOrgUI(org, valores)
	if menuEnabled then
		SendNUIMessage({ nomeORG = org, valoresORG = valores })
	end
end

RegisterNUICallback('org_criarorg', function(data)
	local criou = orgSERVER.CriarOrganizacao(data.nomeORG, data.valoresORG)
	if criou then
		SendNUIMessage({ action = "showOrgMenu" })
	end
end)

RegisterNUICallback('org:addmembro', function(data)
	orgSERVER.AdicionarMembro(data.nomeORG, data.membro_id, data.cargoORG)
end)

RegisterNUICallback('org:remmembro', function(data)
	orgSERVER.RemoverMembro(data.nomeORG, data.membro_id)
end)

RegisterNUICallback('org:criarcargo', function(data)
	orgSERVER.CriarCargo(data.nomeORG, data.cargoORG)
end)

RegisterNUICallback('org:removercargo', function(data)
	orgSERVER.RemoverCargo(data.nomeORG, data.cargoORG)
end)

RegisterNUICallback('org:editarcargo', function(data)
	orgSERVER.EditarCargo(data.nomeORG, data.membro_id, data.cargoORG, data.cargoValores)
end)

RegisterNUICallback('org:alterarcargo', function(data)
	orgSERVER.AlterarCargoMembro(data.nomeORG, data.membro_id, data.cargoORG)
end)

RegisterNUICallback('org:transfbanco', function(data)
	orgSERVER.TransacaoBancoOrg(data.nomeORG, data.valor, data.tipo)
end)

RegisterNUICallback('org:recebercargos', function(data)
	orgSERVER.enviarCargosOrgUI(data.nomeORG)
end)

RegisterNUICallback('NUIFocusOff', function()
	menuEnabled = false
	SetNuiFocus(false, false)
	StopScreenEffect("MenuMGSelectionIn")
	SendNUIMessage({type = 'hideMenu'})
end)