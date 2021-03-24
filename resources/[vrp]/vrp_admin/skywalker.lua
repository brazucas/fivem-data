local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONEXÃO ]-----------------------------------------------------------------------------------------------------------------

vRPidd = {}
Tunnel.bindInterface("vrp_admin", vRPidd)
Proxy.addInterface("vrp_admin", vRPidd)
IDDclient = Tunnel.getInterface("vrp_admin")

--[ WEBHOOK ]-----------------------------------------------------------------------------------------------------------------

local logAdminEstoque = ""
local logAdminWhitelist = ""
local logAdminUnWhitelist = ""
local logAdminBan = ""
local logAdminUnBan = ""
local logAdminRenomear = ""
local logAdminAnuncio = ""
local logAdminEstoque = ""
local logAdminAddcar = ""
local logAdminRemcar = ""
local logAdminMoney = ""
local logAdminReviver = ""
local logAdminKick = ""
local logAdminFix = ""
local logAdminNc = ""
local logAdminTps = ""
local logAdminOrg = ""
local logAdmCorno = ""
local logAdmStatus = ""

--[ RENOMEAR ]----------------------------------------------------------------------------------------------------------------

RegisterCommand('renomear', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local idjogador = vRP.prompt(source, "Qual id do jogador?", "")
        local nome = vRP.prompt(source, "Novo nome", "")
        local firstname = vRP.prompt(source, "Novo sobrenome", "")
        local idade = vRP.prompt(source, "Nova idade", "")
        local nuidentity = vRP.getUserIdentity(parseInt(idjogador))

        local p = promise.new()
        exports.mongodb:updateOne({
            collection = "vrp_user_identities",
            query = { user_id = idjogador },
            update = {
                ["$set"] = {
                    firstname = firstname,
                    name = nome,
                    age = idade,
                    registration = nuidentity.registration,
                    phone = nuidentity.phone
                }
            }
        }, function(success, result)
            if success then
                p:resolve()
            else
                p:reject("[MongoDB][renomear] Error in updateOne: " .. tostring(result))
            end
        end)
        Citizen.Await(p)

        PerformHttpRequest(logAdminRenomear, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE ALTERAÇÃO IDENTIDADE⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        },
                        {
                            name = "**NOVOS DADOS DO RG:**",
                            value = "**[" .. vRP.format(parseInt(idjogador)) .. "][ Nome: " .. nome .. " ][ Sobrenome: " .. firstname .. " ][ Idade: " .. idade .. " ]**\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end)

--[ VROUPAS ]-----------------------------------------------------------------------------------------------------------------

local player_customs = {}
RegisterCommand('vroupas', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local custom = vRPclient.getCustomization(source)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if player_customs[source] then
            player_customs[source] = nil
            vRPclient._removeDiv(source, "customization")
        else
            local content = ""

            for k, v in pairs(custom) do
                content = content .. k .. " => " .. json.encode(v) .. "<br/>"
            end

            player_customs[source] = true
            vRPclient._setDiv(source, "customization", ".div_customization{ margin: auto; padding: 4px; width: 250px; margin-top: 200px; margin-right: 50px; background: rgba(15,15,15,0.7); color: #ffff; font-weight: bold; }", content)
        end
    end
end)

--[ ESTOQUE ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('estoque', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and args[2] then

            PerformHttpRequest(logAdminEstoque, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE ALTERAÇÃO DE ESTOQUE⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**MODIFICAÇÃO DE ESTOQUE:**",
                                value = "**[ Modelo: " .. args[1] .. " ][ Quantidade: " .. vRP.format(parseInt(args[2])) .. " ]**\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            local p = promise.new()
            exports.mongodb:updateOne({
                collection = "vrp_estoque",
                query = { vehicle = args[1] },
                update = {
                    ["$set"] = {
                        quantidade = args[2],
                    }
                }
            }, function(success, result)
                if success then
                    p:resolve()
                else
                    p:reject("[MongoDB][renomear] Error in updateOne: " .. tostring(result))
                end
            end)
            Citizen.Await(p)

            TriggerClientEvent("Notify", source, "sucesso", "Voce colocou mais <b>" .. args[2] .. "</b> no estoque, para o carro <b>" .. args[1] .. "</b>.")
        end
    end
end)

--[ ADICIONAR CARRO ]---------------------------------------------------------------------------------------------------------

RegisterCommand('addcar', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local nplayer = vRP.getUserId(parseInt(args[2]))

    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identitynu = vRP.getUserIdentity(nuser_id)

            PerformHttpRequest(logAdminAddcar, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE CARRO ADICIONADO A PLAYER⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**INFORMAÇÕES:**",
                                value = "**[ Modelo: " .. args[1] .. " ][ Player ID: " .. args[2] .. " ]**\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            local p = promise.new()
            exports.mongodb:insertOne({
                collection = "vrp_user_vehicles",
                document = {
                    user_id = parseInt(args[2]),
                    vehicle = args[1],
                    ipva = parseInt(os.time())
                }
            }, function(success, result, insertedIds)
                if success then
                    p:resolve(insertedIds[1])
                else
                    p:reject("[MongoDB] ERROR " .. tostring(result))
                end
            end)
            Citizen.Await(p)

            TriggerClientEvent("Notify", source, "sucesso", "Voce adicionou o veículo <b>" .. args[1] .. "</b> para o Passaporte: <b>" .. parseInt(args[2]) .. "</b>.")
        end
    end
end)

--[ REMOVER CARRO ]-----------------------------------------------------------------------------------------------------------

RegisterCommand('remcar', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local nplayer = vRP.getUserId(parseInt(args[2]))

    if vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and args[2] then
            local nuser_id = vRP.getUserId(nplayer)
            local identitynu = vRP.getUserIdentity(nuser_id)

            PerformHttpRequest(logAdminRemcar, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE CARRO REMOVIDO DE PLAYER⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**INFORMAÇÕES:**",
                                value = "**[ Modelo: " .. args[1] .. " ][ Player ID: " .. args[2] .. " ]**\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            exports.mongodb:deleteOne({ collection = "vrp_user_vehicles", query = { user_id = parseInt(args[2]), vehicle = args[1] } })
            TriggerClientEvent("Notify", source, "sucesso", "Voce removeu o veículo <b>" .. args[1] .. "</b> do Passaporte: <b>" .. parseInt(args[2]) .. "</b>.")
        end
    end
end)

--[ UNCUFF ]------------------------------------------------------------------------------------------------------------------

RegisterCommand('uncuff', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
            TriggerClientEvent("admcuff", source)
        end
    end
end)

--[ SYNCAREA ]----------------------------------------------------------------------------------------------------------------

RegisterCommand('limpararea', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local x, y, z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        TriggerClientEvent("syncarea", -1, x, y, z)
    end
end)

--[ APAGAO ]------------------------------------------------------------------------------------------------------------------

RegisterCommand('apagao', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") and args[1] ~= nil then
            local cond = tonumber(args[1])
            --TriggerEvent("cloud:setApagao",cond)
            TriggerClientEvent("cloud:setApagao", -1, cond)
        end
    end
end)

--[ RAIOS ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('raios', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") and args[1] ~= nil then
            local vezes = tonumber(args[1])
            TriggerClientEvent("cloud:raios", -1, vezes)
        end
    end
end)

--[ TROCAR SEXO ]-------------------------------------------------------------------------------------------------------------

RegisterCommand('skin', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if parseInt(args[1]) then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                TriggerClientEvent("skinmenu", nplayer, args[2])
                TriggerClientEvent("Notify", source, "sucesso", "Voce setou a skin <b>" .. args[2] .. "</b> no passaporte <b>" .. parseInt(args[1]) .. "</b>.")
            end
        end
    end
end)

--[ DEBUG ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('debug', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        local player = vRP.getUserSource(user_id)
        if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
            TriggerClientEvent("ToggleDebug", player)
        end
    end
end)

--[ TRYDELETEOBJ ]------------------------------------------------------------------------------------------------------------

RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj", function(index)
    TriggerClientEvent("syncdeleteobj", -1, index)
end)

--[ FIX ]---------------------------------------------------------------------------------------------------------------------

RegisterCommand('fix', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    local vehicle = vRPclient.getNearestVehicle(source, 11)
    if vehicle then
        if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then

            PerformHttpRequest(logAdminFix, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE FIX⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            TriggerClientEvent('reparar', source)
        end
    end
end)

--[ REVIVER ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('reviver', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                local nuser_id = vRP.getUserId(nplayer)
                local identitynu = vRP.getUserIdentity(nuser_id)

                PerformHttpRequest(logAdminReviver, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            ------------------------------------------------------------
                            title = "REGISTRO DE REVIVER⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**COLABORADOR DA EQUIPE:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                },
                                {
                                    name = "**INFORMAÇÕES DO PLAYER REVIVIDO:**",
                                    value = "**" .. identitynu.name .. " " .. identitynu.firstname .. "** [**" .. nuser_id .. "**]\n⠀"
                                }
                            },
                            footer = {
                                text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            color = 15906321
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer, 400)
                vRP.varyThirst(nplayer, -15)
                vRP.varyHunger(nplayer, -15)
            end
        else
            PerformHttpRequest(logAdminReviver, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE REVIVER⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRPclient.killGod(source)
            vRPclient.setHealth(source, 400)
            vRP.varyThirst(source, -100)
            vRP.varyHunger(source, -100)
        end
    end
end)

--[ REVIVER ALL ]-------------------------------------------------------------------------------------------------------------

RegisterCommand('reviverall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local users = vRP.getUsers()
        for k, v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                vRPclient.killGod(id)
                vRPclient.setHealth(id, 400)
            end
        end

        PerformHttpRequest(logAdminReviver, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE REVIVER TODOS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end)

--[ HASH ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand('hash', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "manager.permissao") then
        TriggerClientEvent('vehash', source)
    end
end)

--[ TUNING ]------------------------------------------------------------------------------------------------------------------

RegisterCommand('tuning', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        TriggerClientEvent('vehtuning', source)
    end
end)

--[ WL ]----------------------------------------------------------------------------------------------------------------------

RegisterCommand('wl', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "suporte.permissao") or vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "aprovador-wl.permissao") then
        if args[1] then

            PerformHttpRequest(logAdminWhitelist, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "NOVO ID ADICIONADO A WHITELIST⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**ID ADICIONADO: **" .. vRP.format(parseInt(args[1])),
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRP.setWhitelisted(parseInt(args[1]), true)
            TriggerClientEvent("Notify", source, "sucesso", "Você aprovou o passaporte <b>" .. args[1] .. "</b> na whitelist.")
        end
    end
end)

--[ UNWL ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand('unwl', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "suporte.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then

            PerformHttpRequest(logAdminUnWhitelist, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "ID REMOVIDO DA WHITELIST⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**ID REMOVIDO: **" .. vRP.format(parseInt(args[1])),
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRP.setWhitelisted(parseInt(args[1]), false)
            TriggerClientEvent("Notify", source, "sucesso", "Você retirou o passaporte <b>" .. args[1] .. "</b> da whitelist.")
        end
    end
end)

--[ KICK ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand('kick', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then
            local id = vRP.getUserSource(parseInt(args[1]))
            if id then

                PerformHttpRequest(logAdminKick, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            ------------------------------------------------------------
                            title = "REGISTRO DE KICK⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**COLABORADOR DA EQUIPE:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                },
                                {
                                    name = "**ID KIKADO: **" .. vRP.format(parseInt(args[1])),
                                    value = "⠀"
                                }
                            },
                            footer = {
                                text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            color = 15906321
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                vRP.kick(id, "Você foi expulso da cidade.")
                TriggerClientEvent("Notify", source, "sucesso", "Voce kickou o passaporte <b>" .. args[1] .. "</b> da cidade.")
            end
        end
    end
end)

--[ KICK ALL ]----------------------------------------------------------------------------------------------------------------

RegisterCommand('kickall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local users = vRP.getUsers()
        for k, v in pairs(users) do
            local id = vRP.getUserSource(parseInt(k))
            if id then
                vRP.kick(id, "Você foi vitima do terremoto.")
            end
        end

        PerformHttpRequest(logAdminKick, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE KICKAR TODOS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })
    end
end)

--[ BAN ]---------------------------------------------------------------------------------------------------------------------

RegisterCommand('ban', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then
            local nuser_id = vRP.getUserSource(parseInt(args[1]))

            PerformHttpRequest(logAdminBan, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "REGISTRO DE BANIMENTO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**ID BANIDO: **" .. vRP.format(parseInt(args[1])),
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRP.setBanned(parseInt(args[1]), true)
            vRP.kick(nuser_id, "Você foi banido! [ Mais informações em: discord.gg/Bp6ZMsS ]")

            TriggerClientEvent("Notify", source, "sucesso", "Voce baniu o passaporte <b>" .. args[1] .. "</b> da cidade.")
        end
    end
end)

--[ UNBAN ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('unban', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then

            PerformHttpRequest(logAdminUnBan, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "REGISTRO DE DESBANIMENTO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**ID DESBANIDO: **" .. vRP.format(parseInt(args[1])),
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRP.setBanned(parseInt(args[1]), false)
            TriggerClientEvent("Notify", source, "sucesso", "Voce desbaniu o passaporte <b>" .. args[1] .. "</b> da cidade.")
        end
    end
end)

--[ MONEY ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('money', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then

            PerformHttpRequest(logAdminMoney, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        -----------------------------------------------------------
                        title = "REGISTRO DE ADIÇÃO DE DINHEIRO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR DA EQUIPE:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**VALOR: **" .. vRP.format(parseInt(args[1])),
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            vRP.giveDinheirama(user_id, parseInt(args[1]))
        end
    end
end)

--[ NC ]----------------------------------------------------------------------------------------------------------------------

RegisterCommand('nc', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then

        PerformHttpRequest(logAdminNc, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE NC⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        vRPclient.toggleNoclip(source)
    end
end)

--[ TPCDS ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('tpcds', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local fcoords = vRP.prompt(source, "Cordenadas:", "")
        if fcoords == "" then
            return
        end
        local coords = {}
        for coord in string.gmatch(fcoords or "0,0,0", "[^,]+") do
            table.insert(coords, parseInt(coord))
        end



        vRPclient.teleport(source, coords[1] or 0, coords[2] or 0, coords[3] or 0)
    end
end)

--[ COORDENADAS ]-------------------------------------------------------------------------------------------------------------

RegisterCommand('cds', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local x, y, z = vRPclient.getPosition(source)
        heading = GetEntityHeading(GetPlayerPed(-1))
        vRP.prompt(source, "Cordenadas:", "['x'] = " .. tD(x) .. ", ['y'] = " .. tD(y) .. ", ['z'] = " .. tD(z))
    end
end)

RegisterCommand('cds2', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local x, y, z = vRPclient.getPosition(source)
        vRP.prompt(source, "Cordenadas:", tD(x) .. ", " .. tD(y) .. ", " .. tD(z))
    end
end)

RegisterCommand('cds3', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local x, y, z = vRPclient.getPosition(source)
        vRP.prompt(source, "Cordenadas:", "{name='ATM', id=277, x=" .. tD(x) .. ", y=" .. tD(y) .. ", z=" .. tD(z) .. "},")
    end
end)

RegisterCommand('cds4', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local x, y, z = vRPclient.getPosition(source)
        vRP.prompt(source, "Cordenadas:", "x = " .. tD(x) .. ", y = " .. tD(y) .. ", z = " .. tD(z))
    end
end)

--[ GROUP ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('group', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local nplayer = vRP.getUserSource(parseInt(args[1]))
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and args[2] then
            vRP.addUserGroup(parseInt(args[1]), args[2])
            TriggerClientEvent("Notify", source, "sucesso", "Voce setou o passaporte <b>" .. parseInt(args[1]) .. "</b> no grupo <b>" .. args[2] .. "</b>.")
            TriggerClientEvent("oc_gps:coords", nplayer)
        end
    end
end)

--[ UNGROUP ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('ungroup', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and args[2] then
            vRP.removeUserGroup(parseInt(args[1]), args[2])
            TriggerClientEvent("Notify", source, "sucesso", "Voce removeu o passaporte <b>" .. parseInt(args[1]) .. "</b> do grupo <b>" .. args[2] .. "</b>.")
        end
    end
end)

--[ TPTOME ]------------------------------------------------------------------------------------------------------------------

RegisterCommand('tptome', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then
            local tplayer = vRP.getUserSource(parseInt(args[1]))
            local x, y, z = vRPclient.getPosition(source)
            if tplayer then

                PerformHttpRequest(logAdminTps, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            ------------------------------------------------------------
                            title = "REGISTRO DE TPTOME⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**COLABORADOR:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                },
                                {
                                    name = "**ID DO PLAYER PUXADO: **" .. args[1],
                                    value = "⠀"
                                }
                            },
                            footer = {
                                text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            color = 15906321
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                vRPclient.teleport(tplayer, x, y, z)
            end
        end
    end
end)

--[ TPTO ]--------------------------------------------------------------------------------------------------------------------

RegisterCommand('tpto', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] then
            local tplayer = vRP.getUserSource(parseInt(args[1]))
            if tplayer then
                PerformHttpRequest(logAdminTps, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            ------------------------------------------------------------
                            title = "REGISTRO DE TPTO⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**COLABORADOR:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                },
                                {
                                    name = "**ID DO PLAYER: **" .. args[1],
                                    value = "⠀"
                                }
                            },
                            footer = {
                                text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                icon_url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            color = 15906321
                        }
                    }
                }), { ['Content-Type'] = 'application/json' })

                vRPclient.teleport(source, vRPclient.getPosition(tplayer))
            end
        end
    end
end)

--[ TPWAY ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('tpway', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then

        PerformHttpRequest(logAdminTps, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE TPWAY⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        TriggerClientEvent('tptoway', source)
    end
end)

--[ TELECOORDS ]-------------------------------------------------------------------------------------------------------------------

RegisterCommand('tlcoords', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and args[2] and args[3] then
            PerformHttpRequest(logAdminTps, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        ------------------------------------------------------------
                        title = "REGISTRO DE TELECOORDS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "**COLABORADOR:**",
                                value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                            },
                            {
                                name = "**COORDENADAS: **" .. args[1] .. args[2] .. args[3],
                                value = "⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15906321
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            TriggerClientEvent('telecoords', source, parseFloat(args[1]), parseFloat(args[2]), parseFloat(args[3]))
        end
    end
end)

--[ DELNPCS ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('savepos', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        file = io.open( './coords.txt', "a")
        if file then
            file:write("{" .. coords.x .. ",".. coords.y .. "," .. coords.z .. ", HEADING:" .. heading .. "},")
            file:write("\n")
        end
        file:close()
    end
end)

--[ DELNPCS ]-----------------------------------------------------------------------------------------------------------------

RegisterCommand('delnpcs', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        TriggerClientEvent('delnpcs', source)
    end
end)

--[ ADM ]---------------------------------------------------------------------------------------------------------------------

RegisterCommand('anuncio', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local mensagem = vRP.prompt(source, "Mensagem:", "")
        if mensagem == "" then
            return
        end

        PerformHttpRequest(logAdminAnuncio, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ------------------------------------------------------------
                    title = "REGISTRO DE ANUNCIOS⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                    thumbnail = {
                        url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    fields = {
                        {
                            name = "**COLABORADOR DA EQUIPE:**",
                            value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                        },
                        {
                            name = "**ANÚNCIO:**",
                            value = "**" .. mensagem .. "**\n⠀"
                        }
                    },
                    footer = {
                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                    },
                    color = 15906321
                }
            }
        }), { ['Content-Type'] = 'application/json' })

        vRPclient.setDiv(-1, "anuncio", ".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 250px; right: 20px; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }", "<bold>" .. mensagem .. "</bold><br><br>Mensagem enviada por: Administrador")
        SetTimeout(30000, function()
            vRPclient.removeDiv(-1, "anuncio")
        end)
    end
end)

--[ HEALAR ]---------------------------------------------------------------------------------------------------------------

RegisterCommand('saude', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local nplayer = vRP.getUserSource(parseInt(args[1]))
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        if args[1] and parseInt(args[2]) > 0 then
            vRPclient.setHealth(nplayer, parseInt(args[2]))
            SetTimeout(200, function()
                if vRPclient.isInComa(nplayer) then
                    vRPclient.killComa(nplayer)
                end
            end)
            TriggerClientEvent("Notify", source, "sucesso", "Voce setou a saúde do id <b>" .. parseInt(args[1]) .. "</b> para <b>" .. parseInt(args[2]) .. "</b>.")
        else
            TriggerClientEvent("Notify", source, "negado", "Use /saude [id] [quantidade]")
        end
    end
end)

--[ PLAYERSON ]---------------------------------------------------------------------------------------------------------------

RegisterCommand('pon', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
        local users = vRP.getUsers()
        local players = ""
        local quantidade = 0

        for k, v in pairs(users) do
            if k ~= #users then
                players = players
            end

            players = players .. " " .. k
            quantidade = quantidade + 1
        end

        TriggerClientEvent('chatMessage', source, "TOTAL ONLINE", { 255, 160, 0 }, quantidade)
        TriggerClientEvent('chatMessage', source, "ID's ONLINE", { 255, 160, 0 }, players)
    end
end)

--[ ORGS MANAGER ]------------------------------------------------------------------------------------------------------------

RegisterCommand('org', function(source, args, rawCommand)
    if args[1] then
        local source = source
        local contratado = vRP.prompt(source, "Passaporte:", "")
        local idcontratado = parseInt(contratado)
        if contratado ~= "" then
            local org = vRP.prompt(source, "Cargo:", "")
            if org ~= "" then
                if args[1] == "add" then
                    local user_id = vRP.getUserId(source)
                    local identity = vRP.getUserIdentity(user_id)
                    if org == "ndrangheta" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-ndrangheta.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "ndrangheta")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "bratva" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-bratva.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "bratva")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "motoclub" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-motoclub.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "motoclub")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "medellin" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-medellin.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "medellin")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "grove" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-grove.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "grove")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "ballas" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-ballas.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "ballas")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "families" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-families.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, "families")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "diretor-geral" or org == "diretor-auxiliar" or org == "medico-chefe" or org == "medico-cirurgiao" or org == "medico-aulixiar" or org == "medico" or org == "paramedico" or org == "enfermeiro" or org == "socorrista" or org == "estagiario" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "diretor-geral.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "chefe-policia" or org == "sub-chefe-policia" or org == "inspetor" or org == "capitao" or org == "tenente" or org == "sub-tenente" or org == "primeiro-sargento" or org == "segundo-sargento" or org == "agente-policia" or org == "recruta-policia" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "chefe-policia") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "juiz" or org == "procurador" or org == "promotor" or org == "defensor" or org == "advogado" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "juiz.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.addUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    end

                    PerformHttpRequest(logAdminOrg, function(err, text, headers) end, 'POST', json.encode({
                        embeds = {
                            {
                                ------------------------------------------------------------
                                title = "REGISTRO DE CONTRATAÇÃO ORG⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                                thumbnail = {
                                    url = "https://i.imgur.com/5ydYKZg.png"
                                },
                                fields = {
                                    {
                                        name = "**LÍDER:**",
                                        value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                    },
                                    {
                                        name = "**INFORMAÇÕES DA CONTRATAÇÃO:**",
                                        value = "**[ ID Contratado: " .. idcontratado .. " ][ Cargo: " .. org .. " **]\n⠀"
                                    }
                                },
                                footer = {
                                    text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                    icon_url = "https://i.imgur.com/5ydYKZg.png"
                                },
                                color = 15906321
                            }
                        }
                    }), { ['Content-Type'] = 'application/json' })

                elseif args[1] == "rem" then
                    local user_id = vRP.getUserId(source)
                    local identity = vRP.getUserIdentity(user_id)

                    if org == "ndrangheta" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-ndrangheta.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "ndrangheta")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "bratva" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-bratva.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "bratva")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "motoclub" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-motoclub.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "motoclub")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "medellin" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-medellin.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "medellin")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "grove" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-grove.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "grove")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "ballas" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-ballas.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "ballas")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "families" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "lider-families.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, "families")
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "diretor-geral" or org == "diretor-auxiliar" or org == "medico-chefe" or org == "medico-cirurgiao" or org == "medico-aulixiar" or org == "medico" or org == "paramedico" or org == "enfermeiro" or org == "socorrista" or org == "estagiario" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "diretor-geral.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "chefe-policia" or org == "sub-chefe-policia" or org == "inspetor" or org == "capitao" or org == "tenente" or org == "sub-tenente" or org == "primeiro-sargento" or org == "segundo-sargento" or org == "agente-policia" or org == "recruta-policia" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "chefe-policia") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    elseif org == "juiz" or org == "procurador" or org == "promotor" or org == "defensor" or org == "advogado" then
                        local user_id = vRP.getUserId(source)
                        if vRP.hasPermission(user_id, "juiz.permissao") or vRP.hasPermission(user_id, "manager.permissao") then
                            vRP.removeUserGroup(idcontratado, org)
                        else
                            TriggerClientEvent("Notify", source, "negado", "Permissão <b>negada</b>!")
                        end
                    end

                    PerformHttpRequest(logAdminOrg, function(err, text, headers) end, 'POST', json.encode({
                        embeds = {
                            {
                                ------------------------------------------------------------
                                title = "REGISTRO DE DEMISSÃO ORG⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                                thumbnail = {
                                    url = "https://i.imgur.com/5ydYKZg.png"
                                },
                                fields = {
                                    {
                                        name = "**LÍDER:**",
                                        value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                                    },
                                    {
                                        name = "**INFORMAÇÕES DA DEMISSÃO:**",
                                        value = "**[ ID Contratado: " .. idcontratado .. " ][ Cargo: " .. org .. " **]\n⠀"
                                    }
                                },
                                footer = {
                                    text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                    icon_url = "https://i.imgur.com/5ydYKZg.png"
                                },
                                color = 15906321
                            }
                        }
                    }), { ['Content-Type'] = 'application/json' })
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Cargo <b>inválido</b> ou <b>inexistente</b>.")
            end
        else
            TriggerClientEvent("Notify", source, "negado", "Passaporte <b>inválido</b> ou <b>inexistente</b>.")
        end
    end
end)

--[ ID NA CABEÇA ]------------------------------------------------------------------------------------------------------------

function vRPidd.getPermissao()
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "suporte.permissao") then
        return true
    else
        return false
    end
end

RegisterCommand('ids', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") or vRP.hasPermission(user_id, "moderador.permissao") or vRP.hasPermission(user_id, "suporte.permissao") then
        TriggerClientEvent("mostrarid", source)
    end
end)

function vRPidd.logID()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local x, y, z = vRPclient.getPosition(source)

    PerformHttpRequest(logAdmCorno, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ------------------------------------------------------------
                title = "REGISTRO DE ID VISIVEL:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                thumbnail = {
                    url = "https://i.imgur.com/5ydYKZg.png"
                },
                fields = {
                    {
                        name = "**COLABORADOR DA EQUIPE:**",
                        value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]\n⠀"
                    },
                    {
                        name = "**LOCAL: " .. tD(x) .. ", " .. tD(y) .. ", " .. tD(z) .. "**",
                        value = "⠀"
                    }
                },
                footer = {
                    text = "BRZ" .. os.date("%d/%m/%Y |: %H:%M:%S"),
                    icon_url = "https://i.imgur.com/5ydYKZg.png"
                },
                color = 16431885
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

RegisterCommand('staff', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)
    local cargo = nil
    local status = nil

    if vRP.hasPermission(user_id, "manager.permissao") then
        cargo = "Manager"
        status = "Saiu do modo administrativo."
        vRP.addUserGroup(user_id, "off-manager")
        TriggerClientEvent("Notify", source, "negado", "<b>[MANAGER]</b> OFF.")

    elseif vRP.hasPermission(user_id, "off-manager.permissao") then
        cargo = "Manager"
        status = "Entrou no modo administrativo."
        vRP.addUserGroup(user_id, "manager")
        TriggerClientEvent("Notify", source, "sucesso", "<b>[MANAGER]</b> ON.")

    elseif vRP.hasPermission(user_id, "administrador.permissao") then
        cargo = "Administrador"
        status = "Saiu do modo administrativo."
        vRP.addUserGroup(user_id, "off-administrador")
        TriggerClientEvent("Notify", source, "negado", "<b>[ADMINISTRADOR]</b> OFF.")

    elseif vRP.hasPermission(user_id, "off-administrador.permissao") then
        cargo = "Administrador"
        status = "Entrou no modo administrativo."
        vRP.addUserGroup(user_id, "administrador")
        TriggerClientEvent("Notify", source, "sucesso", "<b>[ADMINISTRADOR]</b> ON.")

    elseif vRP.hasPermission(user_id, "moderador.permissao") then
        cargo = "Moderador"
        status = "Saiu do modo administrativo."
        vRP.addUserGroup(user_id, "off-moderador")
        TriggerClientEvent("Notify", source, "negado", "<b>[MODERADOR]</b> OFF.")

    elseif vRP.hasPermission(user_id, "off-moderador.permissao") then
        cargo = "Moderador"
        status = "Entrou no modo administrativo."
        vRP.addUserGroup(user_id, "moderador")
        TriggerClientEvent("Notify", source, "sucesso", "<b>[MODERADOR]</b> ON.")

    elseif vRP.hasPermission(user_id, "suporte.permissao") then
        cargo = "Suporte"
        status = "Saiu do modo administrativo."
        vRP.addUserGroup(user_id, "off-suporte")
        TriggerClientEvent("Notify", source, "negado", "<b>[SUPORTE]</b> OFF.")

    elseif vRP.hasPermission(user_id, "off-suporte.permissao") then
        cargo = "Suporte"
        status = "Entrou no modo administrativo."
        vRP.addUserGroup(user_id, "suporte")
        TriggerClientEvent("Notify", source, "sucesso", "<b>[SUPORTE]</b> ON.")
    end

    PerformHttpRequest(logAdmStatus, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ------------------------------------------------------------
                title = "REGISTRO ADMINISTRATIVO:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                thumbnail = {
                    url = "https://i.imgur.com/5ydYKZg.png"
                },
                fields = {
                    {
                        name = "**IDENTIFICAÇÃO: " .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]",
                        value = "⠀"
                    },
                    {
                        name = "**CARGO: **" .. cargo,
                        value = "⠀",
                        inline = true
                    },
                    {
                        name = "**STATUS: **" .. status,
                        value = "⠀",
                        inline = true
                    }
                },
                footer = {
                    text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                    icon_url = "https://i.imgur.com/5ydYKZg.png"
                },
                color = 15906321
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end)

