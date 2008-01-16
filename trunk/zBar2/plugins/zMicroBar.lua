CreateFrame("Frame", "zMicroBar", UIParent, "SecureFrameTemplate")
zBar2:RegisterPlugin(zMicroBar)
zBar2:RegisterBar(zMicroBar)

function zMicroBar:Init()
	self:SetID(14)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(29); self:SetHeight(36);

	CharacterMicroButton:SetParent(self)
	CharacterMicroButton:ClearAllPoints()
	CharacterMicroButton:SetPoint("BOTTOM")
	SpellbookMicroButton:SetParent(self)
	TalentMicroButton:SetParent(self)
	QuestLogMicroButton:SetParent(self)
	SocialsMicroButton:SetParent(self)
	LFGMicroButton:SetParent(self)
	MainMenuMicroButton:SetParent(self)
	HelpMicroButton:SetParent(self)
	
	zBar2.buttons["zMicroBar1"]= "CharacterMicroButton"
	zBar2.buttons["zMicroBar2"]= "SpellbookMicroButton"
	zBar2.buttons["zMicroBar3"]= "TalentMicroButton"
	zBar2.buttons["zMicroBar4"]= "QuestLogMicroButton"
	zBar2.buttons["zMicroBar5"]= "SocialsMicroButton"
	zBar2.buttons["zMicroBar6"]= "LFGMicroButton"
	zBar2.buttons["zMicroBar7"]= "MainMenuMicroButton"
	zBar2.buttons["zMicroBar8"]= "HelpMicroButton"
	
	self:GetTab():GetNormalTexture():SetWidth(42)
	self:GetTab():GetHighlightTexture():SetWidth(42)
	
	self:Hook()
end

function zMicroBar:GetChildSizeAdjust(attachPoint)
	if attachPoint == "BOTTOMLEFT" then
		return 2*self:GetScale(), 0
	elseif attachPoint == "TOPRIGHT" then
		return 0, -22*self:GetScale()
	end
end

function zMicroBar:Hook()
	hooksecurefunc("UpdateTalentButton", function()
		if not InCombatLockdown() then
			zMicroBar:UpdateLayouts()
		end
	end)
end