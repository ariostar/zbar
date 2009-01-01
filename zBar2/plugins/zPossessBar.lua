if zBar2.lite then return end
local _G = getfenv(0)

CreateFrame("Frame", "zPossessBar", UIParent)
zBar2:RegisterPlugin(zPossessBar)
zBar2:RegisterBar(zPossessBar)

function zPossessBar:Init()
	self:SetID(20)
	self:SetFrameStrata("LOW")
	self:SetClampedToScreen(true)
	self:SetWidth(30); self:SetHeight(30)

	-- must be unregister when you want to hide forever
	RegisterStateDriver(self, "visibility", "[bonusbar:5]show;hide")
	
	-- create and add buttons
	for i = 1, 2 do
		local button = _G["PossessButton"..i]
    button:SetParent(self)
		--self:SetAttribute("addchild", button)
		zBar2.buttons["zPossessBar"..i] = button:GetName()
		button:ClearAllPoints()
		button:SetPoint("CENTER")
		_G[button:GetName().."NormalTexture"]:SetWidth(52)
		_G[button:GetName().."NormalTexture"]:SetHeight(52)
		_G[button:GetName().."NormalTexture"]:SetPoint("CENTER")
		_G[button:GetName().."Cooldown"]:SetAlpha(0)
	end

end

-- override
function zPossessBar:UpdateVisibility()
	if zBar2Saves[self:GetName()].hide then
		UnregisterStateDriver(self, "visibility")
	else
		RegisterStateDriver(self, "visibility", "[bonusbar:5]show;hide")
	end

	zBarT.UpdateVisibility(self)
end