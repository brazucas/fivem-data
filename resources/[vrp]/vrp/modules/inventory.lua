local itemlist = {
	["mochila"] = { index = "mochila", nome = "Mochila", type = "usar" },
	["celular"] = { index = "celular", nome = "iFruit XI", type = "usar" },
	["celular-pro"] = { index = "celular-pro", nome = "iFruit XII", type = "usar" },
	["jbl"] = { index = "jbl", nome = "JBL", type = "usar" },
	["calculadora"] = { index = "calculadora", nome = "Calculadora", type = "usar" },
	["tablet"] = { index = "tablet", nome = "Tablet", type = "usar" },
	["notebook"] = { index = "notebook", nome = "Notebook", type = "usar" },
	["controleremoto"] = { index = "controleremoto", nome = "Controle remoto", type = "usar" },
	["baterias"] = { index = "baterias", nome = "Baterias", type = "usar" },
	["radio"] = { index = "radio", nome = "WalkTalk", type = "usar" },
	["mascara"] = { index = "mascara", nome = "Mascara", type = "usar" },
	["oculos"] = { index = "oculos", nome = "Óculos", type = "usar" },
	["passaporte"] = { index = "passaporte", nome = "Passaporte", type = "usar" },
	["portearmas"] = { index = "portearmas", nome = "Porte de Armas", type = "usar" },
	["identidade"] = { index = "identidade", nome = "Identidade", type = "usar" },
	["cnh"] = { index = "cnh", nome = "CNH", type = "usar" },
	["colete"] = { index = "colete", nome = "Colete Balístico", type = "usar" },
	["repairkit"] = { index = "repairkit", nome = "Kit de Reparos", type = "usar" },
	["dinheiro"] = { index = "dinheiro", nome = "Dinheiro", type = "usar" },
	["cartao-debito"] = { index = "cartao-debito", nome = "Cartão de débito", type = "usar" },
	["maquininha"] = { index = "maquininha", nome = "Maquininha", type = "usar" },
	["paninho"] = { index = "paninho", nome = "Pano de Microfibra", type = "usar" },

	["drone-basic1"] = { index = "drone-basic1", nome = "Drone Basico", type = "usar" },
	["drone-basic2"] = { index = "drone-basic2", nome = "Drone Basico", type = "usar" },
	["drone-basic3"] = { index = "drone-basic3", nome = "Drone Basico", type = "usar" },
	["drone-advanced1"] = { index = "drone-advanced1", nome = "Drone Avancado", type = "usar" },
	["drone-advanced2"] = { index = "drone-advanced2", nome = "Drone Avancado", type = "usar" },
	["drone-advanced3"] = { index = "drone-advanced3", nome = "Drone Avancado", type = "usar" },
	["drone-police"] = { index = "drone-police", nome = "Drone da Policia", type = "usar" },
	["carrinho"] = { index = "carrinho", nome = "Carrinho", type = "usar" },

	["camisinha"] = { index = "camisinha", nome = "Camisinha", type = "usar" },
	["vibrador"] = { index = "vibrador", nome = "Vibrador", type = "usar" },
	["kit"] = { index = "kit", nome = "Kit de Sex Shop", type = "usar" },

	--[ Illegal Utilities ]--------------------------------------------------------------------------------------------

	["dinheiro-sujo"] = { index = "dinheiro-sujo", nome = "Dinheiro", type = "usar" },
	["algema"] = { index = "algema", nome = "Algema", type = "usar" },
	["lockpick"] = { index = "lockpick", nome = "Lockpick", type = "usar" },
	["capuz"] = { index = "capuz", nome = "Capuz", type = "usar" },
	["placa"] = { index = "placa", nome = "Placa", type = "usar" },
	
	--[ Tools ] -------------------------------------------------------------------------------------------------------
	
	["serra"] = { index = "serra", nome = "Serra", type = "usar" },
	["furadeira"] = { index = "furadeira", nome = "Furadeira", type = "usar" },
	["pa-jardinagem"] = { index = "pa-jardinagem", nome = "Pá de Jardinagem", type = "usar" },

	--[ Miscs ]-------------------------------------------------------------------------------------------------------- 

	["garrafa-vazia"] = { index = "garrafa-vazia", nome = "Garrafa vazia", type = "usar" },
	["ponta-britadeira"] = { index = "ponta-britadeira", nome = "Ponta de britadeira", type = "usar" },

	--[ Miner Work ]-------------------------------------------------------------------------------------------------------- 

	["minerio-diamante"] = { index = "minerio-diamante", nome = "Minerio de Diamante", type = "usar" },
	["minerio-ouro"] = { index = "minerio-ouro", nome = "Minerio de Ouro", type = "usar" },
	["minerio-prata"] = { index = "minerio-prata", nome = "Minerio de Prata", type = "usar" },
	["minerio-prata"] = { index = "minerio-ferro", nome = "Minerio de Ferro", type = "usar" },


	["diamante"] = { index = "diamante", nome = "Diamante Bruto", type = "usar" },
	["barra-ouro"] = { index = "barra-ouro", nome = "Barra de Ouro", type = "usar" },
	["barra-prata"] = { index = "barra-prata", nome = "Barra de Prata", type = "usar" },
	["barra-ferro"] = { index = "barra-ferro", nome = "Barra de Ferro", type = "usar" },

	--[ Drinks ]-------------------------------------------------------------------------------------------------------
	
	["agua"] = { index = "agua", nome = "Água", type = "usar" },
	["leite"] = { index = "leite", nome = "Leite", type = "usar" },
	["cafe"] = { index = "cafe", nome = "Café", type = "usar" },
	["cafecleite"] = { index = "cafecleite", nome = "Café com Leite", type = "usar" },
	["cafeexpresso"] = { index = "cafeexpresso", nome = "Café Expresso", type = "usar" },
	["capuccino"] = { index = "capuccino", nome = "Capuccino", type = "usar" },
	["frappuccino"] = { index = "frappuccino", nome = "Frapuccino", type = "usar" },
	["cha"] = { index = "cha", nome = "Chá", type = "usar" },
	["icecha"] = { index = "icecha", nome = "Chá Gelado", type = "usar" },
	["sprunk"] = { index = "sprunk", nome = "Sprunk", type = "usar" },
	["cola"] = { index = "cola", nome = "Cola", type = "usar" },
	["energetico"] = { index = "energetico", nome = "Energético", type = "usar" },
	
	--[ Alcoholic Beverages ]------------------------------------------------------------------------------------------
	
	["pibwassen"] = { index = "pibwassen", nome = "PibWassen", type = "usar" },
	["tequilya"] = { index = "tequilya", nome = "Tequilya", type = "usar" },
	["patriot"] = { index = "patriot", nome = "Patriot", type = "usar" },
	["blarneys"] = { index = "blarneys", nome = "Blarneys", type = "usar" },
	["jakeys"] = { index = "jakeys", nome = "Jakeys", type = "usar" },
	["barracho"] = { index = "barracho", nome = "Barracho", type = "usar" },
	["ragga"] = { index = "ragga", nome = "Ragga", type = "usar" },
	["nogo"] = { index = "nogo", nome = "Nogo", type = "usar" },
	["mount"] = { index = "mount", nome = "Mount", type = "usar" },
	["cherenkov"] = { index = "cherenkov", nome = "Cherenkov", type = "usar" },
	["bourgeoix"] = { index = "bourgeoix", nome = "Bourgeoix", type = "usar" },
	["bleuterd"] = { index = "bleuterd", nome = "Bleuterd", type = "usar" },
	
	--[ FastFoods ]----------------------------------------------------------------------------------------------------
	
	["sanduiche"] = { index = "sanduiche", nome = "Sanduíche", type = "usar" },
	["rosquinha"] = { index = "rosquinha", nome = "Rosquinha", type = "usar" },
	["hotdog"] = { index = "hotdog", nome = "HotDog", type = "usar" },
	["xburguer"] = { index = "xburguer", nome = "xBurguer", type = "usar" },
	["chips"] = { index = "chips", nome = "Batata Chips", type = "usar" },
	["batataf"] = { index = "batataf", nome = "Batata Frita", type = "usar" },
	["pizza"] = { index = "pizza", nome = "Pedaço de Pizza", type = "usar" },
	["frango"] = { index = "frango", nome = "Frango Frito", type = "usar" },
	["bcereal"] = { index = "bcereal", nome = "Barra de Cereal", type = "usar" },
	["bchocolate"] = { index = "bchocolate", nome = "Barra de Chocolate", type = "usar" },
	["taco"] = { index = "taco", nome = "Taco", type = "usar" },
	
	--[ Drugs ]--------------------------------------------------------------------------------------------------------
	
	["paracetamil"] = { index = "paracetamil", nome = "Paracetamil", type = "usar" },
	["voltarom"] = { index = "voltarom", nome = "Voltarom", type = "usar" },
	["trandrylux"] = { index = "trandrylux", nome = "Trandrylux", type = "usar" },
	["dorfrex"] = { index = "dorfrex", nome = "Dorfrex", type = "usar" },
	["buscopom"] = { index = "buscopom", nome = "Buscopom", type = "usar" },
	
	--[ Prescription ]-------------------------------------------------------------------------------------------------
	
	["r-paracetamil"] = { index = "r-paracetamil", nome = "Receituário Paracetamil", type = "usar" },
	["r-voltarom"] = { index = "r-voltarom", nome = "Receituário Voltarom", type = "usar" },
	["r-trandrylux"] = { index = "r-trandrylux", nome = "Receituário Trandrylux", type = "usar" },
	["r-dorfrex"] = { index = "r-dorfrex", nome = "Receituário Dorfrex", type = "usar" },
	["r-buscopom"] = { index = "r-buscopom", nome = "Receituário Buscopom", type = "usar" },
	
	--[ By-product ][ Methamphetamine production ]---------------------------------------------------------------------

	["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina", type = "usar" },
	["composito"] = { index = "composito", nome = "Compósito", type = "usar" },

	--[ Miscellaneous ][ Methamphetamine production ]------------------------------------------------------------------
	
	["nitrato-amonia"] = { index = "nitrato-amonia", nome = "Nitrato de Amônia", type = "usar" },
	["hidroxido-sodio"] = { index = "hidroxido-sodio", nome = "Hidróxido de Sódio", type = "usar" },
	["pseudoefedrina"] = { index = "pseudoefedrina", nome = "Pseudoefedrina", type = "usar" },
	["eter"] = { index = "eter", nome = "Éter", type = "usar" },
	
	--[ By-product ][ Cocaine production ]-----------------------------------------------------------------------------

	["cocaina"] = { index = "cocaina", nome = "Cocaína", type = "usar" },
	["pasta-base"] = { index = "pasta-base", nome = "Pasta Base", type = "usar" },

	--[ Miscellaneous ][ Cocaine production ]--------------------------------------------------------------------------

	["acido-sulfurico"] = { index = "acido-sulfurico", nome = "Ácido Sulfúrico", type = "usar" },
	["folhas-coca"] = { index = "folhas-coca", nome = "Folhas de Coca", type = "usar" },
	["calcio-po"] = { index = "calcio-po", nome = "Cálcio em Pó", type = "usar" },
	["querosene"] = { index = "querosene", nome = "Querosene", type = "usar" },
	
	--[ By-product ][ Marijuana production ]-----------------------------------------------------------------------------

	["marijuana"] = { index = "marijuana", nome = "Marijuana", type = "usar" },

	--[ Miscellaneous ][ Marijuana production ]--------------------------------------------------------------------------

	["folha-marijuana"] = { index = "folha-marijuana", nome = "Folha de Marijuana", type = "usar" },
	
	--[ Weapons body ][ Weapons Production ]---------------------------------------------------------------------------
	
	["corpo-fuzil"] = { index = "corpo-fuzil", nome = "Corpo de Fuzil", type = "usar" },
	["corpo-smg"] = { index = "corpo-smg", nome = "Corpo de SMG", type = "usar" },
	["corpo-pistola"] = { index = "corpo-pistola", nome = "Corpo de Pistola", type = "usar" },

	--[ Miscellaneous ][ Weapons Production ]--------------------------------------------------------------------------
	
	["molas"] = { index = "molas", nome = "Molas", type = "usar" },
	["placa-metal"] = { index = "placa-metal", nome = "Placa de Metal", type = "usar" },
	["gatilho"] = { index = "gatilho", nome = "Gatilho", type = "usar" },
	["capsulas"] = { index = "capsulas", nome = "Capsulas", type = "usar" },
	["polvora"] = { index = "polvora", nome = "Polvora", type = "usar" },

	--[ Emprego ][ Leiteiro ]------------------------------------------------------------------------------------------

	["garrafa-leite"] = { index = "garrafa-leite", nome = "Garrafa com Leite", type = "usar" },

	--[ Emprego ][ Pescador ]------------------------------------------------------------------------------------------

	["isca"] = { index = "isca", nome = "Iscas de Pesca", type = "usar" },

	--[ Emprego ][ Lenhador ]------------------------------------------------------------------------------------------

	["tora"] = { index = "tora", nome = "Tora de Madeira", type = "usar" },

	--[ Emprego ][ Lixeiro ]------------------------------------------------------------------------------------------

	["saco-lixo"] = {index = "saco-lixo", nome = "Saco de Lixo", type = "usar" },

	--[ Emprego ][ Carteiro ]------------------------------------------------------------------------------------------

	["encomenda"] = { index = "encomenda", nome = "Encomenda", type = "usar" },
	["caixa-vazia"] = { index = "caixa-vazia", nome = "Caixa Vazia", type = "usar" },

	--[ Emprego ][ Transporter ]------------------------------------------------------------------------------------------

	["malote"] = { index = "malote", nome = "Malote de Dinheiro", type = "usar" },

	--[ Emprego ][ Farmer ]------------------------------------------------------------------------------------------

	["semente-marijuana"] = { index = "semente-maconha", nome = "Sementes Genericas", type = "usar" },
	["semente-blueberry"] = { index = "semente-blueberry", nome = "Sementes de Blueberry", type = "usar" },
	["semente-tomate"] = { index = "semente-tomate", nome = "Semente de Tomate", type = "usar" },
	["semente-laranja"] = { index = "semente-laranja", nome = "Semente de Laranja", type = "usar" },
	
	["laranja"] = { index = "laranja", nome = "Laranja", type = "usar" },
	["tomate"] = { index = "tomate", nome = "Tomate", type = "usar" },
	["blueberry"] = { index = "blueberry", nome = "Blueberry", type = "usar" },

	--[ Desmanche ]------------------------------------------------------------------------------------------

	["transmissao"] = { index = "transmissao", nome = "Transmissao", type = "usar" },
	["suspensao"] = { index = "suspensao", nome = "Suspensao", type = "usar" },
	["portas"] = { index = "portas", nome = "Portas", type = "usar" },
	["borrachas"] = { index = "borrachas", nome = "Borrachas", type = "usar" },
	["pneus"] = { index = "pneus", nome = "Pneus", type = "usar" },
	["capo"] = { index = "capo", nome = "Capo", type = "usar" },
	["bateria-carro"] = { index = "bateria-carro", nome = "Bateria de Carro", type = "usar" },
	["motor"] = { index = "motor", nome = "Motor", type = "usar" },

	--[ Itens danificados ]--------------------------------------------------------------------------------------------

	["celular-queimado"] = { index = "celular-queimado", nome = "Celular queimado", type = "usar" },
	["jbl-queimada"] = { index = "jbl-queimada", nome = "JBL queimada", type = "usar" },
	["calculadora-queimada"] = { index = "calculadora-queimada", nome = "Calculadora queimada", type = "usar" },
	["tablet-queimado"] = { index = "tablet-queimado", nome = "Tablet queimado", type = "usar" },
	["notebook-queimado"] = { index = "notebook-queimado", nome = "Notebook queimado", type = "usar" },
	["controleremoto-queimado"] = { index = "controleremoto-queimado", nome = "Controle remoto queimado", type = "usar" },
	["baterias-queimadas"] = { index = "baterias-queimadas", nome = "Baterias queimadas", type = "usar" },
	["radio-queimado"] = { index = "radio-queimado", nome = "Rádio queimado", type = "usar" },
	["maquininha-queimada"] = { index = "maquininha-queimada", nome = "Maquininha queimada", type = "usar" },

	--[ Weapons ][ Melee]----------------------------------------------------------------------------------------------

	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar" },
	["wbody|WEAPON_BAT"] = { index = "tacobaseball", nome = "Taco de Baseball", type = "equipar" },
	["wbody|WEAPON_BOTTLE"] = { index = "garrafaquebrada", nome = "Garrafa quebrada", type = "equipar" },
	["wbody|WEAPON_CROWBAR"] = { index = "pecabra", nome = "Pé de Cabra", type = "equipar" },
	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar" },
	["wbody|WEAPON_GOLFCLUB"] = { index = "tacogolf", nome = "Taco de Golf", type = "equipar" },
	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar" },
	["wbody|WEAPON_WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar" },
	["wbody|WEAPON_WEAPON_KNUCKLES"] = { index = "socoingles", nome = "Soco Inglês", type = "equipar" },
	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar" },
	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Taco de Baseball", type = "equipar" },
	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar" },
	["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete", type = "equipar" },
	["wbody|WEAPON_WHENCH"] = { index = "grifo", nome = "Grifo", type = "equipar" },
	["wbody|WEAPON_BATTLEAXE"] = { index = "machadodebatalha", nome = "Machado De Batalha", type = "equipar" },
	["wbody|WEAPON_POOLCUE"] = { index = "tacosinuca", nome = "Taco de Sinuca", type = "equipar" },
	["wbody|WEAPON_STONE_HATCHET"] = { index = "machadopedra", nome = "Machado de Pedra", type = "equipar" },

	--[ Handguns ][ Weapons ]------------------------------------------------------------------------------------------

	["wbody|WEAPON_PISTOL"] = { index = "pt92af", nome = "PT92AF", type = "equipar" },
	["wbody|WEAPON_PISTOL_MK2"] = { index = "czp09", nome = "CZ P-09", type = "equipar" },
	["wbody|WEAPON_COMBATPISTOL"] = { index = "px4", nome = "Px4", type = "equipar" },
	["wbody|WEAPON_APPISTOL"] = { index = "x2e1911", nome = "XSE 1911", type = "equipar" },
	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser", type = "equipar" },
	["wbody|WEAPON_PISTOL50"] = { index = "derserteagle", nome = "Desert Eagle", type = "equipar" },
	["wbody|WEAPON_SNSPISTOL"] = { index = "waltherppk", nome = "Walther PPK", type = "equipar" },
	["wbody|WEAPON_SNSPISTOL_MK2"] = { index = "waltherppk2", nome = "Walther PPK2", type = "equipar" },
	["wbody|WEAPON_HEAVYPISTOL"] = { index = "wide1911", nome = "Wide 1911", type = "equipar" },
	["wbody|WEAPON_VINTAGEPISTOL"] = { index = "fn1903", nome = "FN 1903", type = "equipar" },
	["wbody|WEAPON_FLAREGUN"] = { index = "sinalizador", nome = "Sinalizador", type = "equipar" },
	["wbody|WEAPON_MARKSMANPISTOL"] = { index = "musketpistol", nome = "Musket Pistol", type = "equipar" },
	["wbody|WEAPON_REVOLVER"] = { index = "asgco2", nome = "ASG CO2", type = "equipar" },
	["wbody|WEAPON_REVOLVER_MK2"] = { index = "ragingbull", nome = "Raging Bull", type = "equipar" },
	["wbody|WEAPON_DOUBLEACTION"] = { index = "python", nome = "Python", type = "equipar" },
	["wbody|WEAPON_RAYPISTOL"] = { index = "raypistol", nome = "Raypistol", type = "equipar" }, --[ Admin Gun ]--------
	["wbody|WEAPON_CERAMICPISTOL"] = { index = "kochp7", nome = "Koch P7", type = "equipar" },
	["wbody|WEAPON_NAVYREVOLVER"] = { index = "colt1851", nome = "Colt 1851", type = "equipar" },

	--[ Handguns ][ Ammo ]---------------------------------------------------------------------------------------------

	["wammo|WEAPON_PISTOL"] = { index = "m-pt92af", nome = "M-PT92AF", type = "recarregar" },
	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-czp09", nome = "M-CZ P-09", type = "recarregar" },
	["wammo|WEAPON_COMBATPISTOL"] = { index = "m-px4", nome = "M-Px4", type = "recarregar" },
	["wammo|WEAPON_APPISTOL"] = { index = "m-x2e1911", nome = "M-XSE 1911", type = "recarregar" },
	["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M-Taser", type = "recarregar" },
	["wammo|WEAPON_PISTOL50"] = { index = "m-derserteagle", nome = "M-Desert Eagle", type = "recarregar" },
	["wammo|WEAPON_SNSPISTOL"] = { index = "m-waltherppk", nome = "M-Walther PPK", type = "recarregar" },
	["wammo|WEAPON_SNSPISTOL_MK2"] = { index = "m-waltherppk2", nome = "M-Walther PPK2", type = "recarregar" },
	["wammo|WEAPON_HEAVYPISTOL"] = { index = "m-wide1911", nome = "M-Wide 1911", type = "recarregar" },
	["wammo|WEAPON_VINTAGEPISTOL"] = { index = "m-fn1903", nome = "M-FN 1903", type = "recarregar" },
	["wammo|WEAPON_FLAREGUN"] = { index = "m-sinalizador", nome = "M-Sinalizador", type = "recarregar" },
	["wammo|WEAPON_MARKSMANPISTOL"] = { index = "m-musketpistol", nome = "M-Musket Pistol", type = "recarregar" },
	["wammo|WEAPON_REVOLVER"] = { index = "m-asgco2", nome = "M-ASG CO2", type = "recarregar" },
	["wammo|WEAPON_REVOLVER_MK2"] = { index = "m-ragingbull", nome = "M-Raging Bull", type = "recarregar" },
	["wammo|WEAPON_DOUBLEACTION"] = { index = "m-python", nome = "M-Python", type = "recarregar" },
	["wammo|WEAPON_RAYPISTOL"] = { index = "m-raypistol", nome = "M-Raypistol", type = "recarregar" }, --[ Admin Gun ]-
	["wammo|WEAPON_CERAMICPISTOL"] = { index = "m-kochp7", nome = "M-Koch P7", type = "recarregar" },
	["wammo|WEAPON_NAVYREVOLVER"] = { index = "m-colt1851", nome = "M-Colt 1851", type = "recarregar" },

	--[ Submachine Guns ][ Weapons ]-----------------------------------------------------------------------------------

	["wbody|WEAPON_MICROSMG"] = { index = "microuzi", nome = "Micro Uzi", type = "equipar" },
	["wbody|WEAPON_SMG"] = { index = "mp5", nome = "MP5", type = "equipar" },
	["wbody|WEAPON_SMG_MK2"] = { index = "mp5k", nome = "MP5K", type = "equipar" },
	["wbody|WEAPON_ASSAULTSMG"] = { index = "p90", nome = "P90", type = "equipar" },
	["wbody|WEAPON_COMBATPDW"] = { index = "mpxsd", nome = "MPX-SD", type = "equipar" },
	["wbody|WEAPON_MACHINEPISTOL"] = { index = "tecdc9", nome = "TEC-DC9", type = "equipar" },
	["wbody|WEAPON_MINISMG"] = { index = "vz82", nome = "VZ.82", type = "equipar" },
	["wbody|WEAPON_RAYCARBINE"] = { index = "raycarbine", nome = "Ray Carbine", type = "equipar" },

	--[ Submachine Guns ][ Ammo ]--------------------------------------------------------------------------------------

	["wammo|WEAPON_MICROSMG"] = { index = "m-microuzi", nome = "M-Micro Uzi", type = "recarregar" },
	["wammo|WEAPON_SMG"] = { index = "m-mp5", nome = "M-MP5", type = "recarregar" },
	["wammo|WEAPON_SMG_MK2"] = { index = "m-mp5k", nome = "M-MP5K", type = "recarregar" },
	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-p90", nome = "M-P90", type = "recarregar" },
	["wammo|WEAPON_COMBATPDW"] = { index = "m-mpxsd", nome = "M-MPX-SD", type = "recarregar" },
	["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tecdc9", nome = "M-TEC-DC9", type = "recarregar" },
	["wammo|WEAPON_MINISMG"] = { index = "m-vz82", nome = "M-VZ.82", type = "recarregar" },
	["wammo|WEAPON_RAYCARBINE"] = { index = "m-raycarbine", nome = "M-Ray Carbine", type = "recarregar" },

	--[ Shotguns ][ Weapons ]------------------------------------------------------------------------------------------

	["wbody|WEAPON_PUMPSHOTGUN"] = { index = "mossberg590", nome = "Mossberg 590", type = "equipar" },
	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { index = "remington870", nome = "Remington 870", type = "equipar" },
	["wbody|WEAPON_SAWNOFFSHOTGUN"] = { index = "mossberg500", nome = "Mossberg 500", type = "equipar" },
	["wbody|WEAPON_ASSAULTSHOTGUN"] = { index = "uts15", nome = "UTS-15", type = "equipar" },
	["wbody|WEAPON_BULLPUPSHOTGUN"] = { index = "keltecksg", nome = "Kel-Tec KSG ", type = "equipar" },
	["wbody|WEAPON_MUSKET"] = { index = "musket", nome = "Musket", type = "equipar" },
	["wbody|WEAPON_HEAVYSHOTGUN"] = { index = "saiga12", nome = "Saiga 12", type = "equipar" },
	["wbody|WEAPON_DBSHOTGUN"] = { index = "zabala", nome = "Zabala", type = "equipar" },
	["wbody|WEAPON_AUTOSHOTGUN"] = { index = "armselprotecta", nome = "Armsel Protecta", type = "equipar" },

	--[ Shotguns ][ Ammo ]---------------------------------------------------------------------------------------------

	["wammo|WEAPON_PUMPSHOTGUN"] = { index = "m-mossberg590", nome = "M-Mossberg 590", type = "recarregar" },
	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { index = "m-remington870", nome = "M-Remington 870", type = "recarregar" },
	["wammo|WEAPON_SAWNOFFSHOTGUN"] = { index = "m-mossberg500", nome = "M-Mossberg 500", type = "recarregar" },
	["wammo|WEAPON_ASSAULTSHOTGUN"] = { index = "m-uts15", nome = "M-UTS-15", type = "recarregar" },
	["wammo|WEAPON_BULLPUPSHOTGUN"] = { index = "m-keltecksg", nome = "M-Kel-Tec KSG ", type = "recarregar" },
	["wammo|WEAPON_MUSKET"] = { index = "m-musket", nome = "M-Musket", type = "recarregar" },
	["wammo|WEAPON_HEAVYSHOTGUN"] = { index = "m-saiga12", nome = "M-Saiga 12", type = "recarregar" },
	["wammo|WEAPON_DBSHOTGUN"] = { index = "m-zabala", nome = "M-Zabala", type = "recarregar" },
	["wammo|WEAPON_AUTOSHOTGUN"] = { index = "m-armselprotecta", nome = "M-Armsel Protecta", type = "recarregar" },

	--[ Assault Rifles ][ Weapons ]------------------------------------------------------------------------------------

	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak74", nome = "AK-74", type = "equipar" },
	["wbody|WEAPON_ASSAULTRIFLE_MK2"] = { index = "ak47", nome = "AK-47", type = "equipar" },
	["wbody|WEAPON_CARBINERIFLE"] = { index = "ar15", nome = "AR-15", type = "equipar" },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "m4a1", nome = "M4-A1", type = "equipar" },
	["wbody|WEAPON_ADVANCEDRIFLE"] = { index = "tavorctar21", nome = "Tavor CTAR-21", type = "equipar" },
	["wbody|WEAPON_SPECIALCARBINE"] = { index = "g36c", nome = "G36C", type = "equipar" },
	["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "g36k", nome = "G36K", type = "equipar" },
	["wbody|WEAPON_BULLPUPRIFLE"] = { index = "noricon86s", nome = "Norinco 86S", type = "equipar" },
	["wbody|WEAPON_BULLPUPRIFLE_MK2"] = { index = "hsvhsd2", nome = "HS VHS-D2", type = "equipar" },
	["wbody|WEAPON_COMPACTRIFLE"] = { index = "minidraco", nome = "Draco", type = "equipar" },

	--[ Assault Rifles ][ Ammo ]---------------------------------------------------------------------------------------

	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak74", nome = "M-AK-74", type = "recarregar" },
	["wammo|WEAPON_ASSAULTRIFLE_MK2"] = { index = "m-ak47", nome = "M-AK-47", type = "recarregar" },
	["wammo|WEAPON_CARBINERIFLE"] = { index = "m-ar15", nome = "M-AR-15", type = "recarregar" },
	["wammo|WEAPON_CARBINERIFLE_MK2"] = { index = "m-m4a1", nome = "M-M4-A1", type = "recarregar" },
	["wammo|WEAPON_ADVANCEDRIFLE"] = { index = "m-tavorctar21", nome = "M-Tavor CTAR-21", type = "recarregar" },
	["wammo|WEAPON_SPECIALCARBINE"] = { index = "m-g36c", nome = "M-G36C", type = "recarregar" },
	["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "m-g36k", nome = "M-G36K", type = "recarregar" },
	["wammo|WEAPON_BULLPUPRIFLE"] = { index = "m-noricon86s", nome = "M-Norinco 86S", type = "recarregar" },
	["wammo|WEAPON_BULLPUPRIFLE_MK2"] = { index = "m-hsvhsd2", nome = "M-HS VHS-D2", type = "recarregar" },
	["wammo|WEAPON_COMPACTRIFLE"] = { index = "m-minidraco", nome = "M-Draco", type = "recarregar" },

	--[ Light Machine Guns ][ Weapons ]--------------------------------------------------------------------------------

	["wbody|WEAPON_MG"] = { index = "pkm", nome = "PKM", type = "equipar" },
	["wbody|WEAPON_COMBATMG"] = { index = "m60", nome = "M60", type = "equipar" },
	["wbody|WEAPON_COMBATMG_MK2"] = { index = "m6e4", nome = "M60E4", type = "equipar" },
	["wbody|WEAPON_GUSENBERG"] = { index = "thompson", nome = "Thompson", type = "equipar" },

	--[ Light Machine Guns ][ Ammo ]-----------------------------------------------------------------------------------

	["wammo|WEAPON_MG"] = { index = "m-pkm", nome = "M-PKM", type = "recarregar" },
	["wammo|WEAPON_COMBATMG"] = { index = "m-m60", nome = "M-M60", type = "recarregar" },
	["wammo|WEAPON_COMBATMG_MK2"] = { index = "m-m6e4", nome = "M-M60E4", type = "recarregar" },
	["wammo|WEAPON_GUSENBERG"] = { index = "m-thompson", nome = "M-Thompson", type = "recarregar" },

	--[ Sniper Rifles ][ Weapons ]-------------------------------------------------------------------------------------

	["wbody|WEAPON_SNIPERRIFLE"] = { index = "awf", nome = "AW-F", type = "equipar" },
	["wbody|WEAPON_HEAVYSNIPER"] = { index = "barrettm107", nome = "Barrett M107", type = "equipar" },
	["wbody|WEAPON_HEAVYSNIPER_MK2"] = { index = "serbubfg504", nome = "Serbu BFG-50A", type = "equipar" },
	["wbody|WEAPON_MASKMANRIFLE"] = { index = "m39", nome = "M39", type = "equipar" },
	["wbody|WEAPON_MASKMANRIFLE_MK2"] = { index = "m1a", nome = "M1A", type = "equipar" },

	--[ Sniper Rifles ][ Ammo ]----------------------------------------------------------------------------------------

	["wammo|WEAPON_SNIPERRIFLE"] = { index = "m-awf", nome = "M-AW-F", type = "recarregar" },
	["wammo|WEAPON_HEAVYSNIPER"] = { index = "m-barrettm107", nome = "M-Barrett M107", type = "recarregar" },
	["wammo|WEAPON_HEAVYSNIPER_MK2"] = { index = "m-serbubfg504", nome = "M-Serbu BFG-50A", type = "recarregar" },
	["wammo|WEAPON_MASKMANRIFLE"] = { index = "m-m39", nome = "M-M39", type = "recarregar" },
	["wammo|WEAPON_MASKMANRIFLE_MK2"] = { index = "m-m1a", nome = "M-M1A", type = "recarregar" },

	--[ Heavy Weapons ][ Weapons ]-------------------------------------------------------------------------------------

	["wbody|WEAPON_RPG"] = { index = "rpg", nome = "RPG", type = "equipar" },
	["wbody|WEAPON_GRENADELAUNCHER"] = { index = "grenadelauncher", nome = "Lançador de Granadas", type = "equipar" },
	["wbody|WEAPON_GRENADELAUNCHER_SMOKE"] = { index = "grenadelaunchersmoke", nome = "Lançador de Granadas de Smoke", type = "equipar" },
	["wbody|WEAPON_MINIGUN"] = { index = "minigun", nome = "Minigun", type = "equipar" },
	["wbody|WEAPON_FIREWORK"] = { index = "firework", nome = "Firework", type = "equipar" },
	["wbody|WEAPON_RAILGUN"] = { index = "railgun", nome = "Railgun", type = "equipar" },
	["wbody|WEAPON_HOMINGLAUNCHER"] = { index = "hominglauncher", nome = "Railgun", type = "equipar" },
	["wbody|WEAPON_COMPACTLAUNCHER"] = { index = "compactlauncher", nome = "Lançador de Granadas Compacto", type = "equipar" },
	["wbody|WEAPON_RAYMINIGUN"] = { index = "rayminigun", nome = "Rayminigun", type = "equipar" },

	--[ Heavy Weapons ][ Ammo ]----------------------------------------------------------------------------------------

	["wammo|WEAPON_RPG"] = { index = "m-rpg", nome = "M-RPG", type = "recarregar" },
	["wammo|WEAPON_GRENADELAUNCHER"] = { index = "m-grenadelauncher", nome = "M-Lançador de Granadas", type = "recarregar" },
	["wammo|WEAPON_GRENADELAUNCHER_SMOKE"] = { index = "m-grenadelaunchersmoke", nome = "M-Lançador de Granadas", type = "recarregar" },
	["wammo|WEAPON_MINIGUN"] = { index = "m-minigun", nome = "M-Minigun", type = "recarregar" },
	["wammo|WEAPON_FIREWORK"] = { index = "m-firework", nome = "M-Firework", type = "recarregar" },
	["wammo|WEAPON_RAILGUN"] = { index = "m-railgun", nome = "M-Railgun", type = "recarregar" },
	["wammo|WEAPON_HOMINGLAUNCHER"] = { index = "m-hominglauncher", nome = "M-Railgun", type = "recarregar" },
	["wammo|WEAPON_COMPACTLAUNCHER"] = { index = "m-compactlauncher", nome = "M-Lançador de Granadas", type = "recarregar" },
	["wammo|WEAPON_RAYMINIGUN"] = { index = "m-rayminigun", nome = "M-Rayminigun", type = "recarregar" },

	--[ Throwables ]---------------------------------------------------------------------------------------------------

	["wbody|WEAPON_GRANADE"] = { index = "granada", nome = "Granada", type = "equipar" },
	["wbody|WEAPON_BZGAS"] = { index = "gaslacrimogeneo", nome = "Gás Lacrimogêneo", type = "equipar" },
	["wbody|WEAPON_MOLOTOV"] = { index = "coquetelmolotov", nome = "Coquetel Molotov", type = "equipar" },
	["wbody|WEAPON_STICKYBOMB"] = { index = "c4", nome = "C4", type = "equipar" },
	["wbody|WEAPON_PROXMINE"] = { index = "minaproximidade", nome = "Mina de Proximidade", type = "equipar" },
	["wbody|WEAPON_SNOWBALL"] = { index = "bolaneve", nome = "Bola de Neve", type = "equipar" },
	["wbody|WEAPON_PIPEBOMB"] = { index = "bombacano", nome = "Bomba de Cano", type = "equipar" },
	["wbody|WEAPON_BALL"] = { index = "bolabaseball", nome = "Bola de Baseball", type = "equipar" },
	["wbody|WEAPON_SMOKEGRENADE"] = { index = "granadagas", nome = "Granada de Gás", type = "equipar" },
	["wbody|WEAPON_FLARE"] = { index = "flare", nome = "Flare", type = "equipar" },

	--[ Miscellaneous ]------------------------------------------------------------------------------------------------

	["wbody|WEAPON_PETROLCAN"] = { index = "galaogasolina", nome = "Galão de Gasolina", type = "equipar" },
	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquédas", type = "equipar" },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar" }
}

