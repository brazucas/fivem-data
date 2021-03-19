-- client.lua
function tvRP.CreateNPC(type,model,anim,dict,pos,help,key,range)
    Citizen.CreateThread(function()
      -- Define variables
      local hash = GetHashKey(model)
      local talking = false
  
      -- Loads model
      RequestModel(hash)
      while not HasModelLoaded(hash) do
        Wait(1)
      end
  
      -- Loads animation
      RequestAnimDict(anim)
      while not HasAnimDictLoaded(anim) do
        Wait(1)
      end
      
      -- Creates ped when everything is loaded
      local ped = CreatePed(type, hash, pos.x, pos.y, pos.z, pos.h, true, false)
      SetEntityHeading(ped, pos.h)
      FreezeEntityPosition(ped, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      SetPedCanRagdoll(ped, true)
      SetPedCanRagdollFromPlayerImpact(ped, true)
      TaskPlayAnim(ped,anim,dict, 8.0, 0.0, -1, 1, 0, 0, 0, 0)
      
      -- Process NPC interaction
      while true do
        Citizen.Wait(0)
        local your = GetEntityCoords(GetPlayerPed(-1), false)
        if(Vdist(pos.x, pos.y, pos.z, your.x, your.y, your.z) < range)then
          SetTextComponentFormat("STRING")
          AddTextComponentString(help)
          DisplayHelpTextFromStringLabel(0, 0, 1, -1)
          if(IsControlJustReleased(key[1], key[2]))then
            if not talking then
              talking = true
              start()
            else
              talking = false
              finish()
            end
          end
        end
      end
    end)
  end
  
  -- Ped Types: Player = 1 Male = 4  Female = 5  Cop = 6 Taxi Driver = 25 (sfink) Human = 26 SWAT = 27  Animal = 28 Army = 29
  -- Ped Models: https://wiki.rage.mp/index.php?title=Peds
  -- Animations: https://docs.ragepluginhook.net/html/62951c37-a440-478c-b389-c471230ddfc5.htm (takes awhile to load)
  -- Dict: Usually the last @
  -- Pos: H is for Heading (the direction he is looking), and you can guess what XYZ are.
  -- Help: help text
  -- Key: https://docs.fivem.net/game-references/controls/
  -- Range: distance it can be interacted from
  -- Start: function to start interaction
  -- Finish: function to stop
  
  -- Example:
  CreateNPC(4,"a_m_y_business_01","mini@strip_club@idles@bouncer@base","base",{x = 239.471, y = -1380.96, z = 32.74176, h = 137.6},"Press ~INPUT_CONTEXT~ to interact with ~y~NPC",{1,38},3,
    function()
      Citizen.Wait(500)
      OpenMenu() -- A function to open some menu, could be TriggerEvent or TriggerServerEvent
    end,
    function()
      CloseMenu() -- A function to close some menu, could be TriggerEvent or TriggerServerEvent
    end
  )