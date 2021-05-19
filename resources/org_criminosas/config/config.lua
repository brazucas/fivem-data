--local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

ConfigORG = {}
ConfigORG.debug = true
ConfigORG.org_tables_init = {}
ConfigORG.org_membros_init = {}
ConfigORG.org_fundador_init = {}

vRP.prepare("vRP/orgs_table",[[
CREATE TABLE IF NOT EXISTS vrp_orgs_data(
	nomeORG VARCHAR(100),
	valoresORG BLOB,
	CONSTRAINT pk_orgs_data PRIMARY KEY(nomeORG)
);
]])

vRP.prepare("vRP/set_orgs_data","REPLACE INTO vrp_orgs_data(nomeORG,valoresORG) VALUES(@key,@value)")
vRP.prepare("vRP/get_orgs_data","SELECT valoresORG FROM vrp_orgs_data WHERE nomeORG = @key")
vRP.prepare("vRP/get_orgs","SELECT * FROM vrp_orgs_data")

AddEventHandler("onResourceStart", function(resource)
    if resource ~= GetCurrentResourceName() then return end

	vRP.execute("vRP/orgs_table")

    local rows = vRP.query("vRP/get_orgs")
    for i = 1, #rows, 1 do
        ConfigORG.org_tables_init[rows[i].nomeORG] = json.decode(rows[i].valoresORG)
        for membro_id, valores in pairs(ConfigORG.org_tables_init[rows[i].nomeORG].membros) do
            ConfigORG.org_membros_init[membro_id] = rows[i].nomeORG
        end
        ConfigORG.org_fundador_init[ConfigORG.org_tables_init[rows[i].nomeORG].fundador] = rows[i].nomeORG
    end
	print(json.encode(ConfigORG.org_tables_init,{indent = true}))
end)