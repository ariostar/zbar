local _G = getfenv(0)
--[[
	< Arrangements >
	All functions in this part is for arrangement changing,
	funny arrangement function is too big, so put it at the EOF
--]]
-- [[ arrangement ]] --
function zBarT:UpdateLayouts()
	local name = self:GetName()
	-- get the button spacing
	if not zBar2Saves[name].inset then
		zBar2Saves[name].inset = 6
	end
	local value = zBar2Saves[name]
	if not value.num or value.num < 2 then return end
	-- call function for arrangement changing
	if value.layout == "line" then
		self:SetLineNum()
	elseif value.layout == "suit1" then
		self:SetSuit(value.layout)
	elseif value.layout == "suit2" then
		self:SetSuit(value.layout)
	end
end
-- local func, for points settings
local function SetButtonPoint(bar,index,point,referIndex,relativePoint,offx,offy)
	local button = _G[zBar2.buttons[bar:GetName()..index]]
	button:ClearAllPoints()
	button:SetPoint(point,zBar2.buttons[bar:GetName()..referIndex],relativePoint,offx,offy)
end
--~ line arrangement
function zBarT:SetLineNum()
	local value = zBar2Saves[self:GetName()]
	local inset = value.inset
	
	if not value.linenum then
		zBar2Saves[self:GetName()].linenum = 1
	end
	if self == zMicroBar then
		inset = inset - 2
	end

	-- loop to settle every button
	local cur_id
	-- row
	for i = 1, ceil(value.num/value.linenum) do
		-- column
		for j = 1, value.linenum do
			-- get current button id first
			cur_id = (i-1)*value.linenum + j
			-- break when loop out of index
			if cur_id > value.num then break end

			-- place them one by one
			if cur_id > 1 then -- skip the first button
				if j == 1 then -- first button in each line should be placed to left edge
					if self == zMicroBar then -- MicroButtons should adjust buttons y-inset
						SetButtonPoint( self, cur_id, "TOP", cur_id - value.linenum, "BOTTOM", 0, -inset+20)
					else
						SetButtonPoint( self, cur_id, "TOP", cur_id - value.linenum, "BOTTOM", 0, -inset)
					end
				else -- siblings goes my right side
					SetButtonPoint( self, cur_id, "LEFT", cur_id - 1, "RIGHT", inset, 0)
				end
			end
		end
	end
end

function zBarT:SetSuit(suitname)
	local inset = zBar2Saves[self:GetName()].inset
	local num = zBar2Saves[self:GetName()].num
	if num == 1 then return end
	for id, pos in pairs(self[suitname][num]) do
		SetButtonPoint(self, id, pos[1], pos[2], pos[3], inset*pos[4], inset*pos[5])
	end
end

