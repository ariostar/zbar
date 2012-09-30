local _G = getfenv(0)
local XPHeight = 20

CreateFrame("Frame","zXPBar",UIParent,"SecureFrameTemplate")
zBar3:AddPlugin(zXPBar, zMainBar)
zBar3:AddBar(zXPBar)

function zXPBar:Load()
	zXPBar:SetMovable(true)

	--[[ XP Bar ]]
	MainMenuExpBar:SetParent(zXPBar)
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("BOTTOM")
	MainMenuExpBar_SetWidth(512)
	MainMenuExpBar:SetHeight(XPHeight)
	
	zBar3.buttons['zXPBar1'] = "MainMenuExpBar"
		
	-- text
	MainMenuBarExpText:SetPoint("CENTER",MainMenuExpBar,0,0)
	MainMenuBarExpText:SetFontObject(NumberFontNormalHuge)
	-- ExhaustionTick
	ExhaustionTick:SetParent(MainMenuExpBar)
	ExhaustionTickNormal:SetPoint("BOTTOM",0,-4)
	ExhaustionTickNormal:SetPoint("TOP",0,-4)
	ExhaustionTickHighlight:SetPoint("BOTTOM",0,-4)
	ExhaustionTickHighlight:SetPoint("TOP",0,-4)

	--[[ Textures ]]
	for i, region in ipairs({MainMenuExpBar:GetRegions()}) do
		local name = region:GetName()
		if name then
			if name:match('^MainMenuXPBarTexture(%w+)') then
				region:SetHeight(XPHeight + 3)
				local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = region:GetTexCoord()
				if name == "MainMenuXPBarTextureLeftCap" then
				  ULx = ULx + 0.03
				elseif name == "MainMenuXPBarTextureRightCap" then
				  URx = URx - 0.03
				end
				region:SetTexCoord(ULx, URx, ULy, ULy + (LLy-ULy) * 0.83)
			elseif name:match('^MainMenuXPBarDiv(%w+)') then
				region:SetHeight(XPHeight - 8)
			end
		end
	end
	
	MainMenuXPBarTextureLeftCap:SetPoint("LEFT", -2, 2)
	MainMenuXPBarTextureRightCap:SetPoint("RIGHT", 2, 2)

	--[[ Reputation Bar ]]
	ReputationWatchBar:SetParent(zXPBar)
	ReputationWatchBar:ClearAllPoints()
	ReputationWatchBar:SetPoint("BOTTOM",MainMenuExpBar,"TOP",-2,0)
	ReputationWatchBar:SetWidth(512)
	ReputationWatchBar:SetHeight(XPHeight)

	ReputationWatchStatusBar:SetWidth(512)
	ReputationWatchStatusBar:ClearAllPoints()
	ReputationWatchStatusBar:SetPoint("BOTTOM",MainMEnuExpBar,"TOP",0,0)

	-- text
	RaiseFrameLevel(ReputationWatchBarOverlayFrame)
	ReputationWatchStatusBarText:SetFontObject(NumberFontNormalHuge)
	
	--[[ Textures ]]
	ReputationWatchBarTexture0:SetTexCoord(0.01, 1.0, 0, 0.171875)
  ReputationWatchBarTexture1:SetTexCoord(0, 1.0, 0.171875, 0.34375)
  ReputationWatchBarTexture2:SetTexCoord(0, 1.0, 0.34375, 0.515625)
  ReputationWatchBarTexture3:SetTexCoord(0, 1.0, 0.515625, 0.6875)
	
  ReputationXPBarTexture0:SetTexCoord(0.01, 1.0, 0.79296875, 0.83503125)
  ReputationXPBarTexture1:SetTexCoord(0, 1.0, 0.54296875, 0.58503125)
  ReputationXPBarTexture2:SetTexCoord(0, 1.0, 0.29296875, 0.33503125)
  ReputationXPBarTexture3:SetTexCoord(0, 0.99, 0.04296875, 0.08503125)
  
  ReputationXPBarTexture0:SetPoint('TOPLEFT', -2, 0)
  ReputationXPBarTexture0:SetPoint('BOTTOMLEFT', -2, 0)
  for i = 1, 3 do
    local texture = _G["ReputationXPBarTexture"..i]
    texture:ClearAllPoints()
    texture:SetPoint('TOPLEFT', "ReputationXPBarTexture"..i-1, 'TOPRIGHT')
    texture:SetPoint('BOTTOMLEFT', "ReputationXPBarTexture"..i-1, 'BOTTOMRIGHT')
  end
  ReputationXPBarTexture3:SetPoint('TOPRIGHT', 2, 0)
  ReputationXPBarTexture3:SetPoint('BOTTOMRIGHT', 2, 0)

	
	self:Hook()
end

function zXPBar:Hook()
  local tab = self:GetTab()
  tab:SetScale(1)
	tab.SetScale = function(self, scale)
	  if scale < 1 then
	    zBar3.SetScale(self, 1)
	  else
	    zBar3.SetScale(self, scale)
	  end
	end

	--[[ Hook for VehicleMenuBar ]]
  --[[
	hooksecurefunc("VehicleMenuBar_MoveMicroButtons", function(skinName)
		zBar3:SafeCallFunc(zXPBar.ResetChildren, zXPBar)
		zBar3:SafeCallFunc(zXPBar.UpdateLayouts, zXPBar)
		zBar3:SafeCallFunc(zXPBar.UpdateButtons, zXPBar)
	end)
	]]
	hooksecurefunc("ReputationWatchBar_Update", function(newLevel)
		local name, reaction = GetWatchedFactionInfo()
		if name then
			if ( not newLevel ) then
				newLevel = UnitLevel("player");
			end
			if newLevel < MAX_PLAYER_LEVEL then
				local r,g,b = 0,0,0
				if reaction < 5 then r = 1 end
				if reaction == 3 then g = 0.5 end
				if reaction > 3 then g = 1 end
				ReputationWatchStatusBar:SetStatusBarColor(r, g, b);
				ReputationWatchStatusBar:SetPoint("BOTTOM", MainMenuExpBar, "TOP", 0, 8)
			else
				ReputationWatchStatusBar:SetPoint("BOTTOM", MainMenuExpBar, "BOTTOM", 0, 0)
				ReputationWatchStatusBar:SetHeight(XPHeight)
			end
      ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchStatusBar, "CENTER", 0, -1);
		end
	end)

end

function zXPBar:UpdateButtons()
	local value = zBar3Data[self:GetName()]
	if not value.num or value.num < 1 then value.num = 1 end
	local width = 512 + 256*(value.num-1)
	MainMenuExpBar_SetWidth(width)
	
	ReputationWatchBar:SetWidth(width)
	ReputationWatchStatusBar:SetWidth(width)
	
	for i = 1, 3 do
		local alpha = 0
		if i < value.num+1 then alpha = 1 end
		_G["ReputationWatchBarTexture"..i]:SetAlpha(alpha)
		_G["ReputationXPBarTexture"..i]:SetAlpha(alpha)
	end
end

function zXPBar:ResetChildren()
	MainMenuExpBar:SetParent(zXPBar)
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("BOTTOM")
end

function zXPBar:UpdateLayouts()
end

function zXPBar:Test()
	if not self.sig then
		ReputationWatchBar_Update(MAX_PLAYER_LEVEL)
		self.sig = 1
	else
		ReputationWatchBar_Update()
		self.sig = nil
	end
end