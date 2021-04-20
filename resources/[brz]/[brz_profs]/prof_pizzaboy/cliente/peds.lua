PedsPizza = {}
PedsPizza.ClientePizza = nil
PedsPizza.proximoAoCliente = false
PedsPizza.recebeuPizzaCliente = false
PedsPizza.spawnCliente = {}
local currentAnimDict = 'friends@frj@ig_1'
local currentAnimName = ''

function PedsPizza.RemoverClientePizza()
	if DoesEntityExist(PedsPizza.ClientePizza) then DeletePed(PedsPizza.ClientePizza) end
end

function PedsPizza.ExecutarComportamentoCliente(indoEntregarPizza)
	local ped = PlayerPedId()
    --idle = 500
    --Citizen.Trace(tostring(DoesEntityExist(ClientePizza)) .. "\n")
    if not DoesEntityExist(PedsPizza.ClientePizza) then
        --local ped = PlayerPedId()
        PedsPizza.proximoAoCliente = false
        local x,y,z = table.unpack(GetEntityCoords(ped))
        local distancia = Vdist(PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3], x, y, z)
        
        --local distancia = GetDistanceBetweenCoords(spawnCliente, GetEntityCoords(ped), 2)
        --Citizen.Trace(tostring(distancia) .. "\n")
        if distancia < 200 and indoEntregarPizza then
            PedsPizza.CriarClientePizza(math.random(4,5), ConfigPizza.PedSkins[ math.random( #ConfigPizza.PedSkins ) ] )
            BlipsPizza.RemoverBlip()
            BlipsPizza.CreateBlipNPC()
        end
    else
        --local ped = PlayerPedId()
        local x,y,z = table.unpack(GetEntityCoords(ped))
        local distancia = Vdist(PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3], x, y, z)
        if distancia < 30 then
            PedsPizza.proximoAoCliente = true
        else
            PedsPizza.proximoAoCliente = false
        end

        if PedsPizza.proximoAoCliente then
            if not IsPedFacingPed(PedsPizza.ClientePizza, ped, 45.0) then
                --local x,y,z = table.unpack(GetEntityCoords(ped))
                TaskLookAtEntity(PedsPizza.ClientePizza, ped, -1, 2048, 3)
                TaskTurnPedToFaceCoord(PedsPizza.ClientePizza, x, y, z, 2000)
            else
                if not IsEntityPlayingAnim(PedsPizza.ClientePizza, currentAnimDict, currentAnimName, 3) and not PedsPizza.recebeuPizzaCliente then
                    RequestScriptAudioBank("SPEECH_RELATED_SOUNDS", true)
                    SetTimeout(1000,function()
                        if DoesEntityExist(PedsPizza.ClientePizza) then
                            PlaySoundFromEntity(1, "Franklin_Whistle_For_Chop", PedsPizza.ClientePizza, "SPEECH_RELATED_SOUNDS", true, 0)
                        end
                    end)
                    currentAnimDict = 'friends@frj@ig_1'
                    local waveNames = {'wave_a', 'wave_b', 'wave_c', 'wave_d', 'wave_e'}
                    currentAnimName = waveNames[ math.random( #waveNames ) ]
                    vRP._playAnim(false, {{currentAnimDict,currentAnimName}}, false, PedsPizza.ClientePizza)
                    --Citizen.Wait(5)

                elseif not IsEntityPlayingAnim(PedsPizza.ClientePizza, currentAnimDict, currentAnimName, 3) and PedsPizza.recebeuPizzaCliente then
                    local waveNames = {{'anim@mp_player_intcelebrationfemale@thumbs_up','thumbs_up'}, 
                    {'anim@mp_player_intcelebrationfemale@bro_love','bro_love'}, 
                    {'anim@mp_player_intcelebrationfemale@blow_kiss','blow_kiss'}, 
                    {'anim@mp_player_intcelebrationfemale@salute','salute'}}
                    local randomWave = waveNames[ math.random( #waveNames ) ]
                    currentAnimDict = randomWave[1]
                    currentAnimName = randomWave[2]
                    vRP._playAnim(false, {{currentAnimDict,currentAnimName}}, false, PedsPizza.ClientePizza)
                end
            end
        --Citizen.Wait(5)
        else
            if PedsPizza.IsPedNotDoingAnything(PedsPizza.ClientePizza) then
                PedsPizza.SetTaskWalk(PedsPizza.ClientePizza, PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3], 15.0)
                --Citizen.Wait(5000)
            end
        end
    end
end

function PedsPizza.CriarClientePizza(type,model)
    --Citizen.CreateThread(function()
      	-- Define variables
      	local hash = GetHashKey(model)
		--local ped = PlayerPedId()
		PedsPizza.recebeuPizzaCliente = false
  
      	-- Loads model
      	RequestModel(hash)
      	while not HasModelLoaded(hash) do
        	Wait(1)
      	end
      
		-- Creates ped when everything is loaded
		
		local headingCliente = math.random( 0, 180 )
		PedsPizza.ClientePizza = CreatePed(type, hash, PedsPizza.spawnCliente[1], PedsPizza.spawnCliente[2], PedsPizza.spawnCliente[3],headingCliente, true, false)
		--Citizen.Wait(5)
		SetEntityHeading(PedsPizza.ClientePizza, headingCliente)
		FreezeEntityPosition(PedsPizza.ClientePizza, false)
		SetEntityInvincible(PedsPizza.ClientePizza, true)
		SetBlockingOfNonTemporaryEvents(PedsPizza.ClientePizza, true)
		SetPedCanRagdoll(PedsPizza.ClientePizza, false)
		SetPedCanRagdollFromPlayerImpact(PedsPizza.ClientePizza, false)
		--CreateBlipNPC(spawnCliente[1], spawnCliente[2], spawnCliente[3])
		--Citizen.Trace(tostring(DoesEntityExist(PedsPizza.ClientePizza)))
		--while DoesEntityExist(PedsPizza.ClientePizza) do
			
		--end
    --end)
end

function PedsPizza.IsPedNotDoingAnything(ped)
    if IsPedOnFoot(ped) and not IsEntityInWater(ped) then
        if not IsPedSprinting(ped) and not IsPedRunning(ped) and not IsPedWalking(ped) then
            if not GetIsTaskActive(ped, 12) and not GetIsTaskActive(ped, 307) then -- no task like walking around
                if IsPedStill(ped) then
                    return true
                else return false end
            else return false end
        else return false end
    else return false end
end

function PedsPizza.SetTaskWalk(ped, x, y, z, radius)
    --ClearPedTasks(ped)
    TaskWanderInArea(ped, x, y, z, radius, 0.0, math.random( 2,5 ))
end