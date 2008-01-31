if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zPetBar", UIParent, "SecureFrameTemplate")
zBar2:RegisterPlugin(zPetBar)
zBar2:RegisterBar(zPetBar)

function zPetBar:Init()
	self:SetID(11)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(30); self:SetHeight(30);

	-- must be unregister when you want to hide forever
	self:SetAttribute("unit", "pet")
	RegisterUnitWatch(self)

	for i = 1, NUM_PET_ACTION_SLOTS do
		_G["PetActionButton"..i]:SetParent(self)
		zBar2.buttons["zPetBar"..i] = "PetActionButton"..i
		--_G["PetActionButton"..i]:RegisterEvent("UPDATE_BINDINGS")
		_G["PetActionButton"..i]:RegisterEvent("PLAYER_ENTERING_WORLD")
		_G["PetActionButton"..i]:SetScript("OnEvent", function()
			local key = GetBindingKey("BONUSACTIONBUTTON"..this:GetID())
			_G[this:GetName().."HotKey"]:SetText(GetBindingText(key,1,1))
		end)
	end
	PetActionButton1:ClearAllPoints()
	PetActionButton1:SetPoint("CENTER")

	self:GetTab():GetNormalTexture():SetWidth(50)
	self:GetTab():GetHighlightTexture():SetWidth(50)
end
-- override
function zPetBar:UpdateVisibility()
	if zBar2Saves[self:GetName()].hide then
		UnregisterUnitWatch(self)
	else
		RegisterUnitWatch(self)
	end

	zBarT.UpdateVisibility(self)
end

function zPetBar:UpdateButtons()
	zBarT.UpdateButtons(self)
	local name = self:GetName()
	for i = 2, zBar2Saves[name].max or NUM_ACTIONBAR_BUTTONS do
		if _G[zBar2.buttons[name..i]]:GetAttribute("statehidden") then
			_G[zBar2.buttons[name..i]]:SetParent(zBar2.hiddenFrame)
		else
			_G[zBar2.buttons[name..i]]:SetParent(self)
		end
	end
end