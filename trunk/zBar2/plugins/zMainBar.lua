if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zMainBar", UIParent, "SecureHandlerStateTemplate")
zBar2:RegisterPlugin(zMainBar)
zBar2:RegisterBar(zMainBar)

--[[
	functional
--]]
function zMainBar:Init()
	self:SetID(10)
	self:SetFrameStrata("HIGH")
	self:SetClampedToScreen(true)
	self:SetWidth(36) self:SetHeight(36)

	--SetModifiedClick("SELFCAST", "ALT")

	for id=1,12 do
		self:RegisterButton(_G["ActionButton"..id], id)
		zBar2.buttons["zMainBar"..id] = "ActionButton"..id
		_G["ActionButton"..id.."NormalTexture"]:SetWidth(60)
		_G["ActionButton"..id.."NormalTexture"]:SetHeight(60)
	end
	ActionButton1:ClearAllPoints()
	ActionButton1:SetPoint("CENTER")

  
  self:Execute( [[ActionButtons = table.new(self:GetChildren())]] )
  self:SetAttribute('_onstate-actionpage',[[
    for i, button in ipairs(ActionButtons) do
      button:SetAttribute('action', -button:GetID() + (newstate-1) * 12)
    end
  ]])

	--self:InitStanceMap()
	self:UpdateStateHeader()
  
	self:Hook()
	
	-- grid stuff
	zBar2:RegisterGridUpdater(self.UpdateGrid)
	self:UpdateGrid()
end

--[[
	Privates
--]]

function zMainBar:RegisterButton(button, id)
  button:SetParent(self)

	button:SetID(-id)

	button:Show()
	button.Hide = function(self) self:SetAlpha(0) end
	button.Show = function(self) self:SetAlpha(1) end
end

--[[ Hooks ]]
function zMainBar:Hook()
	hooksecurefunc("ActionButton_UpdateHotkeys", zMainBar.UpdateHotkey)

	BonusActionBarFrame:Hide()
	BonusActionBarFrame:UnregisterAllEvents()
	BonusActionBarFrame.Show = zBar2.NOOP

	--MainMenuBar:Hide()
  MainMenuBar:SetParent(zBar2.hiddenFrame)
end

function zMainBar:UpdateHotkey()
	if this:GetParent() == zMainBar then
		local hotkey = _G[this:GetName().."HotKey"]
		local text = GetBindingText(GetBindingKey(this:GetName()), "KEY_", 1)
		if ( text == "" ) then
			hotkey:SetText(RANGE_INDICATOR)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -12, -2);
			hotkey:Hide()
		else
			hotkey:SetText(text)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -2, -2)
			hotkey:Show()
		end
	end
end

function zMainBar:UpdateGrid()
	-- in combat we can't let it be shown or hidden
 	if InCombatLockdown() then return end
	for i=1, 12 do
		local button = _G["ActionButton"..i]
		button:SetAttribute("showgrid", zBar2.showgrid)
		if zBar2.showgrid > 0 then
			if not button:GetAttribute("statehidden") then
				button:Show();
				--_G[button:GetName().."NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0, 0.5)
			end
		elseif not HasAction(button.action) then
			button:Hide();
		end
	end
end

--[[ Page Mapping. partly reference to PM2 ]]
local triggers = {
	[1] = "[mod:SELFCAST]2",
	[2] = "[help]2",
}
--[[
local stances = {
	["ROGUE"] = { [1] = 7 },
	--["DRUID"] = { [1] = 9, [3] = 7, [5] = 8 },	-- moonkin/tree-of-life
	["WARRIOR"] = { [1] = 7, [2] = 8, [3] = 9 },
}
]]
function zMainBar:GetStateCommand()
	local header, state = "[bonusbar:5]11;", ""
	
	if zBar2Saves["pageTrigger"] then
		for k,v in pairs(triggers) do
			state = v .. ";"
			header = header .. state
		end
	end
  
  if zBar2Saves["catStealth"] then
    header = header .. "[bar:1,stealth]10;"
  end
--[[	
	if stances[zBar2.class] then
		for k,v in pairs(stances[zBar2.class]) do
			state = format("[bar:1,stance:%d]%d;", k, v)
			header = header .. state
		end
	end
]]
  fro i=1,4 do
    state = format("[bonusbar:%d]%d;", i, i+6)
    header = header .. state
  end
	for i=1,6 do
		state = format("[bar:%d]%d;", i, i)
		header = header .. state
	end

	return header .. "0"
end

function zMainBar:UpdateStateHeader()
	UnregisterStateDriver(zMainBar, "actionpage")
	RegisterStateDriver(zMainBar, "actionpage", zMainBar:GetStateCommand())
end