--[[ Data ]]
zBarT.suit1 = {
	[2] = {
		[2] = {"TOPLEFT", 1, "BOTTOMRIGHT", 1, -1},
	},
	[3] = {
		[2] = {"TOPRIGHT", 1, "BOTTOM", -0.5, -1},
		[3] = {"TOPLEFT", 1, "BOTTOM", 1, -1},
	},
	[4] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"TOP", 1, "BOTTOM", 0, -1},
		[4] = {"LEFT", 3, "RIGHT", 1, 0}
	},
	[5] = {
		[2] = {"TOP", 1, "BOTTOM", 0, -1},
		[3] = {"RIGHT", 2, "LEFT", -1, 0},
		[4] = {"LEFT", 2, "RIGHT", 1, 0},
		[5] = {"TOP", 2, "BOTTOM", 0, -1},
	},
	[6] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
	},
	[7] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"TOPRIGHT", 1, "BOTTOM", -0.5, -1},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"TOPLEFT", 3, "BOTTOM", 0.5, -1},
		[7] = {"LEFT", 6, "RIGHT", 1, 0},
	},
	[8] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"TOP", 1, "BOTTOM", 0, -1},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"LEFT", 6, "RIGHT", 1, 0},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
	},
	[9] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 4, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
	},
	[10] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"TOPRIGHT", 1, "BOTTOM", -0.5, -1},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"LEFT", 6, "RIGHT", 1, 0},
		[8] = {"TOPLEFT", 4, "BOTTOM", 0.5, -1},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
		[10] = {"LEFT", 9, "RIGHT", 1, 0},
	},
	[11] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"TOPLEFT", 1, "BOTTOM", 0.5, -1},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"LEFT", 6, "RIGHT", 1, 0},
		[8] = {"TOPRIGHT", 5, "BOTTOM", -0.5, -1},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
		[10] = {"LEFT", 9, "RIGHT", 1, 0},
		[11] = {"LEFT", 10, "RIGHT", 1, 0},
	},
	[12] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 4, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
		[10] = {"TOP", 7, "BOTTOM", 0, -1},
		[11] = {"LEFT", 10, "RIGHT", 1, 0},
		[12] = {"LEFT", 11, "RIGHT", 1, 0},
	},
}
zBarT.suit2 = {
	[2] = {
		[2] = {"TOPRIGHT", 1, "BOTTOMLEFT", -1, -1},
	},	
	[3] = {
		[2] = {"TOPRIGHT", 1, "BOTTOM", -0.5, -1},
		[3] = {"TOPLEFT", 1, "BOTTOM", 0.5, -1},
	},	
	[4] = {
		[2] = {"TOPRIGHT", 1, "LEFT", -1, -0.5},
		[3] = {"TOPLEFT", 1, "RIGHT", 1, -0.5},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
	},	
	[5] = {
		[3] = {"LEFT", 1, "RIGHT", 1, 0},
		[2] = {"TOPLEFT", 1, "BOTTOM", 0.5, -1},
		[4] = {"TOPRIGHT", 2, "BOTTOM", -0.5, -1},
		[5] = {"TOPLEFT", 2, "BOTTOM", 0.5, -1},
	},	
	[6] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"TOP", 1, "BOTTOM", 0, -1},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"TOP", 3, "BOTTOM", 0, -1},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
	},	
	[7] = {
		[2] = {"TOPRIGHT", 1, "LEFT", -1, -0.5},
		[3] = {"TOPLEFT", 1, "RIGHT", 1, -0.5},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
		[5] = {"TOPRIGHT", 4, "LEFT", -1, -0.5},
		[6] = {"TOPLEFT", 4, "RIGHT", 1, -0.5},
		[7] = {"TOP", 4, "BOTTOM", 0, -1},
	},	
	[8] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"TOP", 1, "BOTTOM", 0, -1},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"TOP", 3, "BOTTOM", 0, -1},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 5, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
	},	
	[9] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"TOP", 1, "BOTTOM", 0, -1},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 4, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
	},	
	[10] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"TOP", 1, "BOTTOM", 0, -1},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"TOP", 3, "BOTTOM", 0, -1},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 5, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
		[9] = {"TOP", 7, "BOTTOM", 0, -1},
		[10] = {"LEFT", 9, "RIGHT", 1, 0},
	},	
	[11] = {
		[2] = {"BOTTOMRIGHT", 1, "LEFT", -1, 0.5},
		[3] = {"BOTTOMRIGHT", 2, "LEFT", -1, 0.5},
		[4] = {"BOTTOMRIGHT", 3, "TOP", -0.5, 1},
		[5] = {"BOTTOMRIGHT", 4, "TOP", -0.5, 1},
		[6] = {"BOTTOMLEFT", 5, "TOP", 0.5, 1},
		[7] = {"BOTTOMLEFT", 1, "RIGHT", 1, 0.5},
		[8] = {"BOTTOMLEFT", 7, "RIGHT", 1, 0.5},
		[9] = {"BOTTOMLEFT", 8, "TOP", 0.5, 1},
		[10] = {"BOTTOMLEFT", 9, "TOP", 0.5, 1},
		[11] = {"BOTTOMRIGHT", 10, "TOP", -0.5, 1},
	},	
	[12] = {
		[2] = {"LEFT", 1, "RIGHT", 1, 0},
		[3] = {"LEFT", 2, "RIGHT", 1, 0},
		[4] = {"LEFT", 3, "RIGHT", 1, 0},
		[5] = {"LEFT", 4, "RIGHT", 1, 0},
		[6] = {"LEFT", 5, "RIGHT", 1, 0},
		[7] = {"TOP", 1, "BOTTOM", 0, -1},
		[8] = {"LEFT", 7, "RIGHT", 1, 0},
		[9] = {"LEFT", 8, "RIGHT", 1, 0},
		[10] = {"LEFT", 9, "RIGHT", 1, 0},
		[11] = {"LEFT", 10, "RIGHT", 1, 0},
		[12] = {"LEFT", 11, "RIGHT", 1, 0},
	},	
}
