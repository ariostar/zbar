if zBar2.lite then return end
local _G = getfenv(0)

zPossessBar = {}
function zPossessBar:GetName() return "zPossessBar" end
zBar2:RegisterPlugin(zPossessBar)
--
function zPossessBar:Init()
	-- create and add buttons
	for i = 1, 2 do
		-- add to zMainBar, cause we need to change it's state
		zMainBar:SetAttribute("addchild", self:GetButton(i))
	end

	local button = self:GetButton(1)
	local PageReturn = 1
	if select(2, UnitClass("player")) == "WARRIOR" then PageReturn = 7 end
	button:SetAttribute("newstate", "1-10:11;11:"..PageReturn)

	button = self:GetButton(2)
	button:SetAttribute("type", "OnClick")
	button.OnClick = function(self, unit, button)
		self:SetChecked(0)
		CancelPlayerBuff(select(2, GetPossessInfo(1)))
	end

	self:Hook()
end

function zPossessBar:GetButton(i)
	local button = _G["zPossessButton"..i]
	if button then return button end

	button = CreateFrame("CheckButton","zPossessButton"..i,UIParent,"SecureActionButtonTemplate, ActionButtonTemplate")

	button:SetID(i) button:SetWidth(30) button:SetHeight(30)
	button:SetScript("OnEnter", function()
		if self.shown then
			PossessBar_OnEnter(this:GetID())
		end
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)

	button:SetAllPoints("ShapeshiftButton"..i)

	_G[button:GetName().."NormalTexture"]:SetWidth(1)
	_G[button:GetName().."NormalTexture"]:SetHeight(1)
	_G[button:GetName().."Cooldown"]:SetAlpha(0)

	return button
end

function zPossessBar:Hook()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i]:SetFrameLevel(2)
	end
	zPossessButton1:SetFrameLevel(0)
	zPossessButton2:SetFrameLevel(0)
	zPossessButton1:SetAlpha(0)
	zPossessButton2:SetAlpha(0)

	hooksecurefunc(PossessBarFrame, "Show", function(self)
		if zPossessBar.shown then return end
		zPossessBar.shown = 1
		zPossessButton1:SetFrameLevel(5)
		zPossessButton2:SetFrameLevel(5)
		zPossessButton1:SetAlpha(1)
		zPossessButton2:SetAlpha(1)
		zStanceBar:SetAlpha(0)
	end)
	hooksecurefunc(PossessBarFrame, "Hide", function(self)
		if not zPossessBar.shown then return end
		zPossessBar.shown = nil
		zPossessButton1:SetFrameLevel(0)
		zPossessButton2:SetFrameLevel(0)
		zPossessButton1:SetAlpha(0)
		zPossessButton2:SetAlpha(0)
		zStanceBar:SetAlpha(1)
	end)
	hooksecurefunc("PossessBar_UpdateState", function()
		for i = 1, 2 do
			local button = zPossessBar:GetButton(i)
			local Icon = _G[button:GetName().."Icon"]
			button:SetChecked(0);
			Icon:SetTexture(GetPossessInfo(i))
			Icon:SetVertexColor(1.0, 1.0, 1.0);
		end
	end)
end

function zPossessBar:OnBindingKey()
	if ( keystate == "up" ) then
		SecureActionButton_OnClick(zPossessButton1, "LeftButton")
	end
end