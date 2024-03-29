local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")

local config = module("cfg/base")

vRP = {}
Proxy.addInterface("vRP", vRP)

tvRP = {}
Tunnel.bindInterface("vRP", tvRP)
vRPclient = Tunnel.getInterface("vRP")

vRP.friendly_ids_inc = 1;
vRP.users = {}
vRP.friendly_ids = {}
vRP.rusers = {}
vRP.user_tables = {}
vRP.user_tmp_tables = {}
vRP.user_sources = {}

local db_drivers = {}
local db_driver
local cached_prepares = {}
local cached_queries = {}
local prepared_queries = {}
local db_initialized = false

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------------------

local logEntrada = ""
local logSaida = ""
local policiaPonto = ""
local resgatePonto = ""
local logAdmStatus = ""

--[ BASE.LUA ]---------------------------------------------------------------------------------------------------------------------------

function vRP.format(n)
    local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1.'):reverse()) .. right
end

function vRP.prepare(name, query)
    prepared_queries[name] = true

    if db_initialized then
        db_driver[2](name, query)
    else
        table.insert(cached_prepares, { name, query })
    end
end

function vRP.query(name, params, mode)
    if not mode then mode = "query" end

    if db_initialized then
        return db_driver[3](name, params or {}, mode)
    else
        local r = async()
        table.insert(cached_queries, { { name, params or {}, mode }, r })
        return r:wait()
    end
end

function vRP.execute(name, params)
    return vRP.query(name, params, "execute")
end

function vRP.getConMaxVehs(user_id)
    local p = promise.new()
    exports.mongodb:count({ collection = "vrp_user_vehicles", query = { user_id = user_id } }, function(success, count)
        if success then
            p:resolve(count)
        else
            p:reject("[vRP.getUserAddress] ERROR ")
            return
        end
    end)

    local count = Citizen.Await(p)

    return count
end

function vRP.addIdentifier(identifier, user_id)
    local p = promise.new()
    exports.mongodb:insertOne({ collection = "vrp_user_ids", document = { identifier = identifier, user_id = user_id } }, function(success, result, insertedIds)
        if success then
            p:resolve(insertedIds[1])
        else
            p:reject("[MongoDB][Example] Error in insertOne: " .. tostring(result))
        end
    end)
    return p
end

function vRP.getEstoque(vehicle)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_estoque", query = { vehicle = vehicle } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    local estoque = Citizen.Await(p)

    return estoque
end

function vRP.countHomePermissions(home)
    local p = promise.new()
    exports.mongodb:count({ collection = "vrp_homes_permissions", query = { home = home } }, function(success, count)
        if success then
            p:resolve(count)
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(count))
            return
        end
    end)

    return Citizen.Await(p)
end

