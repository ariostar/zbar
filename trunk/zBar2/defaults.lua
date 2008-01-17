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

function zBar2:SetGameDefaults()
	if zBar2.lite then return end
	-- game default positions
	UIPARENT_MANAGED_FRAME_POSITIONS["ItemRefTooltip"] = {baseY = 150, pet =35,};
	UIPARENT_MANAGED_FRAME_POSITIONS["GroupLootFrame1"] = {baseY = 135, pet =35,};
	UIPARENT_MANAGED_FRAME_POSITIONS["TutorialFrameParent"] = {baseY = 135, pet = 35,};
	UIPARENT_MANAGED_FRAME_POSITIONS["CONTAINER_OFFSET_Y"] = {baseY = 135, isVar = "yAxis",};
	UIPARENT_MANAGED_FRAME_POSITIONS["CONTAINER_OFFSET_X"] = {baseX = 85, isVar = "xAxis"};
	UIPARENT_MANAGED_FRAME_POSITIONS["ChatFrame1"] = 
		{baseY = 30, point = "BOTTOMLEFT", rpoint = "BOTTOMLEFT", xOffset = 32};
	UIPARENT_MANAGED_FRAME_POSITIONS["ChatFrame2"] = 
		{baseY = 135, rightLeft = -90, rightRight = -45, point = "BOTTOMRIGHT", rpoint = "BOTTOMRIGHT", xOffset = -32};
	
	if self.firstime then
		ChatFrame1:SetWidth(360)
		ChatFrame1:SetUserPlaced(false)
		ItemRefTooltip:SetUserPlaced(false)
		UIParent_ManageFramePositions()
	end

	-- disable Jostle to refresh some frames
--~ 	if AceLibrary and AceLibrary:HasInstance("Jostle-2.0") then
--~ 		self.JostleXXX = {
--~ 			DEFAULT_CHAT_FRAME = true,
--~ 			ChatFrame2 = true,
--~ 			GroupLootFrame1 = true,
--~ 			TutorialFrameParent = true,
--~ 			FramerateLabel = true,
--~ 			CastingBarFrame = true,
--~ 		}
--~ 		local jostle = AceLibrary("Jostle-2.0")
--~ 		local orig = jostle.Refresh
--~ 		jostle.Refresh = function(self, ...)
--~ 			if select('#', ...) < 1 then
--~ 				for name,value in pairs(zBar2.JostleXXX) do
--~ 					zBar2.JostleXXX[name] = _G[name]
--~ 					_G[name] = nil
--~ 				end
--~ 				orig(self, ...)
--~ 				for name, value in pairs(zBar2.JostleXXX) do
--~ 					_G[name] = value
--~ 				end
--~ 			end
--~ 		end
--~ 	end
end

-- zBar2 defaults
zBar2.defaults = {
	["*"] = {saves = {num = 12, inset = 0, layout = "line", linenum = 2, alpha = 1,},},
	["zExBar1"] = { saves = {},
		pos = {"CENTER",0,0}, 
	},
	["zShadow1"] = { saves = {num=0, max=0,},
		pos = {"CENTER",72,0}, 
	},
	["zExBar2"] = { saves = {},
		pos = {"CENTER",-72,0}, 
	},
	["zShadow2"] = { saves = {num=0, max=0,},
		pos = {"CENTER",-144,0}, 
	},
	
	["zMainBar"] = {
		saves = {linenum = 12, hideTab=true,},
		pos = {"BOTTOM",-100,30}, 
	},
	["zMultiR2"] = {
		saves = {linenum = 1,},
		pos ={"BOTTOMRIGHT",-47,500},
	},
	["zMultiR1"] = {
		saves = {linenum = 1,},
		pos ={"BOTTOMRIGHT",-7,500},
	},
	["zMultiBR"] = {
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,102},
	},
	["zMultiBL"] = {
		saves = {linenum = 12, hideTab=true,},
		pos ={"BOTTOM",-100,66},
	},

	["zPetBar"] = {
		saves = {num = 10, inset = 6, linenum = 10, max = 10, scale = 0.8, hideTab=true,},
		pos = {"BOTTOM",-100,180},
	},
	["zStanceBar"] = {
		saves = {num=10, inset = 10, linenum = 10, max = 10, scale = 0.8, hideTab=true,},
		pos = {"BOTTOM",-100,180},
	},
	["zBagBar"] = {
		saves = {num=6, linenum=6, max=6, scale=0.72,},
		pos = {"BOTTOMRIGHT",-190,78},
	},
	["zMicroBar"] = {
		saves = {num=8, linenum=8, max=8, scale=0.75,},
		pos = {"BOTTOMRIGHT",-190,38},
	},
	["zXPBar"] = {
		saves = {num = 0, max = 0, scale=0.5,},
		pos = {"TOP",0,-200},
	},
	["zCastBar"] = {
		saves = {num = 0, max = 0, hideTab=true,},
		pos={"BOTTOM",0,170},
	},
}