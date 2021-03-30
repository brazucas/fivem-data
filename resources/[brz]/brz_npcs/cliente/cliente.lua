local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

brzNPC = {}
Tunnel.bindInterface("brz_npcs",brzNPC)
Proxy.addInterface("brz_npcs",brzNPC)
local pizzaBoy = {['hash'] = 0xDB9C0997, ['hash2'] = "s_m_m_linecook"}

local pedlist = {

	-- NPC Pizzaboy;
	{ ['x'] = 18.77592086792, ['y'] = -1345.283203125, ['z'] = 29.288366317749, ['h'] = 88.010803222656, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
	{ ['x'] = 1152.7318115234, ['y'] = -328.36584472656, ['z'] = 69.213195800781, ['h'] = 190.51698303223, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
	{ ['x'] = 369.48782348633, ['y'] = 331.04071044922, ['z'] = 103.53788757324, ['h'] = 72.599563598633, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
    { ['x'] = -716.27093505859, ['y'] = -917.33453369141, ['z'] = 19.214361190796, ['h'] = 186.94891357422, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
    { ['x'] = -46.286445617676, ['y'] = -1762.4307861328, ['z'] = 29.428037643433, ['h'] = 138.60633850098, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
    { ['x'] = -3038.1315917969, ['y'] = 593.65124511719, ['z'] = 7.8186869621277, ['h'] = 293.8173828125, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
    { ['x'] = 1136.9895019531, ['y'] = -976.10974121094, ['z'] = 46.513484954834, ['h'] = 5.1614084243774, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
    { ['x'] = -1496.8245849609, ['y'] = -379.89050292969, ['z'] = 40.533836364746, ['h'] = 133.99449157715, ['hash'] = pizzaBoy.hash, ['hash2'] = pizzaBoy.hash2, ['tipo'] = "pizzaboy" },
}

local pedStorage = {}

Citizen.CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do
			Citizen.Wait(10)
		end
		local ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
		SetBlockingOfNonTemporaryEvents(ped,true)

        table.insert(pedStorage, {['npc'] = ped, ['tipo'] = v.tipo})


	end
end)

function brzNPC.maisProximo(tipo)
    --Citizen.Trace(tipo .. "\n")
    local prevdist = 99999999
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