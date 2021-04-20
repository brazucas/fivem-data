local registration_number = "00AAA000"
local public_plate_number = "BRZ00000"

function tvRP.setRegistrationNumber(registration)
	registration_number = registration
end

function tvRP.getRegistrationNumber()
	return registration_number
end

function tvRP.setPublicPlateNumber(public_plate)
	public_plate_number = public_plate
end

function tvRP.getPublicPlateNumber()
	return public_plate_number
end