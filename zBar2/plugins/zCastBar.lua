zCastBar = CreateFrame("Frame", "zCastBar", UIParent)
zBar2:RegisterPlugin(zCastBar)
zBar2:RegisterBar(zCastBar)

function zCastBar:Init()
	zCastBar:SetID(16)
	zCastBar:SetWidth(195); zCastBar:SetHeight(13)

	-- positon of CastingBarFrame and FramerateLabel
	CastingBarFrame:ClearAllPoints()
	CastingBarFrame:SetPoint("TOP",zCastBar,0,-5)
	FramerateLabel:ClearAllPoints()
	FramerateLabel:SetPoint("BOTTOM",zCastBar,"TOP")

	-- skin
	CastingBarFrameBorder:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small")
	CastingBarFrameFlash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small")

	-- icon
	CastingBarFrameIcon:Show()
	CastingBarFrameIcon:SetWidth(24)
	CastingBarFrameIcon:SetHeight(24)
	CastingBarFrameIcon:SetPoint("RIGHT",CastingBarFrame,"LEFT",-5,2)

	-- text
	CastingBarFrameText:ClearAllPoints()
	CastingBarFrameText:SetPoint("CENTER",0,3)

	-- texture
	local kids = {CastingBarFrame:GetRegions()}
	for k, v in pairs(kids) do
		if not v:GetName() then
			v:ClearAllPoints()
			v:SetPoint("TOPLEFT",0,2)
			v:SetPoint("TOPRIGHT",0,2)
			v:SetPoint("BOTTOMLEFT",0,2)
			v:SetPoint("BOTTOMRIGHT",0,2)
		end
	end

	self:Hook()
end

function zCastBar:Hook()
	--UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = 	nil
	--UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
	CastingBarFrame.ClearAllPoints = zBar2.NOOP
	CastingBarFrame.SetPoint = zBar2.NOOP
	FramerateLabel.ClearAllPoints = zBar2.NOOP
	FramerateLabel.SetPoint = zBar2.NOOP
end

function zCastBar:UpdateButtons()
	if zBar2Saves["zCastBar"].num > 1 then
		CastingBarFrameIcon:Show()
	else
		CastingBarFrameIcon:Hide()
	end
end

function zCastBar:UpdateLayouts()
	CastingBarFrameIcon:ClearAllPoints()
	if zBar2Saves["zCastBar"].invert then
		CastingBarFrameIcon:SetPoint("LEFT",CastingBarFrame,"RIGHT",5,2)
	else
		CastingBarFrameIcon:SetPoint("RIGHT",CastingBarFrame,"LEFT",-5,2)
	end
end