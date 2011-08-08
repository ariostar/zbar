local _G = getfenv(0)

CreateFrame("Frame", "zPossessBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zPossessBar, zMainBar)
zBar3:AddBar(zPossessBar)

function zPossessBar:Load()

  RegisterStateDriver(self, "visibility", "[target=vehicle,exists][bonusbar:5]show;hide")
	
	-- create and add buttons
	for i = 1, 2 do
		local button = _G["PossessButton"..i]
		zBar3.buttons["zPossessBar"..i] = button:GetName()
		button:SetParent(self)
		button:ClearAllPoints()
		button:SetPoint("CENTER")
		
		local offset = 10
		button:GetNormalTexture():ClearAllPoints()
		button:GetNormalTexture():SetPoint("TOPLEFT", -offset, offset)
		button:GetNormalTexture():SetPoint("BOTTOMRIGHT", offset, -offset)
		_G[button:GetName().."Cooldown"]:SetAlpha(0)
	end

end

-- override
function zPossessBar:UpdateAutoPop() end

function zPossessBar:UpdateVisibility()
	if zBar3Data[self:GetName()].hide then
		UnregisterStateDriver(self, "visibility")
	else
		RegisterStateDriver(self, "visibility", "[target=vehicle,exists][bonusbar:5]show;hide")
	end

	zBarT.UpdateVisibility(self)
end