local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterServerEvent("brzMisc:AutocompleteJogadores")
AddEventHandler("brzMisc:AutocompleteJogadores", function(texto)
    local p = promise.new()
    --{$or: [{name: {$regex: /prem/i}}, {firstname: {$regex: /prem/i}}]}
    print("brzMisc:AutocompleteJogadores buscando pelo texto " .. texto)
    exports.mongodb:find({
        collection = "vrp_user_identities",
        query = {
            ['$or'] = {
                { name = { ["$regex"] = texto, ["$options"] = "i" } },
                { firstname = { ["$regex"] = texto, ["$options"] = "i" } },
            }
        }
    }, function(success, results)
        if success then
            p:resolve(results)
        else
            p:reject("[AutocompleteJogadores] ERROR " .. tostring(result))
            return
        end
    end)
    local results = mapObject(Citizen.Await(p), function(item) return { nome = item.firstname .. item.name, userId = item.user_id } end)

    TriggerClientEvent("brzMisc:AutocompleteJogadores", -1, json.encode(results))
end)
