zCastBar = CreateFrame("Frame", "zCastBar", UIParent)
zBar3:AddPlugin(zCastBar)
zBar3:AddBar(zCastBar)

function zCastBar:Load()
	self:SetID(16)
	self:SetWidth(34)
	self:SetHeight(13)

	self:SetAttribute("DisableHoverPop", true)
	
	self:ResetChildren()

	-- skin
	CastingBarFrameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
	CastingBarFrameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")

	-- icon
	CastingBarFrameIcon:Show()
	CastingBarFrameIcon:SetWidth(24)
	CastingBarFrameIcon:SetHeight(24)

	-- text
	CastingBarFrameText:ClearAllPoints()
	CastingBarFrameText:SetPoint("CENTER",0,1)

	-- width and height
	CastingBarFrameBorder:SetWidth(CastingBarFrameBorder:GetWidth() + 4)
	CastingBarFrameFlash:SetWidth(CastingBarFrameFlash:GetWidth() + 4)
	CastingBarFrameBorderShield:SetWidth(CastingBarFrameBorderShield:GetWidth() + 4)
	CastingBarFrameBorder:SetPoint("TOP", 0, 26)
	CastingBarFrameFlash:SetPoint("TOP", 0, 26)
	CastingBarFrameBorderShield:SetPoint("TOP", 0, 26)
	
	self:Hook()
end

function zCastBar:Hook()
  UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
  UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = nil
end

function zCastBar:ResetChildren()
	-- positon of CastingBarFrame and FramerateLabel
	CastingBarFrame:SetParent(self)
	CastingBarFrame:ClearAllPoints()
	CastingBarFrame:SetPoint("TOP",zCastBar,0,-3)
	FramerateLabel:SetParent(self)
	FramerateLabel:ClearAllPoints()
	FramerateLabel:SetPoint("BOTTOM",self:GetLabel(),"TOP")
	CastingBarFrameIcon:SetPoint("RIGHT",CastingBarFrame,"LEFT",-6,0)
end

function zCastBar:UpdateButtons()
	if zBar3Data["zCastBar"].num > 1 then
		CastingBarFrameIcon:Show()
	else
		CastingBarFrameIcon:Hide()
	end
end

function zCastBar:UpdateLayouts()
	CastingBarFrameIcon:ClearAllPoints()
	if zBar3Data["zCastBar"].invert then
		CastingBarFrameIcon:SetPoint("LEFT",CastingBarFrame,"RIGHT",5,2)
	else
		CastingBarFrameIcon:SetPoint("RIGHT",CastingBarFrame,"LEFT",-5,2)
	end
end

-- show texture when zTab:OnDragStart()
function zCastBar:SetShowTexture(show)
	if show then
		CastingBarFrame.fadeOut = nil
		CastingBarFrame:Show()
		CastingBarFrame:SetAlpha(1)
	else
		CastingBarFrame:Hide()
	end
end