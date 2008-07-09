local _G = getfenv(0)
--[[
	Functions for Derivates
--]]

-- template for common functions of bars
zBarT = CreateFrame("Frame",nil,UIParent,"SecureStateHeaderTemplate")

--[[ reset profile, scale, position to DEFAULT for any bar ]]
function zBarT:Reset(resetsaves)
	local name = self:GetName()
	-- reset profile
	if resetsaves or not zBar2Saves[name] then
		zBar2Saves[name] = zBar2:GetDefault(self,"saves")
		zBar2Saves[name].pos = zBar2:GetDefault(self,"pos")
	end

	-- reset scale
	self:SetScale(zBar2Saves[name]["scale"] or 1)
	self:GetTab():SetScale(self:GetScale())
	-- reset alpha
	self:SetAlpha(zBar2Saves[name].alpha or 1)
	-- name plate
	if zBar2Saves[name].label then self:GetLabel():Show() end

	-- remove tab from master tab's cortege list
	if self:GetTab().master then
		tDeleteItem(self:GetTab().master.cortege, self:GetTab():GetName())
		self:GetTab().master = nil
	end
	-- remove tab's corteges
	if self:GetTab().cortege then
		for n, name in ipairs(self:GetTab().cortege) do
			_G[name]:ClearAllPoints()
			table.remove(self:GetTab().cortege, n)
			_G[name].master = nil
		end
	end

	-- reset position
	local pos = zBar2Saves[name].pos or zBar2:GetDefault(self, "pos")
	self:GetTab():ClearAllPoints()
	if type(pos[2]) == "string" then
		self:GetTab():SetPoint(pos[1],UIParent,pos[2],pos[3],pos[4])
	else
		self:GetTab():SetPoint(pos[1],UIParent,pos[1],pos[2],pos[3])
	end
	self:ClearAllPoints()
	self:SetPoint("TOP",self:GetTab(),"BOTTOM",0,0)

	-- update all
	self:UpdateVisibility()
	self:UpdateButtons()
	self:UpdateLayouts()
	self:UpdateHotkeys()
	self:UpdateAutoPop()
end

function zBarT:UpdateVisibility()
	local state
	if zBar2Saves[self:GetName()].hide then
		state = 0
	else
		state = 1
	end
	if zBar2Saves[self:GetName()].hideTab then state = state + 2 end
	self:GetHeader():SetAttribute("state", state)
end

function zBarT:UpdateAutoPop()
	local header = self:GetHeader()
	UnregisterStateDriver(header, "visibility")
	if zBar2Saves[self:GetName()].inCombat then
		if "autoPop" == zBar2Saves[self:GetName()].inCombat then
			RegisterStateDriver(header, "visibility", "[combat][harm,nodead]show;hide")
		elseif "autoHide" == zBar2Saves[self:GetName()].inCombat then
			RegisterStateDriver(header, "visibility", "[combat][harm,nodead]hide;show")
		end
	else
		header:Show()
	end
end

--[[ update buttons, hide unwanted buttons ]]
function zBarT:UpdateButtons()
	local button
	local value = zBar2Saves[self:GetName()]

	if value.max == 0 then return end

	for i =  1, value.max or NUM_ACTIONBAR_BUTTONS do
		button = _G[zBar2.buttons[self:GetName()..i]]
		if button then
			if i <= (value.num or 1) then
				if _G[button:GetName().."AutoCast"] then
					if PetActionBarFrame.showgrid > 0 or GetPetActionInfo(i) then
						button:Show()
					end
				elseif not button.action 
				or (button:GetAttribute("showgrid") > 0 or HasAction(button.action)) then
					button:Show()
				end
				button:SetAttribute("showstates", nil)
				button:SetAttribute("statehidden", nil)
			else
				button:Hide()
				button:SetAttribute("showstates", "!*")
				button:SetAttribute("statehidden", true)
			end
		end
	end
end

--[[ enable / disable hotkey text shown for bar ]]
function zBarT:UpdateHotkeys()
	local hotkey

	for i = 1 , zBar2Saves[self:GetName()].max or NUM_ACTIONBAR_BUTTONS do
		hotkey = _G[ (zBar2.buttons[self:GetName()..i] or "?? ").."HotKey"]
		if hotkey then
			if zBar2Saves[self:GetName()].hideHotkey then
				hotkey:Hide()
				hotkey.zShow = hotkey.Show
				hotkey.Show = zBar2.NOOP
			elseif hotkey.zShow then
				hotkey.Show = hotkey.zShow
				if hotkey:GetText() ~= RANGE_INDICATOR then
					hotkey:Show()
				end
			end
		end
	end
end

function zBarT:GetHeader()
	local id = self:GetID()
	local header = _G["zBar2Header"..id]
	if header then return header end

	header = CreateFrame("Frame", "zBar2Header"..id, UIParent, "SecureStateHeaderTemplate")
	header:SetID(id)

	self:SetAttribute("showstates","1,3")
	header:SetAttribute("addchild", self)
	header:SetAttribute("addchild", self:GetTab())

	return header
end

--[[ get localized bar name as label ]]
function zBarT:GetLabel()
	local label = _G[self:GetName().."Label"]

	if not label then
		label = self:GetHeader():CreateFontString(self:GetName().."Label", "ARTWORK", "GameFontGreen")
		label:SetPoint("BOTTOM", self:GetTab(), "TOP", 0, 0)
		label:SetText( zBar2.loc.Labels[self:GetName()] or self:GetName() )
	end

	return label
end

-- overwrite this if needed
function zBarT:GetChildSizeAdjust(attachPoint)
	return 0, 0
end

-- get tab of bar, create if not exist
function zBarT:GetTab()
	local id = self:GetID()
	local tab = _G["zTab"..id]
	if tab then return tab end

	tab = CreateFrame("Button", "zTab"..id, UIParent, "zBarTabTemplate")
	tab:SetID(id)
	tab:RegisterForDrag("LeftButton")
	tab:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	tab:SetScript("OnDragStart",zTab.OnDragStart)
	tab:SetScript("OnDragStop",zTab.OnDragStop)

	tab:SetAttribute("type2", "OnMenu")
	tab.OnMenu = function(self, unit, button)
		if not zBarOption then zBar2:print("Option not been loaded") return end
		zBarOption:Openfor(this.bar)
	end

	tab:SetAttribute("newstate1","0,1")
	tab:SetAttribute("showstates","0,1")

	tab:SetScale(self:GetScale())
	tab:SetFrameLevel(self:GetFrameLevel() + 5)

	tab:SetWidth(self:GetWidth())

	tab.bar = self

	return tab
end
