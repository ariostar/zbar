local _G = getfenv(0)
--[[
	Usage: zBar2:GetDefault("zMainBar")
	or : zBar2:GetDefault("zMainBar", "pos")
--]]
local k,v,m,n
function zBar2:GetDefault(name, key, subkey)
	if type(name) == "table" then
		name = name:GetName()
	end

	-- copy
	local set = {}
	for k,v in pairs(zBar2.defaults[name]) do
		if type(v) == "table" then
			set[k] = {}
			for m,n in pairs(v) do
				set[k][m] = n
			end
		else
			set[k] = v
		end
	end

	-- common values
	for k,v in pairs(zBar2.defaults["*"]) do
		if set[k] then
			for m,n in pairs(v) do
				if set[k][m] == nil then set[k][m] = n end
			end
		end
	end

	if key then
		set = set[key]
		if subkey then set = set[subkey] end
	end

	return set
end

-- zBar2 defaults
zBar2.defaults = {
	["*"] = {saves = {num = 12, inset = 0, layout = "line", linenum = 2, alpha = 1,},},
	["zExBar1"] = { saves = { num=6,},
		pos = {"CENTER",0,0},
	},
	["zShadow1"] = { saves = {num=6, max=6,},
		pos = {"CENTER",72,0},
	},
	["zExBar2"] = { saves = { num=6,},
		pos = {"CENTER",-72,0},
	},
	["zShadow2"] = { saves = {num=6, max=6,},
		pos = {"CENTER",-144,0},
	},

	["zMainBar"] = {
		saves = {linenum = 12, hideTab=true,},
		pos = {"BOTTOM",-100,60-24},
	},
	["zMultiR2"] = {
		saves = {linenum = 1,},
		pos ={"BOTTOMRIGHT",-47,530-24},
	},
	["zMultiR1"] = {
		saves = {linenum = 1,},
		pos ={"BOTTOMRIGHT",-7,530-24},
	},
	["zMultiBR"] = {
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,132-24},
	},
	["zMultiBL"] = {
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,96-24},
	},

	["zPetBar"] = {
		saves = {num = 10, inset = 6, linenum = 10, max = 10, scale = 0.8,
			hideTab=true,hideHotkey=true,},
		pos = {"BOTTOM",-100,222-24/0.8},
	},
	["zStanceBar"] = {
		saves = {num=10, inset = 10, linenum = 10, max = 10, scale = 0.8,
			hideTab=true,hideHotkey=true,},
		pos = {"BOTTOM",-100,222-24/0.8},
	},
	["zPossessBar"] = {
		saves = {num=2, inset = 10, linenum = 2, max = 2, scale = 0.8,
			hideTab=true,hideHotkey=true,},
		pos = {"BOTTOM",330,222-24/0.8},
	},
	["zBagBar"] = {
		saves = {num=6, linenum=6, max=6, scale=0.9, hideTab=true, invert=true},
		pos = {"BOTTOMRIGHT",-3,90-24/0.9},
	},
	["zMicroBar"] = {
		saves = {num=10, linenum=10, max=10, scale=0.6, hideTab=true,},
		pos = {"BOTTOMRIGHT",-238,80-24/0.6},
	},
	["zXPBar"] = {
		saves = {num = 3, max = 3, scale=0.422,},
		pos = {"BOTTOM",230, 333-24/0.422},
	},
	["zCastBar"] = {
		saves = {num = 2, max = 2, hideTab=true,},
		pos={"BOTTOM",0,205-24},
	},
}