function vRP.getHomePermissions(home)
    local p = promise.new()
    exports.mongodb:find({ collection = "vrp_homes_permissions", query = { home = home } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    return Citizen.Await(p)
end

function vRP.getHomeUserOwner(user_id, home)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_homes_permissions", query = { home = home, user_id = user_id, owner = true } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    return Citizen.Await(p)
end

function vRP.getHomeUser(user_id, home)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_homes_permissions", query = { home = home, user_id = user_id } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    return Citizen.Await(p)
end

function vRP.getHomeUserIdOwner(home)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_homes_permissions", query = { home = home, owner = true } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    return Citizen.Await(p)
end

function vRP.getHomeUserId(user_id)
    local p = promise.new()
    exports.mongodb:find({ collection = "vrp_homes_permissions", query = { user_id = user_id } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    local address = Citizen.Await(p)
    return address or {}
end

function vRP.createUser()
    local p = promise.new()
    exports.mongodb:insertOne({ collection = "vrp_users", document = { whitelisted = false, banned = false } }, function(success, result, insertedIds)
        if success then
            p:resolve(insertedIds[1])
        else
            p:reject("[MongoDB][vRP.createUser] Error in insertOne: " .. tostring(result))
        end
    end)
    return p
end

function vRP.getUserIdByIdentifiers(ids)
    if ids and #ids then
        for i = 1, #ids do
            if (string.find(ids[i], "ip:") == nil) then
                local p = promise.new()
                exports.mongodb:findOne({ collection = "vrp_user_ids", query = { identifier = ids[i] } }, function(success, result)
                    if success then
                        if #result > 0 then
                            p:resolve(result[1].user_id)
                        else
                            p:resolve()
                        end
                    else
                        p:reject("[vRP.getUserIdByIdentifiers] ERROR " .. tostring(result))
                    end
                end)

                local existing_user_id = Citizen.Await(p);

                if (existing_user_id) then
                    return existing_user_id
                end
            end
        end

        local user_id = Citizen.Await(vRP.createUser())

        if (user_id ~= nil) then
            for l, w in pairs(ids) do
                if (string.find(w, "ip:") == nil) then
                    local test = vRP.addIdentifier(w, user_id)
                end
            end
            return user_id
        end
    end
end

function vRP.getPlayerEndpoint(player)
    return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.getPlayerById(user_id)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_users", query = { _id = user_id } }, function(success, result)
        if success then
            if #result > 0 then
                p:resolve(result[1])
            else
                p:resolve()
            end
        else
            p:reject("[vRP.getUserIdByIdentifiers] ERROR " .. tostring(result))
            return
        end
    end)

    return Citizen.Await(p);
end

function vRP.isBanned(user_id, cbr)
    local user = vRP.getPlayerById(user_id);

    if user ~= nil then
        return user.banned
    else
        return false
    end
end

function vRP.setBanned(user_id, banned)
    local p = promise.new()
    exports.mongodb:updateOne({ collection = "vrp_users", query = { _id = user_id }, update = { ["$set"] = { banned = true } } }, function(success, result)
        p:resolve(success)
    end)

    return Citizen.Await(p)
end

function vRP.isWhitelisted(user_id, cbr)
    local user = vRP.getPlayerById(user_id);

    if user ~= nil then
        return user.whitelisted
    else
        return false
    end
end

function vRP.setWhitelisted(user_id, whitelisted)
    local p = promise.new()
    exports.mongodb:updateOne({ collection = "vrp_users", query = { _id = user_id }, update = { ["$set"] = { whitelisted = true } } }, function(success, result)
        p:resolve(success)
    end)

    return Citizen.Await(p)
end

function vRP.setUData(user_id, key, value)
    local p = promise.new()
    local uData = vRP.getUData(user_id, key)

    if string.len(uData) > 0 then
        exports.mongodb:updateOne({ collection = "vrp_user_data", query = { user_id = user_id, dkey = key }, update = { ["$set"] = { dvalue = value } } }, function(success, result)
            p:resolve(success)
        end)
    else
        exports.mongodb:insertOne({ collection = "vrp_user_data", document = { user_id = user_id, dkey = key, dvalue = value } }, function(success, result, insertedIds)
            if success then
                p:resolve(insertedIds[1])
            else
                p:reject("[MongoDB][Example] Error in insertOne: " .. tostring(result))
            end
        end)
    end

    return Citizen.Await(p)
end

function vRP.getUData(user_id, key, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_user_data", query = { user_id = user_id, dkey = key } }, function(success, result)
        if success then
            p:resolve(result[1])
        else
            p:reject("[vRP.getUserIdByIdentifiers] ERROR " .. tostring(result))
            return
        end
    end)

    local uData = Citizen.Await(p);

    if uData ~= nil then
        return uData.dvalue
    else
        return ""
    end
end

function vRP.setSData(key, value)
    local p = promise.new()
    local uData = vRP.getSData(key)

    if string.len(uData) > 0 then
        exports.mongodb:updateOne({ collection = "brz_srv_data", query = { dkey = key }, update = { ["$set"] = { dvalue = value } } }, function(success, result)
            p:resolve(success)
        end)
    else
        exports.mongodb:insertOne({ collection = "brz_srv_data", document = { dkey = key, dvalue = value } }, function(success, result, insertedIds)
            if success then
                p:resolve(insertedIds[1])
            else
                p:reject("[MongoDB][vRP.setSData] Error in insertOne: " .. tostring(result))
            end
        end)
    end

    return Citizen.Await(p)
end

function vRP.getSData(key, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "brz_srv_data", query = { dkey = key } }, function(success, result)
        if success then
            if #result > 0 then
                p:resolve(result[1])
            else
                p:resolve()
            end
        else
            p:reject("[vRP.getSData] ERROR " .. tostring(result))
            return
        end
    end)

    local uData = Citizen.Await(p);

    if uData ~= nil then
        return uData.dvalue
    else
        return ""
    end
end

function vRP.setVData(key, value)
    local p = promise.new()
    local uData = vRP.getVData(key)

    if uData ~= nil then
        exports.mongodb:updateOne({ collection = "brz_vehicles", query = { placa = key }, update = { ["$set"] =  value  } }, function(success, result)
            p:resolve(success)
        end)
    else
        exports.mongodb:insertOne({ collection = "brz_vehicles", document = value }, function(success, result, insertedIds)
            if success then
                p:resolve(insertedIds[1])
            else
                p:reject("[MongoDB][vRP.setVData] Error in insertOne: " .. tostring(result))
            end
        end)
    end

    return Citizen.Await(p)
end

function vRP.getVData(key, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "brz_vehicles", query = { placa = key } }, function(success, result)
        if success then
            if #result > 0 then
                p:resolve(result[1])
            else
                p:resolve()
            end
        else
            p:reject("[vRP.getVData] ERROR " .. tostring(result))
            return
        end
    end)

    local uData = Citizen.Await(p);

    if uData ~= nil then
        return uData
    else
        return nil
    end
end

function vRP.getUserDataTable(user_id)
    return vRP.user_tables[user_id]
end

function vRP.getUserTmpTable(user_id)
    return vRP.user_tmp_tables[user_id]
end

function vRP.getUserId(source)
    if source ~= nil then
        local ids = GetPlayerIdentifiers(source)
        if ids ~= nil and #ids > 0 then
            return vRP.users[ids[1]]
        end
    end
    return nil
end

function vRP.getUsers()
    local users = {}
    for k, v in pairs(vRP.user_sources) do
        users[k] = v
    end
    return users
end

function vRP.getFriendlyIdByUserId(user_id)
    for k, v in pairs(vRP.friendly_ids) do
        if v == user_id then
            return k
        end
    end
end

function vRP.getUserSource(user_id)
    local source = vRP.user_sources[user_id]

    if not source then
        local get_user_id = vRP.friendly_ids[user_id]

        if get_user_id then
            source = vRP.user_sources[get_user_id]
        end
    end

    return source
end

vRP.remove_weapon_table = function(user_id,index)
    if vRP.user_tables[user_id].weapons then
        for k,v in pairs(vRP.user_tables[user_id].weapons) do
            vRP.user_tables[user_id].weapons[index] = nil
        end
        vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))
    end
