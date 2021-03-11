function TchatGetMessageChannel(channel, cb)
    local p = promise.new()
    exports.mongodb:find({ collection = "phone_app_chat", query = { channel = channel } }, function(success, results)
        if success then
            p:resolve(results or {})
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(result))
            return
        end
    end)
    return Citizen.Await(p)
end

function TchatAddMessage(channel, message)
    local p = promise.new()
    exports.mongodb:insertOne({
        collection = "phone_app_chat",
        document = {
            channel = channel,
            message = message,
        }
    }, function(success, result, insertedIds)
        if success then
            p:resolve(insertedIds[1])
        else
            p:reject("[MongoDB] ERROR " .. tostring(result))
        end
    end)
    local id = Citizen.Await(p)

    local p2 = promise.new()
    exports.mongodb:find({ collection = "phone_app_chat", query = { _id = id } }, function(success, results)
        if success then
            p2:resolve(results)
        else
            p2:reject("[vRP.getUserAddress] ERROR " .. tostring(result))
            return
        end
    end)
    TriggerClientEvent('gcPhone:tchat_receive', -1, Citizen.Await(p2)[1])
end

RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
    local sourcePlayer = tonumber(source)
    TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel, TchatGetMessageChannel(channel))
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
    TchatAddMessage(channel, message)
end)
