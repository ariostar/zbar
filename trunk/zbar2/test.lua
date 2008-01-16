local function tprint(e)
	if type(e) == "table" then
		print("{ -- "..tostring(e))
		for k,v in pairs(e) do
			print("\t"..k.." = "..tostring(v))
		end
		print("}")
	else
		print(tostring(e))
	end
end
--~ ====================================



zBar2 = {}

function zBar2:GetDefault(name)
	if type(name) == "table" then
		name = name:GetName()
	end
	
	local set = {}
	for k,v in pairs(zBar2.defaults[name]) do
		set[k] = v
	end
	
	for k,v in pairs(zBar2.defaults["*"]) do
		if not set[k] then set[k] = v end
	end
	
	return set
end

zBar2.defaults = {
	["*"] = {num = 12, inset = 0, arrangement = "line", linenum = 2},
	["zMainBar"] = { arrangement = "line", linenum = 12, hideTab=true, pos = {"BOTTOM",-120,30,12}, },
}

local t = zBar2:GetDefault("zMainBar")
t.linenum = 0
tprint(t)
tprint(zBar2.defaults["*"])
tprint(zBar2.defaults["zMainBar"])
--~ tprint(_G._G._G._G)