function vRP.itemNameList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].nome
	end
end

function vRP.itemIndexList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].index
	end
end

function vRP.itemTypeList(item)
	if itemlist[item] ~= nil then
		return itemlist[item].type
	end
end

function vRP.itemBodyList(item)
	if itemlist[item] ~= nil then
		return itemlist[item]
	end
end

vRP.items = {}

function vRP.defInventoryItem(idname,name,weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	vRP.items[idname] = item
end

function vRP.computeItemName(item,args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function vRP.computeItemWeight(item,args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function vRP.parseItem(idname)
	return splitString(idname,"|")
end

function vRP.getItemDefinition(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemName(item,args),vRP.computeItemWeight(item,args)
	end
	return nil,nil
end

function vRP.getItemWeight(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemWeight(item,args)
	end
	return 0
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

function vRP.giveInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry then
			entry.amount = entry.amount + amount
		else
			data.inventory[idname] = { amount = amount }
		end
	end
end

function vRP.tryGetInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry and entry.amount >= amount then
			entry.amount = entry.amount - amount

			if entry.amount <= 0 then
				data.inventory[idname] = nil
			end
			return true
		end
	end
	return false
end

function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function vRP.getInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function vRP.getInventoryWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		return vRP.computeItemsWeight(data.inventory)
	end
	return 0
end

function vRP.getInventoryMaxWeight(user_id)
	return math.floor(vRP.expToLevel(vRP.getExp(user_id,"physical","strength")))*3
end

RegisterServerEvent("clearInventoryTwo")
AddEventHandler("clearInventoryTwo",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = vRP.getUserDataTable(user_id)
        if data then
            data.inventory = {}
        end

        vRPclient._clearWeapons(source)
    end
end)

RegisterServerEvent("clearInventory")
AddEventHandler("clearInventory",function()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = vRP.getUserDataTable(user_id)
        if data then
            data.inventory = {}
        end

        vRPclient._clearWeapons(source)
        vRPclient._setHandcuffed(source,false)

        vRP.setExp(user_id,"physical","strength",20)
    end
end)

AddEventHandler("vRP:playerJoin", function(user_id,source,name)
	local data = vRP.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)

--[ VEHGLOBAL ]-----------------------------------------------------------------------------------------------------------------------------------------

local vehglobal = {
	["blista"] = { ['name'] = "Blista", ['price'] = 22000, ['tipo'] = "carros", ['mala'] = 20 },
	["brioso"] = { ['name'] = "Brioso", ['price'] = 35000, ['tipo'] = "carros", ['mala'] = 30 },
	["emperor"] = { ['name'] = "Emperor", ['price'] = 7000, ['tipo'] = "carros", ["mala"] = 50 },
	["emperor2"] = { ['name'] = "Emperor 2", ['price'] = 50000, ['tipo'] = "carros", ["mala"] = 50 },
	["dilettante"] = { ['name'] = "Dilettante", ['price'] = 17000, ['tipo'] = "carros", ["mala"] = 50 },
	["issi2"] = { ['name'] = "Issi2", ['price'] = 90000, ['tipo'] = "carros", ["mala"] = 50 },
	["panto"] = { ['name'] = "Panto", ['price'] = 12000, ['tipo'] = "carros", ["mala"] = 50 },
	["prairie"] = { ['name'] = "Prairie", ['price'] = 27000, ['tipo'] = "carros", ["mala"] = 50 },
	["rhapsody"] = { ['name'] = "Rhapsody", ['price'] = 10000, ['tipo'] = "carros", ["mala"] = 50 },
	["cogcabrio"] = { ['name'] = "Cogcabrio", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["exemplar"] = { ['name'] = "Exemplar", ['price'] = 80000, ['tipo'] = "carros", ["mala"] = 50 },
	["f620"] = { ['name'] = "F620", ['price'] = 55000, ['tipo'] = "carros", ["mala"] = 50 },
	["felon"] = { ['name'] = "Felon", ['price'] = 70000, ['tipo'] = "carros", ["mala"] = 50 },
	["ingot"] = { ['name'] = "Ingot", ['price'] = 160000, ['tipo'] = "carros", ["mala"] = 50 },
	["jackal"] = { ['name'] = "Jackal", ['price'] = 60000, ['tipo'] = "carros", ["mala"] = 50 },
	["oracle"] = { ['name'] = "Oracle", ['price'] = 28000, ['tipo'] = "carros", ["mala"] = 50 },
	["oracle2"] = { ['name'] = "Oracle2", ['price'] = 80000, ['tipo'] = "carros", ["mala"] = 50 },
	["sentinel"] = { ['name'] = "Sentinel", ['price'] = 50000, ['tipo'] = "carros", ["mala"] = 50 },
	["sentinel2"] = { ['name'] = "Sentinel2", ['price'] = 60000, ['tipo'] = "carros", ["mala"] = 50 },
	["windsor"] = { ['name'] = "Windsor", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["windsor2"] = { ['name'] = "Windsor2", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["zion"] = { ['name'] = "Zion", ['price'] = 50000, ['tipo'] = "carros", ["mala"] = 50 },
	["zion2"] = { ['name'] = "Zion2", ['price'] = 60000, ['tipo'] = "carros", ["mala"] = 50 },
	["blade"] = { ['name'] = "Blade", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["buccaneer"] = { ['name'] = "Buccaneer", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["buccaneer2"] = { ['name'] = "Buccaneer2", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["primo"] = { ['name'] = "Primo", ['price'] = 9500, ['tipo'] = "carros", ["mala"] = 50 },
	["chino"] = { ['name'] = "Chino", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["coquette3"] = { ['name'] = "Coquette3", ['price'] = 195000, ['tipo'] = "carros", ["mala"] = 50 },
	["dukes"] = { ['name'] = "Dukes", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["faction"] = { ['name'] = "Faction", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["faction3"] = { ['name'] = "Faction3", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["gauntlet"] = { ['name'] = "Gauntlet", ['price'] = 165000, ['tipo'] = "carros", ["mala"] = 50 },
	["gauntlet2"] = { ['name'] = "Gauntlet2", ['price'] = 165000, ['tipo'] = "carros", ["mala"] = 50 },
	["hermes"] = { ['name'] = "Hermes", ['price'] = 280000, ['tipo'] = "carros", ["mala"] = 50 },
	["hotknife"] = { ['name'] = "Hotknife", ['price'] = 180000, ['tipo'] = "carros", ["mala"] = 50 },
	["moonbeam"] = { ['name'] = "Moonbeam", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["moonbeam2"] = { ['name'] = "Moonbeam2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["nightshade"] = { ['name'] = "Nightshade", ['price'] = 270000, ['tipo'] = "carros", ["mala"] = 50 },
	["picador"] = { ['name'] = "Picador", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["ruiner"] = { ['name'] = "Ruiner", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["sabregt"] = { ['name'] = "Sabregt", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["sabregt2"] = { ['name'] = "Sabregt2", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["slamvan"] = { ['name'] = "Slamvan", ['price'] = 180000, ['tipo'] = "carros", ["mala"] = 50 },
	["slamvan3"] = { ['name'] = "Slamvan3", ['price'] = 230000, ['tipo'] = "carros", ["mala"] = 50 },
	["stalion"] = { ['name'] = "Stalion", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["stalion2"] = { ['name'] = "Stalion2", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["tampa"] = { ['name'] = "Tampa", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["vigero"] = { ['name'] = "Vigero", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["virgo"] = { ['name'] = "Virgo", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["virgo2"] = { ['name'] = "Virgo2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["virgo3"] = { ['name'] = "Virgo3", ['price'] = 180000, ['tipo'] = "carros", ["mala"] = 50 },
	["voodoo"] = { ['name'] = "Voodoo", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["voodoo2"] = { ['name'] = "Voodoo2", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["yosemite"] = { ['name'] = "Yosemite", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["bfinjection"] = { ['name'] = "Bfinjection", ['price'] = 80000, ['tipo'] = "carros", ["mala"] = 50 },
	["bifta"] = { ['name'] = "Bifta", ['price'] = 190000, ['tipo'] = "carros", ["mala"] = 50 },
	["bodhi2"] = { ['name'] = "Bodhi2", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["brawler"] = { ['name'] = "Brawler", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["trophytruck"] = { ['name'] = "Trophytruck", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["trophytruck2"] = { ['name'] = "Trophytruck2", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["dubsta3"] = { ['name'] = "Dubsta3", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["mesa3"] = { ['name'] = "Mesa3", ['price'] = 200000, ['tipo'] = "carros", ["mala"] = 50 },
	["rancherxl"] = { ['name'] = "Rancherxl", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["rebel2"] = { ['name'] = "Rebel2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["riata"] = { ['name'] = "Riata", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["dloader"] = { ['name'] = "Dloader", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["sandking"] = { ['name'] = "Sandking", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["sandking2"] = { ['name'] = "Sandking2", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller"] = { ['name'] = "Baller", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller2"] = { ['name'] = "Baller2", ['price'] = 160000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller3"] = { ['name'] = "Baller3", ['price'] = 175000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller4"] = { ['name'] = "Baller4", ['price'] = 185000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller5"] = { ['name'] = "Baller5", ['price'] = 270000, ['tipo'] = "carros", ["mala"] = 50 },
	["baller6"] = { ['name'] = "Baller6", ['price'] = 280000, ['tipo'] = "carros", ["mala"] = 50 },
	["bjxl"] = { ['name'] = "Bjxl", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["cavalcade"] = { ['name'] = "Cavalcade", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["cavalcade2"] = { ['name'] = "Cavalcade2", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["contender"] = { ['name'] = "Contender", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["dubsta"] = { ['name'] = "Dubsta", ['price'] = 210000, ['tipo'] = "carros", ["mala"] = 50 },
	["dubsta2"] = { ['name'] = "Dubsta2", ['price'] = 240000, ['tipo'] = "carros", ["mala"] = 50 },
	["fq2"] = { ['name'] = "Fq2", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["granger"] = { ['name'] = "Granger", ['price'] = 345000, ['tipo'] = "carros", ["mala"] = 50 },
	["gresley"] = { ['name'] = "Gresley", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["habanero"] = { ['name'] = "Habanero", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["seminole"] = { ['name'] = "Seminole", ['price'] = 49000, ['tipo'] = "carros", ["mala"] = 50 },
	["serrano"] = { ['name'] = "Serrano", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["xls"] = { ['name'] = "Xls", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["xls2"] = { ['name'] = "Xls2", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["asea"] = { ['name'] = "Asea", ['price'] = 32000, ['tipo'] = "carros", ["mala"] = 50 },
	["asterope"] = { ['name'] = "Asterope", ['price'] = 49000, ['tipo'] = "carros", ["mala"] = 50 },
	["cog552"] = { ['name'] = "Cog552", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["cognoscenti"] = { ['name'] = "Cognoscenti", ['price'] = 280000, ['tipo'] = "carros", ["mala"] = 50 },
	["cognoscenti2"] = { ['name'] = "Cognoscenti2", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["stanier"] = { ['name'] = "Stanier", ['price'] = 18000, ['tipo'] = "carros", ["mala"] = 50 },
	["stratum"] = { ['name'] = "Stratum", ['price'] = 90000, ['tipo'] = "carros", ["mala"] = 50 },
	["surge"] = { ['name'] = "Surge", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["tailgater"] = { ['name'] = "Tailgater", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["warrener"] = { ['name'] = "Warrener", ['price'] = 90000, ['tipo'] = "carros", ["mala"] = 50 },
	["washington"] = { ['name'] = "Washington", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["alpha"] = { ['name'] = "Alpha", ['price'] = 230000, ['tipo'] = "carros", ["mala"] = 50 },
	["banshee"] = { ['name'] = "Banshee", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["bestiagts"] = { ['name'] = "Bestiagts", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["blista2"] = { ['name'] = "Blista2", ['price'] = 55000, ['tipo'] = "carros", ["mala"] = 50 },
	["blista3"] = { ['name'] = "Blista3", ['price'] = 80000, ['tipo'] = "carros", ["mala"] = 50 },
	["buffalo"] = { ['name'] = "Buffalo", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["buffalo2"] = { ['name'] = "Buffalo2", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["buffalo3"] = { ['name'] = "Buffalo3", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["carbonizzare"] = { ['name'] = "Carbonizzare", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["comet2"] = { ['name'] = "Comet2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["comet3"] = { ['name'] = "Comet3", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["comet5"] = { ['name'] = "Comet5", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["coquette"] = { ['name'] = "Coquette", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["elegy"] = { ['name'] = "Elegy", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["elegy2"] = { ['name'] = "Elegy2", ['price'] = 355000, ['tipo'] = "carros", ["mala"] = 50 },
	["feltzer2"] = { ['name'] = "Feltzer2", ['price'] = 255000, ['tipo'] = "carros", ["mala"] = 50 },
	["furoregt"] = { ['name'] = "Furoregt", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["fusilade"] = { ['name'] = "Fusilade", ['price'] = 210000, ['tipo'] = "carros", ["mala"] = 50 },
	["futo"] = { ['name'] = "Futo", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["jester"] = { ['name'] = "Jester", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["khamelion"] = { ['name'] = "Khamelion", ['price'] = 210000, ['tipo'] = "carros", ["mala"] = 50 },
	["kuruma"] = { ['name'] = "Kuruma", ['price'] = 330000, ['tipo'] = "carros", ["mala"] = 50 },
	["massacro"] = { ['name'] = "Massacro", ['price'] = 330000, ['tipo'] = "carros", ["mala"] = 50 },
	["massacro2"] = { ['name'] = "Massacro2", ['price'] = 330000, ['tipo'] = "carros", ["mala"] = 50 },
	["ninef"] = { ['name'] = "Ninef", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["ninef2"] = { ['name'] = "Ninef2", ['price'] = 290000, ['tipo'] = "carros", ["mala"] = 50 },
	["omnis"] = { ['name'] = "Omnis", ['price'] = 240000, ['tipo'] = "carros", ["mala"] = 50 },
	["pariah"] = { ['name'] = "Pariah", ['price'] = 500000, ['tipo'] = "carros", ["mala"] = 50 },
	["penumbra"] = { ['name'] = "Penumbra", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["raiden"] = { ['name'] = "Raiden", ['price'] = 240000, ['tipo'] = "carros", ["mala"] = 50 },
	["rapidgt"] = { ['name'] = "Rapidgt", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["rapidgt2"] = { ['name'] = "Rapidgt2", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["ruston"] = { ['name'] = "Ruston", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["schafter3"] = { ['name'] = "Schafter3", ['price'] = 275000, ['tipo'] = "carros", ["mala"] = 50 },
	["schafter4"] = { ['name'] = "Schafter4", ['price'] = 275000, ['tipo'] = "carros", ["mala"] = 50 },
	["schafter5"] = { ['name'] = "Schafter5", ['price'] = 275000, ['tipo'] = "carros", ["mala"] = 50 },
	["schwarzer"] = { ['name'] = "Schwarzer", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["sentinel3"] = { ['name'] = "Sentinel3", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["seven70"] = { ['name'] = "Seven70", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["specter"] = { ['name'] = "Specter", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["specter2"] = { ['name'] = "Specter2", ['price'] = 355000, ['tipo'] = "carros", ["mala"] = 50 },
	["streiter"] = { ['name'] = "Streiter", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["sultan"] = { ['name'] = "Sultan", ['price'] = 210000, ['tipo'] = "carros", ["mala"] = 50 },
	["surano"] = { ['name'] = "Surano", ['price'] = 310000, ['tipo'] = "carros", ["mala"] = 50 },
	["tampa2"] = { ['name'] = "Tampa2", ['price'] = 200000, ['tipo'] = "carros", ["mala"] = 50 },
	["tropos"] = { ['name'] = "Tropos", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["verlierer2"] = { ['name'] = "Verlierer2", ['price'] = 380000, ['tipo'] = "carros", ["mala"] = 50 },
	["btype2"] = { ['name'] = "Btype2", ['price'] = 460000, ['tipo'] = "carros", ["mala"] = 50 },
	["btype3"] = { ['name'] = "Btype3", ['price'] = 390000, ['tipo'] = "carros", ["mala"] = 50 },
	["casco"] = { ['name'] = "Casco", ['price'] = 355000, ['tipo'] = "carros", ["mala"] = 50 },
	["cheetah"] = { ['name'] = "Cheetah", ['price'] = 425000, ['tipo'] = "carros", ["mala"] = 50 },
	["coquette2"] = { ['name'] = "Coquette2", ['price'] = 285000, ['tipo'] = "carros", ["mala"] = 50 },
	["feltzer3"] = { ['name'] = "Feltzer3", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["gt500"] = { ['name'] = "Gt500", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["infernus2"] = { ['name'] = "Infernus2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["jb700"] = { ['name'] = "Jb700", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["mamba"] = { ['name'] = "Mamba", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["manana"] = { ['name'] = "Manana", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["monroe"] = { ['name'] = "Monroe", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["peyote"] = { ['name'] = "Peyote", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["pigalle"] = { ['name'] = "Pigalle", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["rapidgt3"] = { ['name'] = "Rapidgt3", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["retinue"] = { ['name'] = "Retinue", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["stinger"] = { ['name'] = "Stinger", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["stingergt"] = { ['name'] = "Stingergt", ['price'] = 230000, ['tipo'] = "carros", ["mala"] = 50 },
	["torero"] = { ['name'] = "Torero", ['price'] = 160000, ['tipo'] = "carros", ["mala"] = 50 },
	["tornado"] = { ['name'] = "Tornado", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["tornado2"] = { ['name'] = "Tornado2", ['price'] = 160000, ['tipo'] = "carros", ["mala"] = 50 },
	["tornado6"] = { ['name'] = "Tornado6", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["turismo2"] = { ['name'] = "Turismo2", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["ztype"] = { ['name'] = "Ztype", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["adder"] = { ['name'] = "Adder", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["autarch"] = { ['name'] = "Autarch", ['price'] = 760000, ['tipo'] = "carros", ["mala"] = 50 },
	["banshee2"] = { ['name'] = "Banshee2", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["bullet"] = { ['name'] = "Bullet", ['price'] = 400000, ['tipo'] = "carros", ["mala"] = 50 },
	["cheetah2"] = { ['name'] = "Cheetah2", ['price'] = 240000, ['tipo'] = "carros", ["mala"] = 50 },
	["entityxf"] = { ['name'] = "Entityxf", ['price'] = 460000, ['tipo'] = "carros", ["mala"] = 50 },
	["fmj"] = { ['name'] = "Fmj", ['price'] = 520000, ['tipo'] = "carros", ["mala"] = 50 },
	["gp1"] = { ['name'] = "Gp1", ['price'] = 495000, ['tipo'] = "carros", ["mala"] = 50 },
	["infernus"] = { ['name'] = "Infernus", ['price'] = 470000, ['tipo'] = "carros", ["mala"] = 50 },
	["nero"] = { ['name'] = "Nero", ['price'] = 450000, ['tipo'] = "carros", ["mala"] = 50 },
	["nero2"] = { ['name'] = "Nero2", ['price'] = 480000, ['tipo'] = "carros", ["mala"] = 50 },
	["osiris"] = { ['name'] = "Osiris", ['price'] = 460000, ['tipo'] = "carros", ["mala"] = 50 },
	["penetrator"] = { ['name'] = "Penetrator", ['price'] = 480000, ['tipo'] = "carros", ["mala"] = 50 },
	["pfister811"] = { ['name'] = "Pfister811", ['price'] = 530000, ['tipo'] = "carros", ["mala"] = 50 },
	["reaper"] = { ['name'] = "Reaper", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["sc1"] = { ['name'] = "Sc1", ['price'] = 495000, ['tipo'] = "carros", ["mala"] = 50 },
	["sultanrs"] = { ['name'] = "Sultan RS", ['price'] = 450000, ['tipo'] = "carros", ["mala"] = 50 },
	["t20"] = { ['name'] = "T20", ['price'] = 670000, ['tipo'] = "carros", ["mala"] = 50 },
	["tempesta"] = { ['name'] = "Tempesta", ['price'] = 600000, ['tipo'] = "carros", ["mala"] = 50 },
	["turismor"] = { ['name'] = "Turismor", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["tyrus"] = { ['name'] = "Tyrus", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["vacca"] = { ['name'] = "Vacca", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["visione"] = { ['name'] = "Visione", ['price'] = 690000, ['tipo'] = "carros", ["mala"] = 50 },
	["voltic"] = { ['name'] = "Voltic", ['price'] = 440000, ['tipo'] = "carros", ["mala"] = 50 },
	["zentorno"] = { ['name'] = "Zentorno", ['price'] = 920000, ['tipo'] = "carros", ["mala"] = 50 },
	["sadler"] = { ['name'] = "Sadler", ['price'] = 180000, ['tipo'] = "carros", ["mala"] = 50 },
	["bison"] = { ['name'] = "Bison", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["bison2"] = { ['name'] = "Bison2", ['price'] = 180000, ['tipo'] = "carros", ["mala"] = 50 },
	["bobcatxl"] = { ['name'] = "Bobcatxl", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["burrito"] = { ['name'] = "Burrito", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["burrito2"] = { ['name'] = "Burrito2", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["burrito3"] = { ['name'] = "Burrito3", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["burrito4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["mule4"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["rallytruck"] = { ['name'] = "Burrito4", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["minivan"] = { ['name'] = "Minivan", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["minivan2"] = { ['name'] = "Minivan2", ['price'] = 220000, ['tipo'] = "carros", ["mala"] = 50 },
	["paradise"] = { ['name'] = "Paradise", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["pony"] = { ['name'] = "Pony", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["pony2"] = { ['name'] = "Pony2", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["rumpo"] = { ['name'] = "Rumpo", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["rumpo2"] = { ['name'] = "Rumpo2", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["rumpo3"] = { ['name'] = "Rumpo3", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["surfer"] = { ['name'] = "Surfer", ['price'] = 55000, ['tipo'] = "carros", ["mala"] = 50 },
	["youga"] = { ['name'] = "Youga", ['price'] = 260000, ['tipo'] = "carros", ["mala"] = 50 },
	["huntley"] = { ['name'] = "Huntley", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["landstalker"] = { ['name'] = "Landstalker", ['price'] = 130000, ['tipo'] = "carros", ["mala"] = 50 },
	["mesa"] = { ['name'] = "Mesa", ['price'] = 90000, ['tipo'] = "carros", ["mala"] = 50 },
	["patriot"] = { ['name'] = "Patriot", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["radi"] = { ['name'] = "Radi", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["rocoto"] = { ['name'] = "Rocoto", ['price'] = 110000, ['tipo'] = "carros", ["mala"] = 50 },
	["tyrant"] = { ['name'] = "Tyrant", ['price'] = 690000, ['tipo'] = "carros", ["mala"] = 50 },
	["entity2"] = { ['name'] = "Entity2", ['price'] = 550000, ['tipo'] = "carros", ["mala"] = 50 },
	["cheburek"] = { ['name'] = "Cheburek", ['price'] = 170000, ['tipo'] = "carros", ["mala"] = 50 },
	["hotring"] = { ['name'] = "Hotring", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["jester3"] = { ['name'] = "Jester3", ['price'] = 345000, ['tipo'] = "carros", ["mala"] = 50 },
	["flashgt"] = { ['name'] = "Flashgt", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["ellie"] = { ['name'] = "Ellie", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["michelli"] = { ['name'] = "Michelli", ['price'] = 160000, ['tipo'] = "carros", ["mala"] = 50 },
	["fagaloa"] = { ['name'] = "Fagaloa", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["dominator"] = { ['name'] = "Dominator", ['price'] = 230000, ['tipo'] = "carros", ["mala"] = 50 },
	["dominator2"] = { ['name'] = "Dominator2", ['price'] = 230000, ['tipo'] = "carros", ["mala"] = 50 },
	["dominator3"] = { ['name'] = "Dominator3", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["issi3"] = { ['name'] = "Issi3", ['price'] = 190000, ['tipo'] = "carros", ["mala"] = 50 },
	["taipan"] = { ['name'] = "Taipan", ['price'] = 620000, ['tipo'] = "carros", ["mala"] = 50 },
	["gb200"] = { ['name'] = "Gb200", ['price'] = 195000, ['tipo'] = "carros", ["mala"] = 50 },
	["stretch"] = { ['name'] = "Stretch", ['price'] = 520000, ['tipo'] = "carros", ["mala"] = 50 },
	["guardian"] = { ['name'] = "Guardian", ['price'] = 540000, ['tipo'] = "carros", ["mala"] = 50 },
	["kamacho"] = { ['name'] = "Kamacho", ['price'] = 460000, ['tipo'] = "carros", ["mala"] = 50 },
	["neon"] = { ['name'] = "Neon", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["cyclone"] = { ['name'] = "Cyclone", ['price'] = 920000, ['tipo'] = "carros", ["mala"] = 50 },
	["italigtb"] = { ['name'] = "Italigtb", ['price'] = 600000, ['tipo'] = "carros", ["mala"] = 50 },
	["italigtb2"] = { ['name'] = "Italigtb2", ['price'] = 610000, ['tipo'] = "carros", ["mala"] = 50 },
	["vagner"] = { ['name'] = "Vagner", ['price'] = 680000, ['tipo'] = "carros", ["mala"] = 50 },
	["xa21"] = { ['name'] = "Xa21", ['price'] = 630000, ['tipo'] = "carros", ['mala'] = 50 },
	["tezeract"] = { ['name'] = "Tezeract", ['price'] = 920000, ['tipo'] = "carros", ["mala"] = 50 },
	["prototipo"] = { ['name'] = "Prototipo", ['price'] = 1030000, ['tipo'] = "carros", ["mala"] = 50 },
	["patriot2"] = { ['name'] = "Patriot2", ['price'] = 550000, ['tipo'] = "carros", ["mala"] = 50 },
	["swinger"] = { ['name'] = "Swinger", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["clique"] = { ['name'] = "Clique", ['price'] = 360000, ['tipo'] = "carros", ["mala"] = 50 },
	["deveste"] = { ['name'] = "Deveste", ['price'] = 920000, ['tipo'] = "carros", ["mala"] = 50 },
	["deviant"] = { ['name'] = "Deviant", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["impaler"] = { ['name'] = "Impaler", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["italigto"] = { ['name'] = "Italigto", ['price'] = 800000, ['tipo'] = "carros", ["mala"] = 50 },
	["schlagen"] = { ['name'] = "Schlagen", ['price'] = 690000, ['tipo'] = "carros", ["mala"] = 50 },
	["toros"] = { ['name'] = "Toros", ['price'] = 520000, ['tipo'] = "carros", ["mala"] = 50 },
	["tulip"] = { ['name'] = "Tulip", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["vamos"] = { ['name'] = "Vamos", ['price'] = 320000, ['tipo'] = "carros", ["mala"] = 50 },
	["freecrawler"] = { ['name'] = "Freecrawler", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },
	["fugitive"] = { ['name'] = "Fugitive", ['price'] = 50000, ['tipo'] = "carros", ["mala"] = 50 },
	["glendale"] = { ['name'] = "Glendale", ['price'] = 70000, ['tipo'] = "carros", ["mala"] = 50 },
	["intruder"] = { ['name'] = "Intruder", ['price'] = 11000, ['tipo'] = "carros", ["mala"] = 50 },
	["le7b"] = { ['name'] = "Le7b", ['price'] = 700000, ['tipo'] = "carros", ["mala"] = 50 },
	["lurcher"] = { ['name'] = "Lurcher", ['price'] = 150000, ['tipo'] = "carros", ["mala"] = 50 },
	["lynx"] = { ['name'] = "Lynx", ['price'] = 370000, ['tipo'] = "carros", ["mala"] = 50 },
	["phoenix"] = { ['name'] = "Phoenix", ['price'] = 250000, ['tipo'] = "carros", ["mala"] = 50 },
	["premier"] = { ['name'] = "Premier", ['price'] = 37000, ['tipo'] = "carros", ["mala"] = 50 },
	["raptor"] = { ['name'] = "Raptor", ['price'] = 300000, ['tipo'] = "carros", ["mala"] = 50 },
	["sheava"] = { ['name'] = "Sheava", ['price'] = 700000, ['tipo'] = "carros", ["mala"] = 50 },
	["z190"] = { ['name'] = "Z190", ['price'] = 350000, ['tipo'] = "carros", ["mala"] = 50 },

	--MOTOS
	
	["akuma"] = { ['name'] = "Akuma", ['price'] = 500000, ['tipo'] = "motos", ["mala"] = 10 },
	["avarus"] = { ['name'] = "Avarus", ['price'] = 440000, ['tipo'] = "motos", ["mala"] = 10 },
	["bagger"] = { ['name'] = "Bagger", ['price'] = 300000, ['tipo'] = "motos", ["mala"] = 10 },
	["bati"] = { ['name'] = "Bati", ['price'] = 370000, ['tipo'] = "motos", ["mala"] = 10 },
	["bati2"] = { ['name'] = "Bati2", ['price'] = 300000, ['tipo'] = "motos", ["mala"] = 10 },
	["bf400"] = { ['name'] = "Bf400", ['price'] = 320000, ['tipo'] = "motos", ["mala"] = 10 },
	["carbonrs"] = { ['name'] = "Carbonrs", ['price'] = 370000, ['tipo'] = "motos", ["mala"] = 10 },
	["chimera"] = { ['name'] = "Chimera", ['price'] = 345000, ['tipo'] = "motos", ["mala"] = 10 },
	["cliffhanger"] = { ['name'] = "Cliffhanger", ['price'] = 310000, ['tipo'] = "motos", ["mala"] = 10 },
	["daemon2"]  = { ['name'] = "Daemon2", ['price'] = 240000, ['tipo'] = "motos", ["mala"] = 10 },
	["defiler"] = { ['name'] = "Defiler", ['price'] = 460000, ['tipo'] = "motos", ["mala"] = 10 },
	["diablous"] = { ['name'] = "Diablous", ['price'] = 430000, ['tipo'] = "motos", ["mala"] = 10 },
	["diablous2"] = { ['name'] = "Diablous2", ['price'] = 460000, ['tipo'] = "motos", ["mala"] = 10 },
	["double"] = { ['name'] = "Double", ['price'] = 370000, ['tipo'] = "motos", ["mala"] = 10 },
	["enduro"] = { ['name'] = "Enduro", ['price'] = 28000, ['tipo'] = "motos", ["mala"] = 10 },
	["esskey"] = { ['name'] = "Esskey", ['price'] = 320000, ['tipo'] = "motos", ["mala"] = 10 },
	["faggio"] = { ['name'] = "Faggio", ['price'] = 5000, ['tipo'] = "motos", ["mala"] = 10 },
	["faggio2"] = { ['name'] = "Faggio2", ['price'] = 5000, ['tipo'] = "motos", ["mala"] = 10 },
	["faggio3"] = { ['name'] = "Faggio3", ['price'] = 5000, ['tipo'] = "motos", ["mala"] = 10 },
	["fcr"] = { ['name'] = "Fcr", ['price'] = 390000, ['tipo'] = "motos", ["mala"] = 10 },
	["fcr2"] = { ['name'] = "Fcr2", ['price'] = 390000, ['tipo'] = "motos", ["mala"] = 10 },
	["gargoyle"] = { ['name'] = "Gargoyle", ['price'] = 345000, ['tipo'] = "motos", ["mala"] = 10 },
	["hakuchou"] = { ['name'] = "Hakuchou", ['price'] = 380000, ['tipo'] = "motos", ["mala"] = 10 },
	["hakuchou2"] = { ['name'] = "Hakuchou2", ['price'] = 550000, ['tipo'] = "motos", ["mala"] = 10 },
	["hexer"] = { ['name'] = "Hexer", ['price'] = 250000, ['tipo'] = "motos", ["mala"] = 10 },
	["innovation"] = { ['name'] = "Innovation", ['price'] = 250000, ['tipo'] = "motos", ["mala"] = 10 },
	["lectro"] = { ['name'] = "Lectro", ['price'] = 380000, ['tipo'] = "motos", ["mala"] = 10 },
	["manchez"] = { ['name'] = "Manchez", ['price'] = 355000, ['tipo'] = "motos", ["mala"] = 10 },
	["nemesis"] = { ['name'] = "Nemesis", ['price'] = 345000, ['tipo'] = "motos", ["mala"] = 10 },
	["nightblade"] = { ['name'] = "Nightblade", ['price'] = 415000, ['tipo'] = "motos", ["mala"] = 10 },
	["pcj"] = { ['name'] = "Pcj", ['price'] = 32000, ['tipo'] = "motos", ["mala"] = 10 },
	["ruffian"] = { ['name'] = "Ruffian", ['price'] = 345000, ['tipo'] = "motos", ["mala"] = 10 },
	["sanchez"] = { ['name'] = "Sanchez", ['price'] = 185000, ['tipo'] = "motos", ["mala"] = 10 },
	["sanchez2"] = { ['name'] = "Sanchez2", ['price'] = 185000, ['tipo'] = "motos", ["mala"] = 10 },
	["sovereign"] = { ['name'] = "Sovereign", ['price'] = 285000, ['tipo'] = "motos", ["mala"] = 10 },
	["thrust"] = { ['name'] = "Thrust", ['price'] = 375000, ['tipo'] = "motos", ["mala"] = 10 },
	["vader"] = { ['name'] = "Vader", ['price'] = 345000, ['tipo'] = "motos", ["mala"] = 10 },
	["vindicator"] = { ['name'] = "Vindicator", ['price'] = 340000, ['tipo'] = "motos", ["mala"] = 10 },
	["vortex"] = { ['name'] = "Vortex", ['price'] = 375000, ['tipo'] = "motos", ["mala"] = 10 },
	["wolfsbane"] = { ['name'] = "Wolfsbane", ['price'] = 290000, ['tipo'] = "motos", ["mala"] = 10 },
	["zombiea"] = { ['name'] = "Zombiea", ['price'] = 290000, ['tipo'] = "motos", ["mala"] = 10 },
	["zombieb"] = { ['name'] = "Zombieb", ['price'] = 300000, ['tipo'] = "motos", ["mala"] = 10 },
	["shotaro"] = { ['name'] = "Shotaro", ['price'] = 1000000, ['tipo'] = "motos", ["mala"] = 10 },
	["ratbike"] = { ['name'] = "Ratbike", ['price'] = 230000, ['tipo'] = "motos", ["mala"] = 10 },
	["blazer"] = { ['name'] = "Blazer", ['price'] = 230000, ['tipo'] = "motos", ["mala"] = 10 },
	["blazer4"] = { ['name'] = "Blazer4", ['price'] = 370000, ['tipo'] = "motos", ["mala"] = 10 },

	--TRABALHO
	["pbus"] = { ['name'] = "Echo", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiaheli"] = { ['name'] = "Delta", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiabearcat"] = { ['name'] = "Bravo", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },

	["policiacharger2018"] = { ['name'] = "Dodge Charger 2018", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiasilverado"] = { ['name'] = "Chevrolet Silverado", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiatahoe"] = { ['name'] = "Chevrolet Tahoe", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiataurus"] = { ['name'] = "Ford Taurus", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["policiabmwr1200"] = { ['name'] = "BMW R1200", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },

	["ambulance"] = { ['name'] = "Ambulância", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },

	["coach"] = { ['name'] = "Coach", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["bus"] = { ['name'] = "Ônibus", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["flatbed"] = { ['name'] = "Reboque", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["towtruck"] = { ['name'] = "Towtruck", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["towtruck2"] = { ['name'] = "Towtruck2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["ratloader"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["ratloader2"] = { ['name'] = "Ratloader2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["rubble"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["taxi"] = { ['name'] = "Taxi", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["boxville2"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["boxville4"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["trash2"] = { ['name'] = "Caminhão", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tiptruck"] = { ['name'] = "Tiptruck", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["scorcher"] = { ['name'] = "Scorcher", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tribike"] = { ['name'] = "Tribike", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tribike2"] = { ['name'] = "Tribike2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tribike3"] = { ['name'] = "Tribike3", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["fixter"] = { ['name'] = "Fixter", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["cruiser"] = { ['name'] = "Cruiser", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["bmx"] = { ['name'] = "Bmx", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["dinghy"] = { ['name'] = "Dinghy", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["jetmax"] = { ['name'] = "Jetmax", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["marquis"] = { ['name'] = "Marquis", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["seashark3"] = { ['name'] = "Seashark3", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["speeder"] = { ['name'] = "Speeder", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["speeder2"] = { ['name'] = "Speeder2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["squalo"] = { ['name'] = "Squalo", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["suntrap"] = { ['name'] = "Suntrap", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["toro"] = { ['name'] = "Toro", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["toro2"] = { ['name'] = "Toro2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tropic"] = { ['name'] = "Tropic", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tropic2"] = { ['name'] = "Tropic2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["phantom"] = { ['name'] = "Phantom", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["packer"] = { ['name'] = "Packer", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["supervolito"] = { ['name'] = "Supervolito", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["supervolito2"] = { ['name'] = "Supervolito2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["cuban800"] = { ['name'] = "Cuban800", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["mammatus"] = { ['name'] = "Mammatus", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["vestra"] = { ['name'] = "Vestra", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["velum2"] = { ['name'] = "Velum2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["buzzard2"] = { ['name'] = "Buzzard2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["frogger"] = { ['name'] = "Frogger", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["maverick"] = { ['name'] = "Maverick", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tanker2"] = { ['name'] = "Gas", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["armytanker"] = { ['name'] = "Diesel", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tvtrailer"] = { ['name'] = "Show", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["trailerlogs"] = { ['name'] = "Woods", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["tr4"] = { ['name'] = "Cars", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["speedo"] = { ['name'] = "Speedo", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["primo2"] = { ['name'] = "Primo2", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["faction2"] = { ['name'] = "Faction2", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["chino2"] = { ['name'] = "Chino2", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["tornado5"] = { ['name'] = "Tornado5", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["daemon"] = { ['name'] = "Daemon", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["sanctus"] = { ['name'] = "Sanctus", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["gburrito"] = { ['name'] = "GBurrito", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["slamvan2"] = { ['name'] = "Slamvan2", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["stafford"] = { ['name'] = "Stafford", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["cog55"] = { ['name'] = "Cog55", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["superd"] = { ['name'] = "Superd", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["btype"] = { ['name'] = "Btype", ['price'] = 200000, ['tipo'] = "work", ["mala"] = 10 },
	["tractor2"] = { ['name'] = "Tractor2", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["rebel"] = { ['name'] = "Rebel", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["flatbed3"] = { ['name'] = "flatbed3", ['price'] = 1000, ['tipo'] = "work", ["mala"] = 10 },
	["volatus"] = { ['name'] = "Volatus", ['price'] = 1000000, ['tipo'] = "work", ["mala"] = 10 },
	["cargobob2"] = { ['name'] = "Cargo Bob", ['price'] = 1000000, ['tipo'] = "work", ["mala"] = 10 },		
	
	--IMPORTADOS

	["dodgechargersrt"] = { ['name'] = "Dodge Charger SRT", ['price'] = 2000000, ['tipo'] = "import" },
	["audirs6"] = { ['name'] = "Audi RS6", ['price'] = 1500000, ['tipo'] = "import" },
	["bmwm3f80"] = { ['name'] = "BMW M3 F80", ['price'] = 1350000, ['tipo'] = "import" },
	["fordmustang"] = { ['name'] = "Ford Mustang", ['price'] = 1900000, ['tipo'] = "import" },
	["lancerevolution9"] = { ['name'] = "Lancer Evolution 9", ['price'] = 1400000, ['tipo'] = "import" },
	["lancerevolutionx"] = { ['name'] = "Lancer Evolution X", ['price'] = 1700000, ['tipo'] = "import" },
	["focusrs"] = { ['name'] = "Focus RS", ['price'] = 1000000, ['tipo'] = "import" },
	["mercedesa45"] = { ['name'] = "Mercedes A45", ['price'] = 1200000, ['tipo'] = "import" },
	["audirs7"] = { ['name'] = "Audi RS7", ['price'] = 1800000, ['tipo'] = "import" },
	["hondafk8"] = { ['name'] = "Honda FK8", ['price'] = 1700000, ['tipo'] = "import" },
	["mustangmach1"] = { ['name'] = "Mustang Mach 1", ['price'] = 1100000, ['tipo'] = "import" },
	["porsche930"] = { ['name'] = "Porsche 930", ['price'] = 1300000, ['tipo'] = "import" },
	["teslaprior"] = { ['name'] = "Tesla Prior", ['price'] = 1750000, ['tipo'] = "import" },
	["type263"] = { ['name'] = "Kombi 63", ['price'] = 500000, ['tipo'] = "import" },
	["beetle74"] = { ['name'] = "Fusca 74", ['price'] = 500000, ['tipo'] = "import" },
	["fe86"] = { ['name'] = "Escorte", ['price'] = 500000, ['tipo'] = "import" },		

	--EXCLUSIVE 
	
	["i8"] = { ['name'] = "BMW i8", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["nissangtrnismo"] = { ['name'] = "Nissan GTR Nismo", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["nissan370z"] = { ['name'] = "Nissan 370Z", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["raptor2017"] = { ['name'] = "Ford Raptor 2017", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },	
	["ferrariitalia"] = { ['name'] = "Ferrari Italia 478", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["lamborghinihuracan"] = { ['name'] = "Lamborghini Huracan", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["nissangtr"] = { ['name'] = "Nissan GTR", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bmwm4gts"] = { ['name'] = "BMW M4 GTS", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["mazdarx7"] = { ['name'] = "Mazda RX7", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["nissanskyliner34"] = { ['name'] = "Nissan Skyline R34", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bc"] = { ['name'] = "Pagani Huayra", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["toyotasupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["488gtb"] = { ['name'] = "Ferrari 488 GTB", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["fxxkevo"] = { ['name'] = "Ferrari FXXK Evo", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["m2"] = { ['name'] = "BMW M2", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["p1"] = { ['name'] = "Mclaren P1", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bme6tun"] = { ['name'] = "BMW M5", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["aperta"] = { ['name'] = "La Ferrari", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bettle"] = { ['name'] = "New Bettle", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["senna"] = { ['name'] = "Mclaren Senna", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["rmodx6"] = { ['name'] = "BMW X6", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bnteam"] = { ['name'] = "Bentley", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["rmodlp770"] = { ['name'] = "Lamborghini Centenario", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["divo"] = { ['name'] = "Buggati Divo", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["s15"] = { ['name'] = "Nissan Silvia S15", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["amggtr"] = { ['name'] = "Mercedes AMG", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["slsamg"] = { ['name'] = "Mercedes SLS", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["lamtmc"] = { ['name'] = "Lamborghini Terzo", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["vantage"] = { ['name'] = "Aston Martin Vantage", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["urus"] = { ['name'] = "Lamborghini Urus", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["amarok"] = { ['name'] = "VW Amarok", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["g65amg"] = { ['name'] = "Mercedes G65", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["celta"] = { ['name'] = "Celta Paredão", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["palameila"] = { ['name'] = "Porsche Panamera", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["rsvr16"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["veneno"] = { ['name'] = "Lamborghini Veneno", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["eleanor"] = { ['name'] = "Mustang Eleanor", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["rmodamgc63"] = { ['name'] = "Mercedes AMG C63", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["19ramdonk"] = { ['name'] = "Dodge Ram Donk", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["silv86"] = { ['name'] = "Silverado Donk", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["ninjah2"] = { ['name'] = "Ninja H2", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["70camarofn"] = { ['name'] = "camaro Z28 1970", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["agerars"] = { ['name'] = "Koenigsegg Agera RS", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["fc15"] = { ['name'] = "Ferrari California", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["msohs"] = { ['name'] = "Mclaren 688 HS", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["gt17"] = { ['name'] = "Ford GT 17", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["19ftype"] = { ['name'] = "Jaguar F-Type", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bbentayga"] = { ['name'] = "Bentley Bentayga", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["nissantitan17"] = { ['name'] = "Nissan Titan 2017", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["911r"] = { ['name'] = "Porsche 911R", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["trr"] = { ['name'] = "KTM TRR", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bmws"] = { ['name'] = "BMW S1000", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["cb500x"] = { ['name'] = "Honda CB500", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["hcbr17"] = { ['name'] = "Honda CBR17", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["defiant"] = { ['name'] = "AMC Javelin 72", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["f12tdf"] = { ['name'] = "Ferrari F12 TDF", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["71gtx"] = { ['name'] = "Plymouth 71 GTX", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["porsche992"] = { ['name'] = "Porsche 992", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["18macan"] = { ['name'] = "Porsche Macan", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["m6e63"] = { ['name'] = "BMW M6 E63", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["africat"] = { ['name'] = "Honda CRF 1000", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["regera"] = { ['name'] = "Koenigsegg Regera", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["180sx"] = { ['name'] = "Nissan 180SX", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["filthynsx"] = { ['name'] = "Honda NSX", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["2018zl1"] = { ['name'] = "Camaro ZL1", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["eclipse"] = { ['name'] = "Mitsubishi Eclipse", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["lp700r"] = { ['name'] = "Lamborghini LP700R", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["db11"] = { ['name'] = "Aston Martin DB11", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["SVR14"] = { ['name'] = "Ranger Rover", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["evoque"] = { ['name'] = "Ranger Rover Evoque", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["Bimota"] = { ['name'] = "Ducati Bimota", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["r8ppi"] = { ['name'] = "Audi R8 PPI Razor", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["20r1"] = { ['name'] = "Yamaha YZF R1", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["mt03"] = { ['name'] = "Yamaha MT 03", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["yzfr125"] = { ['name'] = "Yamaha YZF R125", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["pistas"] = { ['name'] = "Ferrari Pista", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bobbes2"] = { ['name'] = "Harley D. Bobber S", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["bobber"] = { ['name'] = "Harley D. Bobber ", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["911tbs"] = { ['name'] = "Porsche 911S", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["rc"] = { ['name'] = "KTM RC", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["zx10r"] = { ['name'] = "Kawasaki ZX10R", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["fox600lt"] = { ['name'] = "McLaren 600LT", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxbent1"] = { ['name'] = "Bentley Liter 1931", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxevo"] = { ['name'] = "Lamborghini EVO", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["jeepg"] = { ['name'] = "Jeep Gladiator", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxharley1"] = { ['name'] = "Harley-Davidson Softail F.B.", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxharley2"] = { ['name'] = "2016 Harley-Davidson Road Glide", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxleggera"] = { ['name'] = "Aston Martin Leggera", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxrossa"] = { ['name'] = "Ferrari Rossa", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxshelby"] = { ['name'] = "Ford Shelby GT500", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxsian"] = { ['name'] = "Lamborghini Sian", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxsterrato"] = { ['name'] = "Lamborghini Sterrato", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["foxsupra"] = { ['name'] = "Toyota Supra", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["m6x6"] = { ['name'] = "Mercedes Benz 6x6", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["m6gt3"] = { ['name'] = "BMW M6 GT3", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },		
	["w900"] = { ['name'] = "Kenworth W900", ['price'] = 1000000, ['tipo'] = "exclusive", ["mala"] = 50 },

	["pounder"] = { ['name'] = "Pounder", ['price'] = 1000000, ['tipo'] = "work", ["mala"] = 10 },
	["youga2"] = { ['name'] = "Youga XL", ['price'] = 1000000, ['tipo'] = "work", ["mala"] = 10 },

	["thrax"] = { ['name'] = "Thrax", ['price'] = 12000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["zorrusso"] = { ['name'] = "Zorrusso", ['price'] = 12000000, ['tipo'] = "exclusive", ["mala"] = 50 },
	["krieger"] = { ['name'] = "Krieger", ['price'] = 12000000, ['tipo'] = "exclusive", ["mala"] = 50 },


}

--[ VEHICLEGLOBAL ]-------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleGlobal()
	return vehglobal
end

--[ VEHICLENAME ]---------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleName(vname)
	return vehglobal[vname].name
end

--[ VEHICLECHEST ]--------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleChest(vname)
	return vehglobal[vname].mala
end

--[ VEHICLEPRICE ]--------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehiclePrice(vname)
	return vehglobal[vname].price
end

--[ VEHICLETYPE ]---------------------------------------------------------------------------------------------------------------------------------------

function vRP.vehicleType(vname)
	return vehglobal[vname].tipo
end

--[ ACTIVED ]-------------------------------------------------------------------------------------------------------------------------------------------

local actived = {}
local activedAmount = {}
Citizen.CreateThread(function()
	while true do
		for k,v in pairs(actived) do
			if actived[k] > 0 then
				actived[k] = v - 1
				if actived[k] <= 0 then
					actived[k] = nil
					activedAmount[k] = nil
				end
			end
		end
		Citizen.Wait(100)
	end
end)

--[ STORE CHEST ]---------------------------------------------------------------------------------------------------------------------------------------

function vRP.storeChestItem(user_id,chestData,itemName,amount,chestWeight)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then

			if parseInt(amount) > 0 then
				activedAmount[user_id] = parseInt(amount)
			else
				return false
			end

			local new_weight = vRP.computeItemsWeight(items) + vRP.getItemWeight(itemName) * parseInt(activedAmount[user_id])
			if new_weight <= parseInt(chestWeight) then
				if vRP.tryGetInventoryItem(parseInt(user_id),itemName,parseInt(activedAmount[user_id])) then
					if items[itemName] ~= nil then
						items[itemName].amount = parseInt(items[itemName].amount) + parseInt(activedAmount[user_id])
					else
						items[itemName] = { amount = parseInt(activedAmount[user_id]) }
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end

--[ TAKE CHEST ]----------------------------------------------------------------------------------------------------------------------------------------

function vRP.tryChestItem(user_id,chestData,itemName,amount)
	if actived[user_id] == nil then
		actived[user_id] = 1
		local data = vRP.getSData(chestData)
		local items = json.decode(data) or {}
		if data and items ~= nil then
			if items[itemName] ~= nil and parseInt(items[itemName].amount) >= parseInt(amount) then

				if parseInt(amount) > 0 then
					activedAmount[user_id] = parseInt(amount)
				else
					return false
				end

				local new_weight = vRP.getInventoryWeight(parseInt(user_id)) + vRP.getItemWeight(itemName) * parseInt(activedAmount[user_id])
				if new_weight <= vRP.getInventoryMaxWeight(parseInt(user_id)) then
					vRP.giveInventoryItem(parseInt(user_id),itemName,parseInt(activedAmount[user_id]))

					items[itemName].amount = parseInt(items[itemName].amount) - parseInt(activedAmount[user_id])

					if parseInt(items[itemName].amount) <= 0 then
						items[itemName] = nil
					end

					vRP.setSData(chestData,json.encode(items))
					return true
				end
			end
		end
	end
	return false
end