AddEventHandler('onClientMapStart',function()
	exports.spawnmanager:setAutoSpawn(true)
	exports.spawnmanager:forceRespawn()
end)

Citizen.CreateThread(function()
	StartAudioScene(“CHARACTER_CHANGE_IN_SKY_SCENE”)
end)
