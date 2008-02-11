if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zPossessBar", UIParent, "SecureFrameTemplate")
zBar2:RegisterPlugin(zPossessBar)
zBar2:RegisterBar(zPossessBar)

function zPossessBar:Init()
	self:SetID(20)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(30); self:SetHeight(30)

	-- create and add buttons
	for i = 1, 2 do
		-- add to zMainBar, cause we need to change it's state
		zMainBar:SetAttribute("addchild", self:GetButton(i))
	end

	local PageReturn = 1
	if zBar2.class == "WARRIOR" then PageReturn = 7 end

	local button = self:GetButton(1)
	button:SetAttribute("newstate", "1-10:11;11:"..PageReturn)
	button:HookScript("OnClick",function() this:SetChecked(0) end)

	button = self:GetButton(2)
	button:SetAttribute("type", "OnClick")
	button:SetAttribute("newstate", "*:"..PageReturn)
	button.OnClick = function(self, unit, button)
		self:SetChecked(0)
		CancelPlayerBuff(select(2, GetPossessInfo(1)))
	end

	self:GetButton(1):SetScript("OnEvent",zPossessBar.UpdateState)

	self:Hook()
end

function zPossessBar:GetButton(i)
	local button = _G["zPossessButton"..i]
	if button then return button end

	button = CreateFrame("CheckButton","zPossessButton"..i,UIParent,"SecureActionButtonTemplate, ActionButtonTemplate")

	button:SetID(i) button:SetWidth(30) button:SetHeight(30)
	button:SetScript("OnEnter", function()
		if zPossessBar.shown then
			PossessBar_OnEnter(this:GetID())
		else
			this:SetAlpha(1)
			if ( GetCVar("UberTooltips") == "1" ) then
				GameTooltip_SetDefaultAnchor(GameTooltip, this);
			else
				GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		    end
			if this:GetID() == 1 then
				GameTooltip:SetText(zBar2.loc.Possessed)
			elseif this:GetID() == 2 then
				GameTooltip:SetText(CANCEL)
			end
		end
	end)
	button:SetScript("OnLeave", function()
		GameTooltip:Hide()
		if not zPossessBar.shown then this:SetAlpha(0) end
	end)

	button:SetPoint("CENTER",zPossessBar)
	zBar2.buttons["zPossessBar"..i] = "zPossessButton"..i

	_G[button:GetName().."NormalTexture"]:SetWidth(52)
	_G[button:GetName().."NormalTexture"]:SetHeight(52)
	_G[button:GetName().."NormalTexture"]:SetPoint("CENTER")
	_G[button:GetName().."Cooldown"]:SetAlpha(0)

	return button
end

-- rewrite func
function zPossessBar:ResetButtonScales(num)
	scale = zPossessBar:GetScale() / zMainBar:GetScale()
	for i = 1, num do
		_G["zPossessButton"..i]:SetScale(scale)
	end
end

function zPossessBar:Hook()
	zPossessBar:GetButton(1):SetAlpha(0)
	zPossessBar:GetButton(2):SetAlpha(0)

	hooksecurefunc(zPossessBar, "SetScale", function(self,scale)
		zPossessBar:ResetButtonScales(2)
	end)
	hooksecurefunc(zMainBar, "SetScale", function(self,scale)
		zPossessBar:ResetButtonScales(2)
	end)
	hooksecurefunc(PossessBarFrame, "Show", function(self)
		if zPossessBar.shown then return end
		zPossessBar.shown = 1
		zPossessBar:GetButton(1):SetAlpha(1)
		zPossessBar:GetButton(2):SetAlpha(1)
		zStanceBar:SetAlpha(0)
		zPossessBar:UpdateState()
	end)
	hooksecurefunc(PossessBarFrame, "Hide", function(self)
		if not zPossessBar.shown then return end
		zPossessBar.shown = nil
		zPossessBar:GetButton(1):SetAlpha(0)
		zPossessBar:GetButton(2):SetAlpha(0)
		zStanceBar:SetAlpha(zBar2Saves["zStanceBar"].alpha or 1)
		zPossessBar:UpdateState()
	end)
	hooksecurefunc("PossessBar_UpdateState", function()
		for i = 1, 2 do
			local button = zPossessBar:GetButton(i)
			local Icon = _G[button:GetName().."Icon"]
			button:SetChecked(0);
			if zPossessBar.shown then
				Icon:SetTexture(GetPossessInfo(i))
			else
				if i == 1 then
					Icon:SetTexture("Interface\\Icons\\Spell_Nature_Polymorph")
				elseif i == 2 then
					Icon:SetTexture("Interface\\Icons\\Spell_Shadow_SacrificialShield")
				end
			end
			Icon:SetVertexColor(1.0, 1.0, 1.0);
		end
	end)
end

function zPossessBar:UpdateState()
	if not InCombatLockdown() then
		if zPossessBar.shown then
			zMainBar:SetAttribute("state",11)
		else
			local values = zMainBar:GetStateCommand()
			zMainBar:SetAttribute("state",SecureCmdOptionParse(values))
		end
		if zPossessBar:GetButton(1):IsEventRegistered("PLAYER_REGEN_ENABLED") then
			zPossessBar:GetButton(1):UnregisterEvent("PLAYER_REGEN_ENABLED")
		end
	else
		if not zPossessBar:GetButton(1):IsEventRegistered("PLAYER_REGEN_ENABLED") then
			zPossessBar:GetButton(1):RegisterEvent("PLAYER_REGEN_ENABLED")
		end
	end
end

function zPossessBar:OnBindingKey()
	if ( keystate == "up" ) then
		SecureActionButton_OnClick(zPossessButton1, "LeftButton")
	end
end