local _G = getfenv(0)

CreateFrame("Frame", "zStanceBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zStanceBar, zMainBar)
zBar3:AddBar(zStanceBar)

function zStanceBar:Load()

  for i = 1, NUM_SHAPESHIFT_SLOTS do
		zBar3.buttons["zStanceBar"..i] = "ShapeshiftButton"..i
		_G["ShapeshiftButton"..i]:SetParent(self)
		_G["ShapeshiftButton"..i]:GetNormalTexture():SetPoint("CENTER")
		_G["ShapeshiftButton"..i]:RegisterEvent("UPDATE_BINDINGS")
		_G["ShapeshiftButton"..i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		_G["ShapeshiftButton"..i]:SetScript("OnEvent", function(this)
			local key = GetBindingKey(this:GetName())
			_G[this:GetName().."HotKey"]:SetText(GetBindingText(key,1,1))
		end)
	end
	ShapeshiftButton1:ClearAllPoints()
	ShapeshiftButton1:SetPoint("CENTER")

	self:GetTab():GetNormalTexture():SetWidth(50)
	self:GetTab():GetHighlightTexture():SetWidth(50)

	self:Hook()
end

function zStanceBar:UpdateNums()
	local num = GetNumShapeshiftForms()
	if num ~= zBar3Data["zStanceBar"].num then
		if zBar3Data["zStanceBar"].linenum == zBar3Data["zStanceBar"].num then
			zBar3Data["zStanceBar"].linenum = num
		end
		zBar3Data["zStanceBar"].num = num
		zBar3Data["zStanceBar"].max = num
		
		zBar3:SafeCallFunc(zStanceBar.UpdateLayouts, zStanceBar)
		zBar3:SafeCallFunc(zStanceBar.UpdateHotkeys, zStanceBar)
	end
end

function zStanceBar:Hook()
	hooksecurefunc("ShapeshiftBar_Update", function()
		zBar3:SafeCallFunc(zStanceBar.ResetChildren, zStanceBar)
	end)	

	for i = 1, NUM_SHAPESHIFT_SLOTS do
		_G["ShapeshiftButton"..i]:HookScript("OnEnter",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(1)
		end)
		_G["ShapeshiftButton"..i]:HookScript("OnLeave",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(zBar3Data["zStanceBar"].alpha)
		end)
	end
	
	hooksecurefunc("ShapeshiftBar_Update", zStanceBar.UpdateNums)
	
	hooksecurefunc("UIParent_ManageFramePositions", function()
		if 50 ~= _G["ShapeshiftButton1"]:GetNormalTexture():GetWidth() then
			for i = 1, GetNumShapeshiftForms() do
				_G["ShapeshiftButton"..i]:GetNormalTexture():SetWidth(50)
				_G["ShapeshiftButton"..i]:GetNormalTexture():SetHeight(50)
			end
		end
	end)
end

function zStanceBar:UpdateButtons()
	self:UpdateNums()
	zBarT.UpdateButtons(self)
end