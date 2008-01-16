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
	if value.arrangement == "funny1" then
		self:SetFunny(value.inset)
	elseif value.arrangement == "funny2" then
		self:SetFunny2(value.inset)
	elseif value.arrangement == "line" then
		self:SetLineNum(value.inset)
	end
end
-- local func, for points settings
local function SetButtonPoint(bar,index,point,referIndex,relativePoint,offx,offy)
	local value = zBar2Saves[bar:GetName()]
	if(value.from) then
		index = index + value.from - 1
		referIndex = referIndex + value.from - 1
	end

	local button = _G[zBar2.buttons[bar:GetName()..index]]
	button:ClearAllPoints()
	button:SetPoint(point,zBar2.buttons[bar:GetName()..referIndex],relativePoint,offx,offy)
end
--~ line arrangement
function zBarT:SetLineNum(inset)
	local value = zBar2Saves[self:GetName()]

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