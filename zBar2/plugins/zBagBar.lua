if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zBagBar", UIParent, "SecureFrameTemplate")
zBar2:RegisterPlugin(zBagBar)
zBar2:RegisterBar(zBagBar)

function zBagBar:Init()
	self:SetID(13)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(37); self:SetHeight(37);

	-- bag packs
	MainMenuBarBackpackButton:SetParent(self)
	zBar2.buttons["zBagBar1"] = "MainMenuBarBackpackButton"
	MainMenuBarBackpackButtonNormalTexture:SetWidth(60)
	MainMenuBarBackpackButtonNormalTexture:SetHeight(60)
	MainMenuBarBackpackButton:ClearAllPoints()
	MainMenuBarBackpackButton:SetPoint("CENTER")

	for i=0,3 do
		_G["CharacterBag"..i.."Slot"]:SetParent(self)
		zBar2.buttons["zBagBar"..(2+i)] = "CharacterBag"..i.."Slot"
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetWidth(60)
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetHeight(60)
	end

    -- keyring and performance bar
	CreateFrame("Frame","zBagBarButton6",self)
	zBagBarButton6:SetWidth(37); zBagBarButton6:SetHeight(37);
	zBagBarButton6:SetPoint("RIGHT",zBar2.buttons["zBagBar5"],"LEFT")
	zBar2.buttons["zBagBar6"] = "zBagBarButton6"

	KeyRingButton:SetParent(zBagBarButton6)
	KeyRingButton:SetFrameLevel(1)
	KeyRingButton:SetScale(0.96)
	KeyRingButton:ClearAllPoints()
	KeyRingButton:SetPoint("RIGHT",zBagBarButton6)

	MainMenuBarPerformanceBarFrame:SetParent(zBagBarButton6)
	MainMenuBarPerformanceBarFrame:SetFrameLevel(1)
	MainMenuBarPerformanceBarFrame:SetScale(0.92)
	MainMenuBarPerformanceBarFrame:ClearAllPoints()
	MainMenuBarPerformanceBarFrame:SetPoint("RIGHT",KeyRingButton,"LEFT",6,1)

	self:Hook()

	self:GetTab():GetNormalTexture():SetWidth(60)
	self:GetTab():GetHighlightTexture():SetWidth(60)
end

function zBagBar:Hook()
	hooksecurefunc("MainMenuBar_UpdateKeyRing", function()
		if ( SHOW_KEYRING == 1 ) then
			MainMenuBarPerformanceBarFrame:ClearAllPoints()
			MainMenuBarPerformanceBarFrame:SetPoint("Right",KeyRingButton,"Left",5,1)
		end
	end)
end

function zBagBar:UpdateButtons()
	zBarT.UpdateButtons(self)
	if zBar2Saves[self:GetName()].num == 1 then
		zBagBarButton6:Show()
		zBagBarButton6:SetAttribute("showstates", nil)
		zBagBarButton6:SetAttribute("statehidden", nil)
		zBagBarButton6:ClearAllPoints()
		zBagBarButton6:SetPoint("RIGHT",zBar2.buttons["zBagBar1"],"LEFT")
	end
end