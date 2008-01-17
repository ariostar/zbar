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
	for i=0,3 do
		_G["CharacterBag"..i.."Slot"]:SetParent(self)
		zBar2.buttons["zBagBar"..(4-i)] = "CharacterBag"..i.."Slot"
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetWidth(60)
		_G["CharacterBag"..i.."SlotNormalTexture"]:SetHeight(60)
	end
	CharacterBag3Slot:ClearAllPoints()
	CharacterBag3Slot:SetPoint("CENTER")
	
	MainMenuBarBackpackButton:SetParent(self)
	zBar2.buttons["zBagBar5"] = "MainMenuBarBackpackButton"
	MainMenuBarBackpackButtonNormalTexture:SetWidth(60)
	MainMenuBarBackpackButtonNormalTexture:SetHeight(60)

    -- keyring and performance bar
	CreateFrame("Frame","zBagBarButton6",self)
	zBagBarButton6:SetWidth(37); zBagBarButton6:SetHeight(37);
	zBagBarButton6:SetPoint("LEFT",MainMenuBarBackpackButton,"RIGHT")
	zBar2.buttons["zBagBar6"] = "zBagBarButton6"

	KeyRingButton:SetParent(zBagBarButton6)
	KeyRingButton:ClearAllPoints()
	KeyRingButton:SetPoint("TOPLEFT",zBagBarButton6,"TOPLEFT",2,1)

	MainMenuBarPerformanceBarFrame:SetParent(zBagBarButton6)
	MainMenuBarPerformanceBarFrame:ClearAllPoints()
	MainMenuBarPerformanceBarFrame:SetPoint("LEFT",KeyRingButton,"RIGHT",2,2)

	self:Hook()
	
	self:GetTab():GetNormalTexture():SetWidth(60)
	self:GetTab():GetHighlightTexture():SetWidth(60)
end

function zBagBar:Hook()
	hooksecurefunc("MainMenuBar_UpdateKeyRing", function()
		if ( SHOW_KEYRING == 1 ) then
			MainMenuBarPerformanceBarFrame:ClearAllPoints()
			MainMenuBarPerformanceBarFrame:SetPoint("LEFT",KeyRingButton,"RIGHT",2,2)
		end
	end)
end