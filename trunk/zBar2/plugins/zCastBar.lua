zCastBar = CreateFrame("Frame", "zCastBar", UIParent)
zBar2:RegisterPlugin(zCastBar)
zBar2:RegisterBar(zCastBar)

function zCastBar:Init()
	zCastBar:SetID(16)
	zCastBar:SetWidth(195); zCastBar:SetHeight(13)

	-- positon of CastingBarFrame and FramerateLabel
	UIPARENT_MANAGED_FRAME_POSITIONS["FramerateLabel"] = 	nil
	UIPARENT_MANAGED_FRAME_POSITIONS["CastingBarFrame"] = nil
	FramerateLabel:ClearAllPoints() FramerateLabel:SetPoint("BOTTOM",zCastBar)
	CastingBarFrame:ClearAllPoints() CastingBarFrame:SetPoint("BOTTOM",zCastBar)

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
end

function zCastBar:UpdateButtons()
	if zBar2Saves["zCastBar"].num > 1 then
		CastingBarFrameIcon:Show()
	else
		CastingBarFrameIcon:Hide()
	end
end

function zCastBar:UpdateLayouts()
	if zBar2Saves["zCastBar"].invert then
		CastingBarFrameIcon:ClearAllPoints()
		CastingBarFrameIcon:SetPoint("LEFT",CastingBarFrame,"RIGHT",5,2)
	else
		CastingBarFrameIcon:ClearAllPoints()
		CastingBarFrameIcon:SetPoint("RIGHT",CastingBarFrame,"LEFT",-5,2)
	end
end