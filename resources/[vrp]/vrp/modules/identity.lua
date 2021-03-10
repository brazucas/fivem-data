function vRP.getUserIdentity(user_id, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_user_identities", query = { user_id = user_id } }, function(success, results)
        if success then
            if (#results > 0) then
                p:resolve(results[1])
            else
                p:resolve(results)
            end
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)
    return Citizen.Await(p)
end

function vRP.getUserByRegistration(registration, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_user_identities", query = { registration = registration } }, function(success, results)
        if success then
            p:resolve(results)
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    local registration = Citizen.Await(p)

    if registration and #registration > 0 then
        return registration[1].user_id
    end
end

function vRP.getUserByPhone(phone, cbr)
    local p = promise.new()
    exports.mongodb:findOne({ collection = "vrp_user_identities", query = { phone = phone or "" } }, function(success, results)
        if success then
            p:resolve(results)
        else
            p:reject("[vRP.getUserAddress] ERROR " .. tostring(results))
            return
        end
    end)

    local registration = Citizen.Await(p)

    if registration and #registration > 0 then
        return registration[1].user_id
    end
end

function vRP.generateStringNumber(format)
    local abyte = string.byte("A")
    local zbyte = string.byte("0")
    local number = ""
    for i = 1, #format do
        local char = string.sub(format, i, i)
        if char == "D" then number = number .. string.char(zbyte + math.random(0, 9))
        elseif char == "L" then number = number .. string.char(abyte + math.random(0, 25))
        else number = number .. char
        end
    end
    return number
end

function vRP.generateRegistrationNumber(cbr)
    local user_id = nil
    local registration = ""
    repeat
        registration = vRP.generateStringNumber("DDLLLDDD")
        user_id = vRP.getUserByRegistration(registration)
    until not user_id

    return registration
end

function vRP.generatePhoneNumber(cbr)
    local user_id = nil
    local phone = ""

    repeat
        phone = vRP.generateStringNumber("DDD-DDD")
        user_id = vRP.getUserByPhone(phone)
    until not user_id

    return phone
end

function vRP.checkCrimeRecord(user_id)
    local identity = vRP.getUserIdentity(user_id)
    return identity.crimerecord
end

AddEventHandler("vRP:playerJoin", function(user_id, source, name)
    if not vRP.getUserIdentity(user_id) then
        local registration = vRP.generateRegistrationNumber()
        local phone = vRP.generatePhoneNumber()

        local p = promise.new()
        exports.mongodb:insertOne({
            collection = "vrp_user_identities",
            document = {
                user_id = user_id,
                registration = registration,
                phone = phone,
                firstname = "Indigente",
                name = "Individuo",
                age = 21
            }
        }, function(success, result, insertedIds)
            if success then
                p:resolve(insertedIds[1])
            else
                p:reject("[MongoDB][vRP:playerJoin] Error in insertOne: " .. tostring(result))
            end
        end)
        Citizen.Await(p)
    end
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local identity = vRP.getUserIdentity(user_id)
    if identity then
        vRPclient._setRegistrationNumber(source, identity.registration or "AA000AAA")
    end
end)