local plan = {}

RegisterCommand("plano", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    if args[1] == "add" then
        if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
            if vRP.getUserSource(tonumber(args[2])) then
                if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
                    local consulta = vRP.getUData(tonumber(args[2]), "vRP:plano")
                    local resultado = json.decode(consulta) or {}
                    resultado.tempo = (resultado.tempo or 0) + tonumber(args[3]) * 1440
                    plan[vRP.getUserId(source)] = resultado.tempo
                    vRP.setUData(tonumber(args[2]), "vRP:plano", json.encode(resultado))
                end
            end
        end
    elseif args[1] == "info" then
        local consulta = vRP.getUData(vRP.getUserId(source), "vRP:plano")
        local resultado = json.decode(consulta) or {}

        resultado.tempo = resultado.tempo or 0
        resultado = resultado.tempo / 1440 or 0

        TriggerClientEvent("Notify", source, "importante", "<b>Dias Restantes:</b> " .. math.ceil(resultado))
    end
end)

function vRPidd.getId()
    local user_id = vRP.getUserId()
    return user_id
end

function tD(n)
    n = math.ceil(n * 100) / 100
    return n
end

--[ VIP ]---------------------------------------------------------------------------------------------------------------------

local run = {}

RegisterCommand("vip", function(source, args)
    local source = source
    local user_id = vRP.getUserId(source)
    local nuser_id = parseInt(args[2])
    if args[1] == "add" then
        local vip = args[3]
        if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
            if vip == "ultimate" then
                vRP.addUserGroup(nuser_id, "ultimate")
                TriggerClientEvent("Notify", source, "sucesso", "ID " .. args[1] .. " setado de Ultimate pass.")
                if vRP.getUserSource(tonumber(args[2])) then
                    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
                        local consulta = vRP.getUData(tonumber(args[2]), "vRP:vip")
                        local resultado = json.decode(consulta) or {}
                        resultado.tempo = (resultado.tempo or 0) + tonumber(args[4]) * 1440
                        run[vRP.getUserId(source)] = resultado.tempo
                        vRP.setUData(tonumber(args[2]), "vRP:vip", json.encode(resultado))
                    end
                end
            elseif vip == "platina" then
                vRP.addUserGroup(nuser_id, "platinum")
                TriggerClientEvent("Notify", source, "sucesso", "ID " .. args[1] .. " setado de Platina pass.")
                if vRP.getUserSource(tonumber(args[2])) then
                    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
                        local consulta = vRP.getUData(tonumber(args[2]), "vRP:vip")
                        local resultado = json.decode(consulta) or {}
                        resultado.tempo = (resultado.tempo or 0) + tonumber(args[4]) * 1440
                        run[vRP.getUserId(source)] = resultado.tempo
                        vRP.setUData(tonumber(args[2]), "vRP:vip", json.encode(resultado))
                    end
                end
            elseif vip == "ouro" then
                vRP.addUserGroup(nuser_id, "gold")
                TriggerClientEvent("Notify", source, "sucesso", "ID " .. args[1] .. " setado de Ouro pass.")
                if vRP.getUserSource(tonumber(args[2])) then
                    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
                        local consulta = vRP.getUData(tonumber(args[2]), "vRP:vip")
                        local resultado = json.decode(consulta) or {}
                        resultado.tempo = (resultado.tempo or 0) + tonumber(args[4]) * 1440
                        run[vRP.getUserId(source)] = resultado.tempo
                        vRP.setUData(tonumber(args[2]), "vRP:vip", json.encode(resultado))
                    end
                end
            elseif vip == "standard" then
                vRP.addUserGroup(nuser_id, "standard")
                TriggerClientEvent("Notify", source, "sucesso", "ID " .. args[1] .. " setado de Standard pass.")
                if vRP.getUserSource(tonumber(args[2])) then
                    if vRP.hasPermission(user_id, "manager.permissao") or vRP.hasPermission(user_id, "administrador.permissao") then
                        local consulta = vRP.getUData(tonumber(args[2]), "vRP:vip")
                        local resultado = json.decode(consulta) or {}
                        resultado.tempo = (resultado.tempo or 0) + tonumber(args[4]) * 1440
                        run[vRP.getUserId(source)] = resultado.tempo
                        vRP.setUData(tonumber(args[2]), "vRP:vip", json.encode(resultado))
                    end
                end
            end
        end
    elseif args[1] == "rem" then
        if vRP.getUserSource(tonumber(args[2])) then
            if vRP.hasPermission(vRP.getUserId(source), "manager.permissao") or vRP.hasPermission(vRP.getUserId(source), "administrador.permissao") then
                local consulta = vRP.getUData(tonumber(args[2]), "vRP:vip")
                local resultado = json.decode(consulta) or {}
                resultado.tempo = (resultado.tempo or 0) - tonumber(args[3]) * 1440
                if resultado.tempo < 0 then resultado.tempo = 0 end
                run[vRP.getUserId(source)] = resultado.tempo
                vRP.setUData(tonumber(args[2]), "vRP:vip", json.encode(resultado))
            end
        end
    elseif args[1] == "status" then
        local user_id = vRP.getUserId(source)
        local consulta = vRP.getUData(vRP.getUserId(source), "vRP:vip")
        local resultado = json.decode(consulta) or {}
        local pass = ""

        if vRP.hasPermission(user_id, "ultimate.permissao") then
            pass = "Ultimate"
        elseif vRP.hasPermission(user_id, "platina.permissao") then
            pass = "Platina"
        elseif vRP.hasPermission(user_id, "ouro.permissao") then
            pass = "Ouro"
        elseif vRP.hasPermission(user_id, "standard.permissao") then
            pass = "Standard"
        end

        resultado.tempo = resultado.tempo or 0
        resultado = resultado.tempo / 1440 or 0

        TriggerClientEvent("Notify", source, "importante", "<b>Pass:</b> " .. pass .. " | <b>Dias Restantes:</b> " .. math.ceil(resultado))
    end
end)


AddEventHandler("vRP:playerJoin",function(user_id,source,name,last_login)
    local identity = vRP.getUserIdentity(user_id)

    if identity and identity.admin then
        vRP.addUserGroup(user_id, "administrador")
    end
end)
