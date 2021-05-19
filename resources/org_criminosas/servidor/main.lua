local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
--local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]----------------------------------------------------------------------------------------------------------------------------

src = {}
Tunnel.bindInterface("org_criminosas", src)
orgCLIENT = Tunnel.getInterface("org_criminosas")

local org_tables = ConfigORG.org_tables_init
local orgMembro = ConfigORG.org_membros_init
local orgFundador = ConfigORG.org_fundador_init

--[ FUNÇÕES ]---------------------------------------
function DebugMsg(message)
    if ConfigORG.debug then
        print('[DEBUG ORGANIZAÇÕES]: ' .. message)
    end
end

function SetOData(nomeORG,valoresORG)
	vRP.execute("vRP/set_orgs_data",{ key = nomeORG, value = valoresORG })
end

function GetOData(nomeORG, cbr)
	local rows = vRP.query("vRP/get_orgs_data",{ key = nomeORG })
	if #rows > 0 then
		return rows[1].valoresORG
	else
		return ""
	end
end

function src.ListaJogadoresSemOrg(src)
    local source = source
    if src then source = src end
    local users = vRP.getUsers()
    local semorg = {}
    for k, v in pairs(users) do
        local id = tostring(k)
        if not EhMembroDeAlgumaOrganizacao(id) and not EhFundadorDeAlgumaOrganizacao(id) then
            DebugMsg('ID ' .. id .. ' está sem organização!')
            table.insert(semorg, #semorg+1, id)
        end
    end
    return semorg
end

function src.ListaJogadoresDaOrg(nomeORG, src)
    local source = source
    if src then source = src end
    local naorg = {}
    for k, v in pairs(orgMembro) do
        local id = tostring(k)
        if orgMembro[id] == nomeORG then
            DebugMsg('ID ' .. id .. ' faz parte da organização ' .. orgMembro[id])
            table.insert(naorg, #naorg+1, id)
        end
    end
    return naorg
end

function src.CriarOrganizacao(nome, valoresORG, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    if not VerificarOrganizacaoExiste(nome) then
        if not valoresORG then
            valoresORG = {
                fundador = user_id,
                banco = 0,
                membros = {},
                cargos = {},
                convites = {}
            }
        end
        DebugMsg('SUCESSO: Organização ' .. nome .. ' criada!')
        print(json.encode(valoresORG,{indent = true}))
        orgFundador[valoresORG.fundador] = nome
        org_tables[nome] = valoresORG
        src.CriarCargo(nome, "Sem Cargo")

        orgCLIENT.atualizarDataOrgUI(source, nome, org_tables[nome])
        return true
    end
    return false
end

function VerificarOrganizacaoExiste(nome)
    for nomeORG, valoresORG in pairs(org_tables) do
        if string.lower(nomeORG) == string.lower(nome) then
            DebugMsg('ERRO: O nome da organização '.. nome ..' já está em uso!')
            return true
        end
    end
    return false
end

function ReceberOrganizacao(nome)
    if org_tables[nome] then
        return org_tables[nome]
    else
        DebugMsg('ERRO: Organização com nome ' .. nome .. ' não encontrada!')
        return nil
    end
end

function EhMembroDaOrganizacao(nomeORG, membro_id)
    local identity = vRP.getUserIdentity(membro_id)
    if not org_tables[nomeORG].membros[membro_id] then
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' não faz parte da organização ' .. nomeORG)
        return false
    else
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' faz parte da organização ' .. nomeORG)
        return true
    end
end

function EhMembroDeAlgumaOrganizacao(membro_id)
    local identity = vRP.getUserIdentity(membro_id)
    if not orgMembro[membro_id] then
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' não faz parte de alguma organização')
        return false
    else
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' faz parte da organização ' .. orgMembro[membro_id])
        return orgMembro[membro_id]
    end
end

function EhFundadorDaOrganizacao(nomeORG, user_id)
    local identity = vRP.getUserIdentity(user_id)
    if org_tables[nomeORG].fundador ~= user_id then
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' não é fundador da organização ' .. nomeORG)
        return false
    else
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' é fundador da organização ' .. nomeORG)
        return true
    end
end

function EhFundadorDeAlgumaOrganizacao(user_id)
    local identity = vRP.getUserIdentity(user_id)
    if not orgFundador[user_id] then
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' não é fundador de alguma organização')
        return false
    else
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' é fundador da organização ' .. orgFundador[user_id])
        return orgFundador[user_id]
    end
