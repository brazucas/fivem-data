AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
