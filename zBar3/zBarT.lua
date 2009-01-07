local _G = getfenv(0)
--[[
	Functions for Derivates
--]]

-- template for common functions of bars
zBarT = CreateFrame("Frame",nil,UIParent,"SecureHandlerShowHideTemplate")

-- hover to expand
function zBarT:Init()
	if not self.Execute then return end -- not a handler
	self:Execute([[buttons = table.new(self:GetChildren())]])
	self:SetAttribute('_onhide', [[
		for i, button in ipairs(buttons) do
			handle:WrapScript(button,"OnEnter",[[
				self:SetTimer('Collapse')
			]])
		end
	]])
end

--[[ reset profile, scale, position to DEFAULT for any bar ]]
function zBarT:Reset(resetsaves)
	local db = zBar3Data
	local name = self:GetName()
	
	-- reset profile
	if resetsaves or not db[name] then
		db[name] = zBar3:GetDefault(self,"saves")
		db[name].pos = zBar3:GetDefault(self,"pos")
	end
	-- reset scale
	self:SetScale(db[name]["scale"] or 1)
	self:GetTab():SetScale(self:GetScale())
	-- reset alpha
	self:SetAlpha(db[name].alpha or 1)
	-- name plate
	if db[name].label then self:GetLabel():Show() end

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
	local pos = db[name].pos or zBar3:GetDefault(self, "pos")
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
	if zBar3Data[self:GetName()].hide then
		self:Hide()
	else
		self:Show()
	end
	if zBar3Data[self:GetName()].hideTab then
		self:GetTab():Hide()
	else
		self:GetTab():Show()
	end
end

function zBarT:UpdateAutoPop()
	local db = zBar3Data[self:GetName()]
	UnregisterStateDriver(self, "visibility")
	if not db.inCombat then
		self:Show()
	else
		if "autoPop" == db.inCombat then
			RegisterStateDriver(self, "visibility", "[combat][harm,nodead]show;hide")
		elseif "autoHide" == db.inCombat then
			RegisterStateDriver(self, "visibility", "[combat][harm,nodead]hide;show")
		end
	end
end

--[[ update buttons, hide unwanted buttons ]]
function zBarT:UpdateButtons()
	local button
	local db = zBar3Data[self:GetName()]

	if db.max == 0 then return end

	for i = 1, db.max or NUM_ACTIONBAR_BUTTONS do
		button = self:GetButton(i)
		assert(button)
		if i <= (db.num or 1) then
			if _G[button:GetName().."AutoCast"] then
				if PetActionBarFrame.showgrid > 0 or GetPetActionInfo(i) then
					button:Show()
				end
			elseif not button.action 
			or (button:GetAttribute("showgrid") > 0 or HasAction(button.action)) then
				button:Show()
			end
			--button:SetAttribute("showstates", nil)
			button:SetAttribute("statehidden", nil)
		else
			button:Hide()
			--button:SetAttribute("showstates", "!*")
			button:SetAttribute("statehidden", true)
		end
	end
end

--[[ enable / disable hotkey text shown for bar ]]
function zBarT:UpdateHotkeys()
	local hotkey

	for i = 1 , zBar3Data[self:GetName()].max or NUM_ACTIONBAR_BUTTONS do
		hotkey = _G[ (zBar3.buttons[self:GetName()..i] or "?? ").."HotKey"]
		if hotkey then
			if zBar3Data[self:GetName()].hideHotkey then
				hotkey:Hide()
				hotkey.zShow = hotkey.Show
				hotkey.Show = zBar3.NOOP
			elseif hotkey.zShow then
				hotkey.Show = hotkey.zShow
				if hotkey:GetText() ~= RANGE_INDICATOR then
					hotkey:Show()
				end
			end
		end
	end
end

--[[ get localized bar name as label ]]
function zBarT:GetLabel()
	local label = _G[self:GetName().."Label"]

	if not label then
		label = self:GetTab():CreateFontString(self:GetName().."Label", "ARTWORK", "GameFontGreen")
		label:SetPoint("BOTTOM", self:GetTab(), "TOP", 0, 0)
		label:SetText( zBar3.loc.Labels[self:GetName()] or self:GetName() )
	end

	return label
end

function zBarT:GetButton(id)
	return _G[zBar3.buttons[self:GetName()..id]]
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
	tab:SetScript("OnDragStart", function(self) zTab:OnDragStart(self) end)
	tab:SetScript("OnDragStop", function(self) zTab:OnDragStop(self) end)

	tab:SetFrameRef('bar', self)
	-- collapse and expand
	tab:SetAttribute("_onclick", [[
		local bar = self:GetFrameRef('bar')
		if button == 'RightButton' then
			control:CallMethod('OnMenu')
		elseif button == 'LeftButton' then
			if bar:IsShown() then
				bar:Hide()
				bar:SetAttribute('collapsed', true)
			else
				bar:Show()
				bar:SetAttribute('collapsed', nil)
			end
		end
	]])
	
	tab.OnMenu = function(self, unit, button)
		if not zBarOption then zBar3:print("Option not been loaded") return end
		zBarOption:Openfor(this.bar)
	end

	tab:SetAttribute("_onenter", [[local bar = self:GetFrameRef('bar')
		if bar:GetAttribute('collapsed') then bar:Show() end
	]])
	tab:SetAttribute("_onleave", [[local bar = self:GetFrameRef('bar')
		if bar:GetAttribute('collapsed') then bar:Hide() end
	]])

	tab:SetScale(self:GetScale())
	tab:SetFrameLevel(self:GetFrameLevel() + 5)

	tab:SetWidth(self:GetWidth())

	tab.bar = self

	return tab
end
