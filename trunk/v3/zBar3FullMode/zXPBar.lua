local _G = getfenv(0)
local XPHeight = 20

CreateFrame("Frame","zXPBar",UIParent,"SecureFrameTemplate")
zBar3:AddPlugin(zXPBar, zMainBar)
zBar3:AddBar(zXPBar)

function zXPBar:Load()
	zXPBar:SetID(15)
	zXPBar:SetMovable(true)
	zXPBar:SetClampedToScreen(true)
	zXPBar:SetFrameStrata("BACKGROUND")
	zXPBar:SetWidth(34)
	zXPBar:SetHeight(XPHeight + 2)

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
				region:SetHeight(XPHeight + 6)
			elseif name:match('^MainMenuXPBarDiv(%w+)') then
				region:SetHeight(XPHeight - 8)
			end
		end
	end

	self:Hook()
end

function zXPBar:Hook()
	self:GetTab():SetScale(1)
	self:GetTab().SetScale = zBar3.NOOP

	--[[ Override when ReputationWatchBar Updates ]]
	--MainMenuExpBar.ClearAllPoints = NOOP
	--MainMenuExpBar.SetPoint = NOOP
	
	hooksecurefunc("VehicleMenuBar_MoveMicroButtons", function(skinName)
		zBar3:SafeCallFunc('zXPBar', 'ResetChildren', zXPBar)
		zBar3:SafeCallFunc('zXPBar', 'UpdateLayouts', zXPBar)
		zBar3:SafeCallFunc('zXPBar', 'UpdateButtons', zXPBar)
	end)
end

function zXPBar:UpdateButtons()
	local value = zBar3Data[self:GetName()]
	if not value.num or value.num < 1 then value.num = 1 end
	local width = 512 + 256*(value.num-1)
	MainMenuExpBar_SetWidth(width)
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
		ReputationWatchBar_Update(UnitLevel("player"))
		self.sig = nil
	end
end