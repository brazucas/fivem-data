local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
Passos = Tunnel.getInterface("vrp_interacao")
vRPmenu_ = {}
Tunnel.bindInterface("vrp_interacao", vRPmenu_)
Proxy.addInterface("vrp_interacao", vRPmenu_)
vRPgarage = Tunnel.getInterface("vrp_adv_garages")

-- Criado por [Discord: Passos#2514] 
function vRPmenu_.menuInteracao()
    local source = source
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    local principal = { name = "Brazucas RPG" }
    local admin = { name = "Admin" }
    local mec = { name = "Mecanica" }
    local ems = { name = "Samu" }
    local pm = { name = "Policia" }
    local pessoal = { name = "Pessoal" }
    local veh = { name = "Veiculo" }
    local call = { name = "Chamar" }
    --=============================================================================================--
    -- Administracao
    --=============================================================================================--
    if vRP.hasPermission(user_id, "administrador.permissao") then
        principal["Admin"] = {function(source, choice)
            admin["Adicionar Grupo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                local job = vRP.prompt(source, "Grupo: ", "")
                if id == "" and job == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "group ".. parseInt(id) .." ".. job)
                Passos.notify(source, "~b~[Administração]~g~~n~ Grupo: ".. job .." setado no ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["Adicionar na Whitelist"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "wl ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." setado na ~b~whitelist")
            end}vRP.openMenu(source, admin)
    
            admin["Anunciar"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "adm")
            end}vRP.openMenu(source, admin)
    
            admin["Banir"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "ban ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." ~r~banido~g~.")
            end}vRP.openMenu(source, admin)
            
            admin["Dar Dinheiro"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                local quantia = vRP.prompt(source, "Quantidade: ", "")
                if id == "" and quantia == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "addmoney ".. quantia .." ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você ~b~deu~g~: ".. quantia .." reais pro ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["Dar Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                local veh = vRP.prompt(source, "Veiculo: ", "")
                if id == "" and veh == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "addcar ".. veh .." ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você deu o veículo: ".. veh .." pro ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["Deletar Veículo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "dv")
                Passos.notify(source, "~b~[Administração]~g~~n~ Veículo ~r~Deletado~g~.")
            end}vRP.openMenu(source, admin)
    
            admin["Desbanir"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "unban ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." ~r~desbanido~g~.")
            end}vRP.openMenu(source, admin)
    
            admin["Fixar Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "fix")
                Passos.notify(source, "~b~[Administração]~g~~n~ Veículo consertado.")
            end}vRP.openMenu(source, admin)
    
            admin["Kickar"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "kick ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." ~r~kickado~g~.")
            end}vRP.openMenu(source, admin)
    
            admin["Limpar Inventario"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "limpinv ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." teve seu inventário limpado.")
            end}vRP.openMenu(source, admin)
    
            admin["Me Reviver"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "revive")
                Passos.notify(source, "~b~[Administração]~g~~n~ Você se reviveu.")
            end}vRP.openMenu(source, admin)
    
            admin["Noclip"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "nc")
            end}vRP.openMenu(source, admin)
    
            admin["Pegar Cordenadas"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "cds")
            end}vRP.openMenu(source, admin)
    
            admin["Pegar Dinheiro"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local money = vRP.prompt(source, "Quantia: ", "")
                if money == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "money ".. parseInt(money))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você ~r~criou~g~: ".. parseInt(money) .." reais.")
            end}vRP.openMenu(source, admin)
            
            admin["Pegar Hash"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "hash")
            end}vRP.openMenu(source, admin)
    
            admin["Pegar Item"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local item = vRP.prompt(source, "Item: ", "")
                local qtd = vRP.prompt(source, "Quantidade: ", "")
                if item == "" and qtd == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "item ".. item .." ".. parseInt(qtd))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você ~r~criou~g~: ".. parseInt(qtd) .."x"..item)
            end}vRP.openMenu(source, admin)
            
            admin["Remover da Whitelist"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "unwl ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." removido da whitelist.")
            end}vRP.openMenu(source, admin)
            
            admin["Remover Grupo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                local job = vRP.prompt(source, "Grupo: ", "")
                if id == "" and job == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "ungroup ".. parseInt(id) .." ".. job)
                Passos.notify(source, "~b~[Administração]~g~~n~ Grupo: ".. job .." foi desetado do ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["Remover Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                local veh = vRP.prompt(source, "Veiculo: ", "")
                if id == "" and veh == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "remcar ".. veh .." ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você removeu o veículo: ".. veh .." do ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["Reviver Player"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "revive ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." revivido.")
            end}vRP.openMenu(source, admin)
    
            admin["Reviver Todos"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "reviveall")
                Passos.notify(source, "~b~[Administração]~g~~n~ Você reviveu todos do servidor.")
            end}vRP.openMenu(source, admin)
    
            admin["Spawnar Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "Veículo: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "car ".. id)
                Passos.notify(source, "~b~[Administração]~g~~n~ Você spawnou o Veículo: ".. id)
            end}vRP.openMenu(source, admin)
    
            admin["TPCDS"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "tpcds")
            end}vRP.openMenu(source, admin)
    
            admin["TPTO"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "tpto ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ Você teleportou até o ID: ".. parseInt(id))
            end}vRP.openMenu(source, admin)
    
            admin["TPTOME"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                local id = vRP.prompt(source, "ID: ", "")
                if id == "" then
                    return 
                end
                Passos.ExecuteCommand(source, "tptome ".. parseInt(id))
                Passos.notify(source, "~b~[Administração]~g~~n~ ID: ".. parseInt(id) .." foi teleportado até você.")
            end}vRP.openMenu(source, admin)
    
            admin["TPWAY"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "tpway")
                Passos.notify(source, "~b~[Administração]~g~~n~ Teleportado pra ponto marcado.")
            end}vRP.openMenu(source, admin)
    
            admin["Tunar Veículo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "tuning")
                Passos.notify(source, "~b~[Administração]~g~~n~ Veículo ~r~tunado~g~.")
            end}vRP.openMenu(source, admin)
        end}vRP.openMenu(source, principal)
    end
    --=============================================================================================--
    -- Mecanica
    --=============================================================================================--
    if vRP.hasPermission(user_id, "mecanico.permissao") then
        principal["Mecanico"] = {function(source, choice)
            mec["Motor"] = {function(source, choice)
                Passos.ExecuteCommand(source,"motor")
            end}vRP.openMenu(source, mec)
            mec["Reparar"] = {function(source, choice)
                Passos.ExecuteCommand(source,"Reparar")
            end}vRP.openMenu(source, mec)
        end}vRP.openMenu(source, principal)
    end
    --=============================================================================================--
    -- Menu Pessoal
    --=============================================================================================--
    principal["Pessoal"] = {function(source, choice)
        pessoal["Cancelar Animações"] = {function(source, choice)
            Passos.cancelAnimations(source)
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Animações canceladas.")
        end}vRP.openMenu(source, pessoal)
        pessoal["E/S de Serviço"] = {function(source, choice)
            Passos.ExecuteCommand(source, "toogle")
        end}vRP.openMenu(source, pessoal)

        pessoal["Enviar Dinheiro"] = {function(source, choice)
            local user_id = vRP.getUserId(source)
            local player = vRP.getUserSource(user_id)
            local qtd = vRP.prompt(source, "Quantia de Dinheiro:", "")
            if qtd == "" then
                return
            end
            Passos.ExecuteCommand(source, "enviar ".. parseInt(qtd))
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Você enviou ".. parseInt(qtd) .." reais")
        end}vRP.openMenu(source, pessoal)

        pessoal["Enviar Item"] = {function(source, choice)
            local user_id = vRP.getUserId(source)
            local player = vRP.getUserSource(user_id)
            local item = vRP.prompt(source, "Item:", "")
            if item == "" then
                return
            end
            Passos.ExecuteCommand(source, "enviar ".. item)
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Você enviou ".. item)
        end}vRP.openMenu(source, pessoal)

        pessoal["Fazer Animações"] = {function(source, choice)
            vRP.closeMenu(source, pessoal)
            local user_id = vRP.getUserId(source)
            local player = vRP.getUserSource(user_id)
            local anim = vRP.prompt(source, "Nome da Animação:", "")
            if anim == "" then
                return
            end
            Passos.ExecuteCommand(source, "e ".. anim)
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Animação: ".. anim .." iniciada.")
        end}vRP.openMenu(source, pessoal)

        pessoal["Guardar Armas"] = {function(source, choice)
            Passos.ExecuteCommand(source, "garmas")
        end}vRP.openMenu(source, pessoal)

        pessoal["Inventário"] = {function(source, choice)
            vRP.closeMenu(source, pessoal)
            Passos.ExecuteCommand(source, "moc")
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Seu inventário foi aberto.")
        end}vRP.openMenu(source, pessoal)

        pessoal["Revistar"] = {function(source, choice)
            Passos.ExecuteCommand(source, "revistar")
            Passos.notify(source, "~r~[Pessoal]~b~~n~ Revistando")
        end}vRP.openMenu(source, pessoal)

        pessoal["Roubar"] = {function(source, choice)
            Passos.ExecuteCommand(source, "roubar")
        end}vRP.openMenu(source, pessoal)

        pessoal["Sequestrar"] = {function(source, choice)
            Passos.ExecuteCommand(source, "sequestro")
        end}vRP.openMenu(source, pessoal)
    end}vRP.openMenu(source, principal)

    --=============================================================================================--
    -- Policia
    --=============================================================================================--
    if vRP.hasPermission(user_id, "policia.permissao") then
        principal["Policia"] = {function(source, choice)
            pm["Algemar"] = {function(source, choice)
                TriggerEvent("vrp_policia:algemar")
            end}vRP.openMenu(source, pm)

            pm["Anunciar"] = {function(source, choice)
                Passos.ExecuteCommand(source, "anuncio")
            end}vRP.openMenu(source, pm)

            pm["Apreender Itens ilegais"] = {function(source, choice)
                Passos.ExecuteCommand(source, "apreender")
            end}vRP.openMenu(source, pm)

            pm["Apreender Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "detido")
            end}vRP.openMenu(source, pm)

            pm["Barreira"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "barreira")
            end}vRP.openMenu(source, pm)

            pm["Carregar"] = {function(source, choice)
                TriggerEvent("vrp_policia:carregar")
            end}vRP.openMenu(source, pm)

            pm["Colocar no Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "cv")
            end}vRP.openMenu(source, pm)

            pm["Cones"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "cone")
            end}vRP.openMenu(source, pm)

            pm["Consultar Placa"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "placa")
            end}vRP.openMenu(source, pm)

            pm["Enviar QTH"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "p")
            end}vRP.openMenu(source, pm)

            pm["Espinho"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "spike")
            end}vRP.openMenu(source, pm)

            pm["Extras"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "extras")
            end}vRP.openMenu(source, pm)

            pm["Multar"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "multar")
            end}vRP.openMenu(source, pm)

            pm["Pagar Mecanico"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "paytow")
            end}vRP.openMenu(source, pm)

            pm["Remover Capuz"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "rcapuz")
            end}vRP.openMenu(source, pm)

            pm["Remover Chapeu"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "rchapeu")
            end}vRP.openMenu(source, pm)

            pm["Remover Mascara"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "rmascara")
            end}vRP.openMenu(source, pm)

            pm["Retirar do Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "rv")
            end}vRP.openMenu(source, pm)
        end}vRP.openMenu(source, principal)
    end

    --=============================================================================================--
    -- Paramedico
    --=============================================================================================--
    if vRP.hasPermission(user_id, "paramedico.permissao") then
        principal["SAMU"] = {function(source, choice)
            ems["Algemar"] = {function(source, choice)
                TriggerEvent("vrp_policia:algemar")
            end}vRP.openMenu(source, ems)

            ems["Anunciar"] = {function(source, choice)
                Passos.ExecuteCommand(source,"anuncio")
            end}vRP.openMenu(source, ems)

            ems["Barreira"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "barreira")
            end}vRP.openMenu(source, ems)

            ems["Carregar"] = {function(source, choice)
                TriggerEvent("vrp_policia:carregar")
            end}vRP.openMenu(source, ems)

            ems["Colocar no Veiculo"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "cv")
            end}vRP.openMenu(source, ems)

            ems["Cones"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "cone")
            end}vRP.openMenu(source, ems)

            ems["Espinhos"] = {function(source, choice)
                local user_id = vRP.getUserId(source)
                Passos.ExecuteCommand(source, "spike")
            end}vRP.openMenu(source, ems)

            ems["Extras"] = {function(source, choice)
                Passos.ExecuteCommand(source,"extras")
            end}vRP.openMenu(source, ems)

            ems["Reanimar"] = {function(source, choice)
                Passos.ExecuteCommand(source,"re")
            end}vRP.openMenu(source, ems)

            ems["Retirar do Veiculo"] = {function(source, choice)
                Passos.ExecuteCommand(source,"rv")
            end}vRP.openMenu(source, ems)

            ems["Remover Capuz"] = {function(source, choice)
                Passos.ExecuteCommand(source,"rcapuz")
            end}vRP.openMenu(source, ems)

            ems["Remover Chapeu"] = {function(source, choice)
                Passos.ExecuteCommand(source,"rchapeu")
            end}vRP.openMenu(source, ems)

            ems["Remover Mascara"] = {function(source, choice)
                Passos.ExecuteCommand(source,"rmascara")
            end}vRP.openMenu(source, ems)
        end}vRP.openMenu(source, principal)
    end
    --=============================================================================================--
    -- Chamar Servicos
    --=============================================================================================--

    principal["Serviços"] = {function(source, choice)
        call["Chamar Admin"] = {function(source, choice)
            Passos.ExecuteCommand(source, "call admin")
        end}vRP.openMenu(source, call)
        call["Chamar Mecânico"] = {function(source, choice)
            Passos.ExecuteCommand(source, "call mec")
        end}vRP.openMenu(source, call)
        call["Chamar Paramédico"] = {function(source, choice)
            Passos.ExecuteCommand(source, "call 192")
        end}vRP.openMenu(source, call)
        call["Chamar Polícia"] = {function(source, choice)
            Passos.ExecuteCommand(source, "call 190")
        end}vRP.openMenu(source, call)
        call["Chamar Taxi"] = {function(source, choice)
            Passos.ExecuteCommand(source, "call tax")
        end}vRP.openMenu(source, call)
    end}vRP.openMenu(source, principal)

    --=============================================================================================--
    -- Gerenciamento de Veiculos
    --=============================================================================================--
    principal["Veiculo"] = {function(source, choice)
        veh["Destrancar/Trancar"] = {function(source, choice)
            local source = source
            local user_id = vRP.getUserId(source)
            local mPlaca = vRPclient.ModelName(source,7)
            local mPlacaUser = vRP.getUserByPublicPlate(mPlaca)
            if user_id == mPlacaUser then
                vRPgarage.toggleLock(source)
                TriggerClientEvent("vrp_sound:source",source,'lock',0.1)
            end
        end}vRP.openMenu(source, veh)
        veh["Meus Veículos"] = {function(source, choice)
            Passos.ExecuteCommand(source, "vehs")
        end}vRP.openMenu(source, veh)
        veh["Portas"] = {function(source, choice)
            Passos.ExecuteCommand(source, "doors")
        end}vRP.openMenu(source, veh)
        veh["Vidros"] = {function(source, choice)
            Passos.ExecuteCommand(source, "wins")
        end}vRP.openMenu(source, veh)

    end}vRP.openMenu(source, principal)
end
