local _G = getfenv(0)

CreateFrame("Frame", "zPetBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zPetBar, zMainBar)
zBar3:AddBar(zPetBar)

function zPetBar:Load()
	for i = 1, NUM_PET_ACTION_SLOTS do
		_G["PetActionButton"..i]:SetParent(self)
		zBar3.buttons["zPetBar"..i] = "PetActionButton"..i
	end
	PetActionButton1:ClearAllPoints()
	PetActionButton1:SetPoint("CENTER")

	self:GetTab():GetNormalTexture():SetWidth(50)
	self:GetTab():GetHighlightTexture():SetWidth(50)
end

-- override
function zPetBar:UpdateAutoPop() end

function zPetBar:UpdateVisibility()
	if zBar3Data[self:GetName()].hide then
		UnregisterStateDriver(self, "visibility")
	else
		RegisterStateDriver(self, "visibility", '[target=pet,exists,nodead,nobonusbar:5]show;hide')
	end

	zBarT.UpdateVisibility(self)
end

function zPetBar:UpdateButtons()
	zBarT.UpdateButtons(self)	
	local name = self:GetName()
	for i = 2, NUM_PET_ACTION_SLOTS do
	  local button = _G[zBar3.buttons[name..i]]
		if button:GetAttribute("statehidden") then
			button:SetParent(zBar3.hiddenFrame)
		else
			button:SetParent(self)
		  if PetActionBarFrame.showgrid > 0 or GetPetActionInfo(i) then
			  button:Show()
			else
			  button:Hide()
			end
		end
	end
end