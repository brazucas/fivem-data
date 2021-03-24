
RegisterCommand('coords', function(source, args, rawCommand)
	local ped = PlayerPedId()
	local coords = GetEntityCoords(PlayerPedId())
	SendNUIMessage({
		coords = ""..coords.x..","..coords.y..","..coords.z..", HEADING: "..GetEntityHeading(ped)..""
	})
end)