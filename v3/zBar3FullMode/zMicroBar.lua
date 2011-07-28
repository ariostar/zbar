CreateFrame("Frame", "zMicroBar", UIParent, "SecureHandlerStateTemplate")
zBar3:AddPlugin(zMicroBar, zMainBar)
zBar3:AddBar(zMicroBar)


function zMicroBar:Load()
	self:SetID(14)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(29); self:SetHeight(36);
	
	local numBtns = 0
	for i, btn in ipairs({MainMenuBarArtFrame:GetChildren()}) do
		local name = btn:GetName()
		if name and name:match('(%w+)MicroButton$') then
			numBtns = numBtns + 1
			zBar3.buttons['zMicroBar'..numBtns] = name
			
			btn:SetParent(self)
			btn:ClearAllPoints()
			btn:SetPoint("BOTTOM")
		end
	end
	zBar3.defaults["zMicroBar"].saves.num = numBtns
	zBar3.defaults["zMicroBar"].saves.max = numBtns
	zBar3.defaults["zMicroBar"].saves.linenum = numBtns

	self:GetTab():GetNormalTexture():SetWidth(42)
	self:GetTab():GetHighlightTexture():SetWidth(42)

	VehicleMenuBar_MoveMicroButtons = zBar3.NOOP
	--self:Hook()
end

function zMicroBar:GetChildSizeAdjust(attachPoint)
	if attachPoint == "BOTTOMLEFT" then
		return 2*self:GetScale(), 0
	elseif attachPoint == "TOPRIGHT" then
		return 0, -22*self:GetScale()
	end
end

function zMicroBar:Hook()
	if self.hooked then return end
	self.hooked = 1
	for i = 1, zBar3.defaults["zMicroBar"].saves.max do
		local button = self:GetButton(i)
		button.zClearAllPoints = button.ClearAllPoints
		button.ClearAllPoints = zBar3.NOOP
		button.zSetPoint = button.SetPoint
		button.SetPoint = zBar3.NOOP
		button.zSetParent = button.SetParent
		button.SetParent = zBar3.NOOP
	end
end

function zMicroBar:UnHook()
	if not self.hooked then return end
	self.hooked = nil
	for i = 1, zBar3.defaults["zMicroBar"].saves.max do
		local button = self:GetButton(i)
		button.ClearAllPoints = button.zClearAllPoints
		button.SetPoint = button.zSetPoint
		button.SetParent = button.zSetParent
	end
end

function zMicroBar:UpdateButtons()
	--self:UnHook()

	zBarT.UpdateButtons(self)

	for i = 1, zBar3.defaults["zMicroBar"].saves.max do
		local button = self:GetButton(i)
		if button:GetAttribute("statehidden") then
			button:SetParent(zBar3.hiddenFrame)
		else
			button:SetParent(self)
			button:Show()
		end
	end
	zMicroBar:GetButton(1):ClearAllPoints()
	zMicroBar:GetButton(1):SetPoint("BOTTOM")

	--self:Hook()
end

function zMicroBar:UpdateLayouts()
	--self:UnHook()

	zBarT.UpdateLayouts(self)

	--self:Hook()
end

