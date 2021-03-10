function vRP.tryPayment(user_id, amount)
    if amount >= 0 then
        if vRP.getInventoryItemAmount(user_id, "cartaodebito") >= 1 then
            if amount >= 0 and vRP.getInventoryItemAmount(user_id, "dinheiro") >= amount then
                vRP.tryGetInventoryItem(user_id, "dinheiro", amount)
                return true
            else
                local money = vRP.getBankMoney(user_id)
                if amount >= 0 and money >= amount then
                    vRP.setBankMoney(user_id, money - amount)
                    return true
                else
                    return false
                end
            end
        else
            if amount >= 0 and vRP.getInventoryItemAmount(user_id, "dinheiro") >= amount then
                vRP.tryGetInventoryItem(user_id, "dinheiro", amount)
                return true
            else
                return false
            end
        end
    end
    return false
end

function vRP.giveDinheirama(user_id, amount)
    if amount >= 0 then
        vRP.giveInventoryItem(user_id, "dinheiro", amount)
    end
end

function vRP.getMoney(user_id)
    return vRP.getInventoryItemAmount(user_id, "dinheiro")
end

function vRP.getBankMoney(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        return tmp.bank or 0
    else
        return 0
    end
end

function vRP.setBankMoney(user_id, value)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        tmp.bank = value
    end
end

function vRP.giveBankMoney(user_id, amount)
    if amount >= 0 then
        local money = vRP.getBankMoney(user_id)
        vRP.setBankMoney(user_id, money + amount)
    end
end

function vRP.tryWithdraw(user_id, amount)
    local money = vRP.getBankMoney(user_id)
    if amount >= 0 and money >= amount then
        vRP.setBankMoney(user_id, money - amount)
        vRP.giveInventoryItem(user_id, "dinheiro", amount)
        return true
    else
        return false
    end
end

function vRP.tryDeposit(user_id, amount)
    if amount >= 0 and vRP.tryGetInventoryItem(user_id, "dinheiro", amount) then
        vRP.giveBankMoney(user_id, amount)
        return true
    else
        return false
    end
end

AddEventHandler("vRP:playerJoin", function(user_id, source, name)
    local p = promise.new()
    if vRP.getBankMoney(user_id) == 0 then
        exports.mongodb:insertOne({
            collection = "vrp_user_moneys",
            document = {
                user_id = user_id,
                bank = 20000,
            }
        }, function(success, result, insertedIds)
            if success then
                p:resolve(insertedIds[1])
            else
                p:reject("[MongoDB][vRP:playerJoin] Error in insertOne: " .. tostring(result))
            end
        end)
    end
    Citizen.Await(p)

    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        local p2 = promise.new()
        exports.mongodb:findOne({ collection = "vrp_user_moneys", query = { user_id = user_id } }, function(success, results)
            if success then
                p2:resolve(results)
            else
                p2:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
                return
            end
        end)

        local money = Citizen.Await(p2)

        if #money > 0 then
            tmp.bank = money[1].bank
        end
    end
end)

RegisterCommand('savedb', function(source, args, rawCommand)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local tmp = vRP.getUserTmpTable(user_id)
        if tmp and tmp.bank then
            local p = promise.new()
            exports.mongodb:updateOne({ collection = "vrp_user_moneys", query = { user_id = user_id }, update = { ["$set"] = { bank = tmp.bank } } }, function(success, result)
                p:resolve(success)
            end)
            Citizen.Await(p)
        end
        TriggerClientEvent("save:database", source)
        TriggerClientEvent("Notify", source, "importante", "Você salvou todo o conteúdo temporário de sua database.")
    end
end)

AddEventHandler("vRP:playerLeave", function(user_id, source)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp and tmp.bank then
        local p = promise.new()
        exports.mongodb:updateOne({ collection = "vrp_user_moneys", query = { user_id = user_id }, update = { ["$set"] = { bank = tmp.bank } } }, function(success, result)
            p:resolve(success)
        end)
        Citizen.Await(p)
    end
end)

AddEventHandler("vRP:save", function()
    for k, v in pairs(vRP.user_tmp_tables) do
        if v.bank then
            local p = promise.new()
            exports.mongodb:updateOne({ collection = "vrp_user_moneys", query = { user_id = k }, update = { ["$set"] = { bank = v.bank } } }, function(success, result)
                p:resolve(success)
            end)
            Citizen.Await(p)
        end
    end
end)
