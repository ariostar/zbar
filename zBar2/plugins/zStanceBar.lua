if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zStanceBar", UIParent, "SecureFrameTemplate")
zBar2:RegisterPlugin(zStanceBar)
zBar2:RegisterBar(zStanceBar)

function zStanceBar:Init()
	self:SetID(12)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(30); self:SetHeight(30)

	for i = 1, NUM_SHAPESHIFT_SLOTS do
		zBar2.buttons["zStanceBar"..i] = "ShapeshiftButton"..i
		_G["ShapeshiftButton"..i]:SetParent(self)
		_G["ShapeshiftButton"..i]:RegisterEvent("UPDATE_BINDINGS")
		_G["ShapeshiftButton"..i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		_G["ShapeshiftButton"..i]:SetScript("OnEvent", function()
			local key = GetBindingKey(this:GetName())
			_G[this:GetName().."HotKey"]:SetText(GetBindingText(key,1,1))
		end)
	end
	ShapeshiftButton1:ClearAllPoints()
	ShapeshiftButton1:SetPoint("CENTER")
	ShapeshiftButton1.SetPoint = zBar2.NOOP

	self:GetTab():GetNormalTexture():SetWidth(50)
	self:GetTab():GetHighlightTexture():SetWidth(50)

	self:Hook()
end

function zStanceBar:UpdateNums()
	local num = GetNumShapeshiftForms()
	if num ~= zBar2Saves["zStanceBar"].num then
		if zBar2Saves["zStanceBar"].linenum == zBar2Saves["zStanceBar"].num then
			zBar2Saves["zStanceBar"].linenum = num
		end
		zBar2Saves["zStanceBar"].num = num
		zBar2Saves["zStanceBar"].max = num
		if not InCombatLockdown() then
			zStanceBar:UpdateLayouts()
		end
	end
end

function zStanceBar:Hook()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i]:HookScript("OnEnter",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(1)
		end)
		_G["ShapeshiftButton"..i]:HookScript("OnLeave",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(zBar2Saves["zStanceBar"].alpha)
		end)
	end
	hooksecurefunc("ShapeshiftBar_UpdateState", zStanceBar.UpdateNums)
	MultiBarBottomLeft.Hide = MultiBarBottomLeft.Show
	MultiBarBottomLeft:Show()
end

function zStanceBar:UpdateButtons()
	self:UpdateNums()
	zBarT.UpdateButtons(self)
end