local _G = getfenv(0)

CreateFrame("Frame", "zStanceBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zStanceBar, zMainBar)
zBar3:AddBar(zStanceBar)

function zStanceBar:Load()

  for i = 1, NUM_STANCE_SLOTS do
		zBar3.buttons["zStanceBar"..i] = "StanceButton"..i
		_G["StanceButton"..i]:SetParent(self)
		--_G["StanceButton"..i]:GetNormalTexture():SetPoint("CENTER")
		--_G["StanceButton"..i]:GetNormalTexture():SetWidth(60)
		--_G["StanceButton"..i]:GetNormalTexture():SetHeight(60)
		_G["StanceButton"..i]:RegisterEvent("UPDATE_BINDINGS")
		_G["StanceButton"..i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		_G["StanceButton"..i]:SetScript("OnEvent", function(this)
			local key = GetBindingKey(this:GetName())
			_G[this:GetName().."HotKey"]:SetText(GetBindingText(key,1,1))
		end)
	end
	StanceButton1:ClearAllPoints()
	StanceButton1:SetPoint("CENTER")

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
	hooksecurefunc("StanceBar_Update", function()
		zBar3:SafeCallFunc(zStanceBar.ResetChildren, zStanceBar)
    zStanceBar:UpdateNums()
	end)	

	for i = 1, NUM_STANCE_SLOTS do
		_G["StanceButton"..i]:HookScript("OnEnter",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(1)
		end)
		_G["StanceButton"..i]:HookScript("OnLeave",function()
			if zPossessBar and zPossessBar.shown then return end
			zStanceBar:SetAlpha(zBar3Data["zStanceBar"].alpha)
		end)
	end
	
	hooksecurefunc("UIParent_ManageFramePositions", function()
		if 52 ~= StanceButton1:GetNormalTexture():GetWidth() then
			for i = 1, GetNumShapeshiftForms() do
				_G["StanceButton"..i]:GetNormalTexture():SetWidth(52)
				_G["StanceButton"..i]:GetNormalTexture():SetHeight(52)
			end
		end
	end)
end

function zStanceBar:UpdateButtons()
	self:UpdateNums()
	zBarT.UpdateButtons(self)
end

-- hack for number of buttons
function zStanceBar:GetNumButtons()
	return NUM_STANCE_SLOTS
end