end

function VerificarConviteExiste(nomeORG, convidado_id)
    local identity = vRP.getUserIdentity(convidado_id)
    if org_tables[nomeORG].convites[convidado_id] then
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' tem convite para a organização ' .. nomeORG)
        return true
    else
        DebugMsg('O cidadão com passaporte ' .. identity.registration .. ' não tem convite para a organização ' .. nomeORG)
        return false
    end
end

function src.ConvitesDeOrganizacoes(user_id)
    local orgs = {}
    for nomeORG, valoresORG in pairs(org_tables) do
        if valoresORG.convites[user_id] then
            table.insert(orgs, #orgs+1, nomeORG)
        end
    end
    return orgs
end

function src.ConvidarMembro(nomeORG, user_id, src)
    local source = source
    if src then source = src end
    local membroPerm = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if org_tables[nomeORG] and identity then
        if EhFundadorDaOrganizacao(nomeORG, membroPerm) then
            if not EhMembroDaOrganizacao(nomeORG, user_id) then
                if not VerificarConviteExiste(nomeORG, user_id) then
                    org_tables[nomeORG].convites[user_id] = true
                    SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                    DebugMsg('SUCESSO: O cidadão com passaporte ' .. identity.registration .. ' foi convidado para a organização ' .. nomeORG)
                end
            else
                DebugMsg('ERRO: O cidadão com passaporte ' .. identity.registration .. ' já faz parte da organização ' .. nomeORG)
            end
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.AceitarConvite(nomeORG, user_id)
    local identity = vRP.getUserIdentity(user_id)
    if org_tables[nomeORG] and identity then
        if not EhMembroDeAlgumaOrganizacao(user_id) then
            if VerificarConviteExiste(nomeORG, user_id) then
                org_tables[nomeORG].convites[user_id] = nil
                src.AdicionarMembro(nomeORG, user_id, "Sem Cargo")
                DebugMsg('SUCESSO: O cidadão com passaporte ' .. identity.registration .. ' entrou para a organização ' .. nomeORG)
            end
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.AdicionarMembro(nomeORG, membro_id, cargo)
    local identity = vRP.getUserIdentity(membro_id)
    if org_tables[nomeORG] and identity then
        if not EhMembroDaOrganizacao(nomeORG, membro_id) then
            orgMembro[membro_id] = nomeORG
            org_tables[nomeORG].membros[membro_id] = {cargo = string.upper(cargo)}
            SetOData(nomeORG, json.encode(org_tables[nomeORG]))
            print(json.encode(org_tables[nomeORG].membros,{indent = true}))
            DebugMsg('SUCESSO: O cidadão com passaporte ' .. identity.registration .. ' foi adicionado à organização ' .. nomeORG)
        else
            DebugMsg('ERRO: O cidadão com passaporte ' .. identity.registration .. ' já faz parte da organização ' .. nomeORG)
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.RemoverMembro(nomeORG, membro_id)
    local identity = vRP.getUserIdentity(membro_id)
    if org_tables[nomeORG].membros[membro_id] and identity then
        if EhMembroDaOrganizacao(nomeORG, membro_id) then
            orgMembro[membro_id] = nil
            org_tables[nomeORG].membros[membro_id] = nil
            SetOData(nomeORG, json.encode(org_tables[nomeORG]))
            print(json.encode(org_tables[nomeORG].membros,{indent = true}))
            DebugMsg('SUCESSO: O cidadão com passaporte ' .. identity.registration .. ' foi removido da organização ' .. nomeORG)
        else
            DebugMsg('ERRO: O cidadão com passaporte ' .. identity.registration .. ' não faz parte da organização ' .. nomeORG)
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function VerificarCargoExisteNaOrg(nomeORG, cargo)
    cargo = string.upper(cargo)
    if org_tables[nomeORG].cargos[cargo] then
        DebugMsg('O cargo '.. cargo ..' existe na organização '.. nomeORG ..'!')
        return true
    end
    DebugMsg('O cargo '.. cargo ..' não existe na organização '.. nomeORG ..'!')
    return false
end

function src.CriarCargo(nomeORG, cargo, cargoValores, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    if org_tables[nomeORG] then
        if EhFundadorDaOrganizacao(nomeORG, user_id) then
            if not VerificarCargoExisteNaOrg(nomeORG, cargo) then
                cargo = string.upper(cargo)
                if not cargoValores then
                    cargoValores = {}
                    cargoValores.salario = 100
                end
                org_tables[nomeORG].cargos[cargo] = {salario = cargoValores.salario, permissoes = {}}
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Cargo ' .. cargo .. ' foi adicionado à organização ' .. nomeORG)
            else
                DebugMsg('ERRO: O cargo '.. cargo ..' já existe na organização '.. nomeORG ..'!')
            end
        else
            DebugMsg('ERRO: Apenas o fundador da organização pode criar cargos!')
            return nil
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.RemoverCargo(nomeORG, cargo, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    if org_tables[nomeORG] then
        if EhFundadorDaOrganizacao(nomeORG, user_id) then
            if VerificarCargoExisteNaOrg(nomeORG, cargo) then
                cargo = string.upper(cargo)
                local membrosAfetados = 0
                for membro_id, valores in pairs(org_tables[nomeORG].membros) do
                    if string.upper(valores.cargo) == cargo then
                        org_tables[nomeORG].membros[membro_id] = "Sem Cargo"
                        membrosAfetados = membrosAfetados + 1
                    end
                end
                org_tables[nomeORG].cargos[cargo] = nil
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Cargo ' .. cargo .. ' foi removido da organização ' .. nomeORG .. '\n' .. membrosAfetados .. ' membros da organização ficaram sem cargo...')
            end
        else
            DebugMsg('ERRO: Apenas o fundador da organização pode remover cargos!')
            return nil
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.EditarCargo(nomeORG, cargo, cargoValores, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    if org_tables[nomeORG] then
        if EhFundadorDaOrganizacao(nomeORG, user_id) then
            if VerificarCargoExisteNaOrg(nomeORG, cargo) and cargoValores then
                cargo = string.upper(cargo)
                org_tables[nomeORG].cargos[cargo] = cargoValores
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Cargo ' .. cargo .. ' da organização ' .. nomeORG .. ' foi editado!')
            end
        else
            DebugMsg('ERRO: Apenas o fundador da organização pode editar os cargos!')
            return nil
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.AlterarCargoMembro(nomeORG, membro_id, cargo, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(membro_id)
    if org_tables[nomeORG] and identity then
        if EhFundadorDaOrganizacao(nomeORG, user_id) then
            if VerificarCargoExisteNaOrg(nomeORG, cargo) then
                cargo = string.upper(cargo)
                org_tables[nomeORG].membros[membro_id].cargo = cargo
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Membro com passaporte ' .. identity.registration .. ' teve seu cargo alterado para ' .. cargo .. ' na organização ' .. nomeORG)
            end
        else
            DebugMsg('ERRO: Apenas o fundador da organização pode alterar cargos de membros!')
            return nil
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.TransacaoBancoOrg(nomeORG, valor, tipo, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if org_tables[nomeORG] and identity then
        valor = tonumber(valor)
        if tipo == 'deposito' then
            if valor > 0 then
                org_tables[nomeORG].banco = org_tables[nomeORG].banco + valor
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Depósito no valor de R$' .. valor .. ',00 realizado na organização ' .. nomeORG)
            else
                DebugMsg('ERRO: Tentativa de depósito no valor de R$' .. valor .. ',00 negado na organização ' .. nomeORG)
                return nil
            end
        elseif tipo == 'saque' then
            if org_tables[nomeORG].banco >= valor then
                org_tables[nomeORG].banco = org_tables[nomeORG].banco - valor
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
                DebugMsg('SUCESSO: Saque no valor de R$' .. valor .. ',00 realizado na organização ' .. nomeORG)
            else
                DebugMsg('ERRO: Tentativa de saque no valor de R$' .. valor .. ',00 negado na organização ' .. nomeORG)
                return nil
            end
        else
            DebugMsg('ERRO: Tentativa de transação não identificada na organização ' .. nomeORG)
            return nil
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.PagarSalariosOrg(nomeORG, src)
    local source = source
    if src then source = src end
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if org_tables[nomeORG] and identity then
        if EhFundadorDaOrganizacao(nomeORG, user_id) then
            local totalSalarios = 0
            local prestacao = {}
            for membro_id, valoresM in pairs(org_tables[nomeORG].membros) do
                if valoresM.cargo then
                    local nomeCargo = valoresM.cargo
                    if VerificarCargoExisteNaOrg(nomeORG, nomeCargo) then
                        local salario = org_tables[nomeORG].cargos[nomeCargo].salario
                        prestacao[membro_id] = salario
                        totalSalarios = totalSalarios + salario
                    end
                end
            end
            if org_tables[nomeORG].banco >= totalSalarios and totalSalarios > 0 and prestacao then
                for membro_id, salario in pairs(prestacao) do
                    vRP.giveBankMoney(membro_id, salario)
                    local identity_membro = vRP.getUserIdentity(membro_id)
                    DebugMsg('SUCESSO: O cidadão com passaporte ' .. identity_membro.registration .. ' teve seu salário de R$' .. salario .. ' pago pela organização ' .. nomeORG)
                end
                org_tables[nomeORG].banco = org_tables[nomeORG].banco - totalSalarios
                SetOData(nomeORG, json.encode(org_tables[nomeORG]))
            else
                DebugMsg('ERRO: A organização ' .. nomeORG .. ' não possui fundos para pagar os salários dos seus membros')
            end
        end
    else
        DebugMsg('ERRO: Organização com nome ' .. nomeORG .. ' não encontrada ou cidadão não reconhecido!')
        return nil
    end
end

function src.enviarCargosOrgUI(nomeORG)
    local source = source
    local cargosUI = {}
    for cargo, valores in pairs(org_tables[nomeORG].cargos) do
        table.insert(cargosUI,
	        '<tr><td id=\"' .. cargo .. '\">' .. cargo .. '</td><td>R$' .. valores.salario .. '</td><td>' .. valores.permissoes .. '</td></tr>'
		)
    end
    
    orgCLIENT.receberCargosOrgUI(source, cargosUI)
end

RegisterCommand('orgmenu', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if EhFundadorDeAlgumaOrganizacao(user_id) then
        local nomeORG = EhFundadorDeAlgumaOrganizacao(user_id)
        orgCLIENT.ToggleActionMenu(source, nomeORG, org_tables[nomeORG])
    elseif EhMembroDeAlgumaOrganizacao(user_id) then
        local nomeORG = EhMembroDeAlgumaOrganizacao(user_id)
        orgCLIENT.ToggleActionMenu(source, nomeORG, org_tables[nomeORG])
    else
        orgCLIENT.ToggleActionMenu(source)
    end
end)

RegisterCommand('listajogadores', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        src.ListaJogadoresSemOrg()
    --end
end)

RegisterCommand('listajogadoresorg', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] then
            src.ListaJogadoresDaOrg(args[1], source)
        end
    --end
end)


RegisterCommand('criarorg', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)

    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] then
            local valores = {
                fundador = user_id,
                banco = 0,
                membros = {
                    --[[user_id = "",
                    cargo = ""]]
                },
                cargos = {
                    --[[salario = 0,
                    permissoes = {},]]
                },
                convites = {

                }
            }
            src.CriarOrganizacao(args[1], valores, source)
        end
    --end
end)

RegisterCommand('convidarorg', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.ConvidarMembro(args[1], args[2], source)
        end
    --end
end)

RegisterCommand('aceitarconviteorg', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.AceitarConvite(args[1], args[2], source)
        end
    --end
end)

RegisterCommand('pagarsalariosorg', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] then
            src.PagarSalariosOrg(args[1], source)
        end
    --end
end)

RegisterCommand('addmembro', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.AdicionarMembro(args[1], args[2], "Sem Cargo", source)
        end
    --end
end)

RegisterCommand('remmembro', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.RemoverMembro(args[1], args[2], source)
        end
    --end
end)

RegisterCommand('criarcargo', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.CriarCargo(args[1], args[2], source)
        end
    --end
end)

RegisterCommand('removercargo', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] then
            src.RemoverCargo(args[1], args[2], source)
        end
    --end
end)

RegisterCommand('editarcargo', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] and args[3] and args[4] then
            src.EditarCargo(args[1], args[2], args[3], args[4], source)
        end
    --end
end)

RegisterCommand('altcargo', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] and args[3] then
            src.AlterarCargoMembro(args[1], args[2], args[3], source)
        end
    --end
end)

RegisterCommand('transfbanco', function(source, args, rawCommand)
    --local user_id = vRP.getUserId(source)
    --if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") then
        if args[1] and args[2] and args[3] then
            src.TransacaoBancoOrg(args[1], args[2], args[3], source)
        end
    --end
end)

