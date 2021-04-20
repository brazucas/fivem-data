local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

brzNPC = {}
Tunnel.bindInterface("brz_npcs",brzNPC)
Proxy.addInterface("brz_npcs",brzNPC)

local pedStorage = {}

Citizen.CreateThread(function()
    for k,v in pairs(ConfigNpcs.PedList) do
        for l,b in pairs(v.pos) do
            RequestModel(GetHashKey(v.hash2))
            while not HasModelLoaded(GetHashKey(v.hash2)) do
                Citizen.Wait(10)
            end
            --Citizen.Trace(tostring(l.y) .. "\n")
            local ped = CreatePed(4,v.hash,b.x,b.y,b.z-1,b.h,false,true)
            FreezeEntityPosition(ped,true)
            SetEntityInvincible(ped,true)
            SetBlockingOfNonTemporaryEvents(ped,true)
    
            table.insert(pedStorage, {['npc'] = ped, ['tipo'] = v.tipo})
        end
	end
end)

function brzNPC.maisProximo(tipo, range)
    --Citizen.Trace(tipo .. "\n")
    local prevdist = 99999999
    if range then prevdist = range end
    local pedProximo = 0
    local ped = PlayerPedId()
    local x,y,z = table.unpack(GetEntityCoords(ped))
    for k,v in pairs(pedStorage) do
		if v.tipo == tipo then
            local x2,y2,z2 = table.unpack(GetEntityCoords(v.npc))
            --Citizen.Trace(tostring(x2) .. "\n")
            local dist = CalculateTravelDistanceBetweenPoints(x, y, z, x2, y2, z2)
            if dist < prevdist then
                prevdist = dist;
                pedProximo = v.npc
            end
        end
	end
    return pedProximo
end