end

function vRP.kick(source, reason)
    DropPlayer(source, reason)
end

function vRP.dropPlayer(source)
    local source = source
    local user_id = vRP.getUserId(source)
    vRPclient._removePlayer(-1, source)
    if user_id then
        if user_id and source then
            TriggerEvent("vRP:playerLeave", user_id, source)

            PerformHttpRequest(logSaida, function(err, text, headers) end, 'POST', json.encode({
                embeds = {
                    {
                        title = "REGISTRO DE SAIDA:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                        thumbnail = {
                            url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        fields = {
                            {
                                name = "[ ID: **" .. user_id .. "** ][ IP: **" .. GetPlayerEndpoint(source) .. "** ]",
                                value = "⠀\n⠀"
                            }
                        },
                        footer = {
                            text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                            icon_url = "https://i.imgur.com/5ydYKZg.png"
                        },
                        color = 15914080
                    }
                }
            }), { ['Content-Type'] = 'application/json' })

            local identity = vRP.getUserIdentity(user_id)

            if vRP.hasGroup(user_id, "policia") then
                vRP.addUserGroup(user_id, "paisana-policia")

                PerformHttpRequest(policiaPonto, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            title = identity.name .. " saiu de serviço.",
                            description = "Registro de Ponto do Departamento de Polícia de Los Anjos. Registro de saída de serviço.\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**IDENTIFICAÇÃO DO COLABORADOR:**",
                                    value = "**" .. identity.name .. " " .. identity.firstname .. "** [**" .. user_id .. "**]"
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

            elseif vRP.hasGroup(user_id, "ems") then
                vRP.addUserGroup(user_id, "paisana-ems")

                PerformHttpRequest(resgatePonto, function(err, text, headers) end, 'POST', json.encode({
                    embeds = {
                        {
                            title = identity.name .. " saiu de serviço.",
                            description = "Registro de Ponto do Departamento Médico de Los Anjos. Registro de saída de serviço.\n⠀",
                            thumbnail = {
                                url = "https://i.imgur.com/5ydYKZg.png"
                            },
                            fields = {
                                {
                                    name = "**IDENTIFICAÇÃO DO COLABORADOR:**",
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

            elseif vRP.hasGroup(user_id, "manager") then
                vRP.addUserGroup(user_id, "off-manager")
                local cargo = "Manager"

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
                                    name = "**STATUS: **Saiu do modo administrativo.",
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

            elseif vRP.hasGroup(user_id, "administrador") then
                vRP.addUserGroup(user_id, "off-administrador")
                local cargo = "Administrador"

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
                                    name = "**STATUS: **Saiu do modo administrativo.",
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

            elseif vRP.hasGroup(user_id, "moderador") then
                vRP.addUserGroup(user_id, "off-moderador")
                local cargo = "Moderador"

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
                                    name = "**STATUS: **Saiu do modo administrativo.",
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

            elseif vRP.hasGroup(user_id, "suporte") then
                vRP.addUserGroup(user_id, "off-suporte")
                local cargo = "Suporte"

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
                                    name = "**STATUS: **Saiu do modo administrativo.",
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
            end
        end

        vRP.setUData(user_id, "vRP:datatable", json.encode(vRP.getUserDataTable(user_id)))

        vRP.users[vRP.rusers[user_id]] = nil
        vRP.rusers[user_id] = nil
        vRP.user_tables[user_id] = nil
        vRP.user_tmp_tables[user_id] = nil
        vRP.user_sources[user_id] = nil
    end
end

function task_save_datatables()
    SetTimeout(60000, task_save_datatables)
    TriggerEvent("vRP:save")
    for k, v in pairs(vRP.user_tables) do
        vRP.setUData(k, "vRP:datatable", json.encode(v))
    end
end

async(function()
    task_save_datatables()
end)

AddEventHandler("queue:playerConnecting", function(source, ids, name, setKickReason, deferrals)
    deferrals.defer()
    local source = source
    local ids = ids

    print("[SERVER] Jogador conectando: " .. tostring(name))

    if ids ~= nil and #ids > 0 then
        deferrals.update("Carregando identidades.")
        local user_id = vRP.getUserIdByIdentifiers(ids)
        if user_id then
            deferrals.update("Carregando banimentos.")
            if not vRP.isBanned(user_id) then
                deferrals.update("Carregando whitelist.")
                if vRP.isWhitelisted(user_id) then
                    exports.mongodb:updateOne({ collection = "vrp_users", query = { _id = user_id }, update = { ["$set"] = { ip = vRP.getPlayerEndpoint(source), ll = os.date("%H:%M:%S %d/%m/%Y") } } })

                    if vRP.rusers[user_id] == nil then
                        deferrals.update("Carregando banco de dados.")
                        local sdata = vRP.getUData(user_id, "vRP:datatable")

                        vRP.users[ids[1]] = user_id
                        vRP.rusers[user_id] = ids[1]
                        vRP.user_tables[user_id] = {}
                        vRP.user_tmp_tables[user_id] = {}
                        vRP.user_sources[user_id] = source

                        local data = json.decode(sdata)
                        if type(data) == "table" then vRP.user_tables[user_id] = data end

                        local tmpdata = vRP.getUserTmpTable(user_id)
                        tmpdata.spawns = 0

                        vRP.friendly_ids[vRP.friendly_ids_inc] = user_id
                        vRP.friendly_ids_inc = vRP.friendly_ids_inc + 1

                        TriggerEvent("vRP:playerJoin", user_id, source, name)

                        PerformHttpRequest(logEntrada, function(err, text, headers) end, 'POST', json.encode({
                            embeds = {
                                {
                                    title = "REGISTRO DE ENTRADA:⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀\n⠀",
                                    thumbnail = {
                                        url = "https://i.imgur.com/5ydYKZg.png"
                                    },
                                    fields = {
                                        {
                                            name = "[ ID: **" .. user_id .. "** ][ IP: **" .. GetPlayerEndpoint(source) .. "** ]",
                                            value = "⠀\n⠀"
                                        }
                                    },
                                    footer = {
                                        text = "BRZ - " .. os.date("%d/%m/%Y | %H:%M:%S"),
                                        icon_url = "https://i.imgur.com/5ydYKZg.png"
                                    },
                                    color = 15914080
                                }
                            }
                        }), { ['Content-Type'] = 'application/json' })

                        deferrals.done()
                    else
                        local tmpdata = vRP.getUserTmpTable(user_id)
                        tmpdata.spawns = 0

                        TriggerEvent("vRP:playerRejoin", user_id, source, name)
                        deferrals.done()
                    end
                else
                    deferrals.done("Esse é o servidor de desenvolvimento! [ ID: " .. user_id .. " ]")
                    TriggerEvent("queue:playerConnectingRemoveQueues", ids)
                end
            else
                deferrals.done("Você foi banido! [ Mais informações em:  ] ")
                TriggerEvent("queue:playerConnectingRemoveQueues", ids)
            end
        else
            deferrals.done("Ocorreu um problema de identificação.")
            TriggerEvent("queue:playerConnectingRemoveQueues", ids)
        end
    else
        deferrals.done("Ocorreu um problema de identidade.")
        TriggerEvent("queue:playerConnectingRemoveQueues", ids)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source

    local user_id = vRP.getUserId(source)

    for k, v in pairs(vRP.friendly_ids) do
        if v == user_id then
            vRP.friendly_ids[k] = nil
        end
    end

    vRP.dropPlayer(source)
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.user_sources[user_id] = source
        local tmp = vRP.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)

        if first_spawn then
            for k, v in pairs(vRP.user_sources) do
                vRPclient._addPlayer(source, v)
            end
            vRPclient._addPlayer(-1, source)
            Tunnel.setDestDelay(source, 0)
        end
        TriggerEvent("vRP:playerSpawn", user_id, source, first_spawn)
    end
end)

function vRP.getDayHours(seconds)
    local days = math.floor(seconds / 86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds / 3600)

    if days > 0 then
        return string.format("<b>%d Dias</b> e <b>%d Horas</b>", days, hours)
    else
        return string.format("<b>%d Horas</b>", hours)
    end
end

function vRP.getMinSecs(seconds)
    local days = math.floor(seconds / 86400)
    seconds = seconds - days * 86400
    local hours = math.floor(seconds / 3600)
    seconds = seconds - hours * 3600
    local minutes = math.floor(seconds / 60)
    seconds = seconds - minutes * 60

    if minutes > 0 then
        return string.format("<b>%d Minutos</b> e <b>%d Segundos</b>", minutes, seconds)
    else
        return string.format("<b>%d Segundos</b>", seconds)
    end
end

function vRP.DistanceBetweenCoords(coordsA, coordsB, useZ)
    -- language faster equivalent:
    local firstVec = vector3(coordsA.x, coordsA.y, coordsA.z)
    local secondVec = vector3(coordsB.x, coordsB.y, coordsB.z)
    if useZ then
        return #(firstVec - secondVec)
    else 
        return #(firstVec.xy - secondVec.xy)
    end
end
