if zBar2.lite then return end
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
  AchievementMicroButton:SetParent(self)
	QuestLogMicroButton:SetParent(self)
	SocialsMicroButton:SetParent(self)
  PVPMicroButton:SetParent(self)
	LFGMicroButton:SetParent(self)
	MainMenuMicroButton:SetParent(self)
	HelpMicroButton:SetParent(self)

	zBar2.buttons["zMicroBar1"]= "CharacterMicroButton"
	zBar2.buttons["zMicroBar2"]= "SpellbookMicroButton"
	zBar2.buttons["zMicroBar3"]= "TalentMicroButton"
	zBar2.buttons["zMicroBar4"]= "AchievementMicroButton"
	zBar2.buttons["zMicroBar5"]= "QuestLogMicroButton"
	zBar2.buttons["zMicroBar6"]= "SocialsMicroButton"  
	zBar2.buttons["zMicroBar7"]= "PVPMicroButton"
	zBar2.buttons["zMicroBar8"]= "LFGMicroButton"
	zBar2.buttons["zMicroBar9"]= "MainMenuMicroButton"
	zBar2.buttons["zMicroBar10"]= "HelpMicroButton"

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
	for i = 1, zBar2Saves['zMicroBar'].max or NUM_ACTIONBAR_BUTTONS do
    local button = _G[zBar2.buttons['zMicroBar'..i]]
    button.zClearAllPoints = button.ClearAllPoints
    button.ClearAllPoints = zBar2.NOOP
    button.zSetPoint = button.SetPoint
    button.SetPoint = zBar2.NOOP
    button.zSetParent = button.SetParent
    button.SetParent = zBar2.NOOP
	end
end

function zMicroBar:UnHook()
	for i = 1, zBar2Saves['zMicroBar'].max or NUM_ACTIONBAR_BUTTONS do
    local button = _G[zBar2.buttons['zMicroBar'..i]]
    button.ClearAllPoints = button.zClearAllPoints
    button.SetPoint = button.zSetPoint
    button.SetParent = button.zSetParent
	end
end

function zMicroBar:UpdateButtons()
  self:UnHook()
  
	zBarT.UpdateButtons(self)
	local name = self:GetName()
	for i = 2, zBar2Saves[name].max or NUM_ACTIONBAR_BUTTONS do
		if _G[zBar2.buttons[name..i]]:GetAttribute("statehidden") then
			_G[zBar2.buttons[name..i]]:SetParent(zBar2.hiddenFrame)
		else
			_G[zBar2.buttons[name..i]]:SetParent(self)
			_G[zBar2.buttons[name..i]]:Show()
		end
	end
  
  self:Hook()
end

function zMicroBar:UpdateLayouts()
  self:UnHook()

  zBarT.UpdateLayouts(self)
  
  self:Hook()
end