local XPHeight = 20

CreateFrame("Frame","zXPBar",UIParent,"SecureFrameTemplate")
zBar2:RegisterPlugin(zXPBar)
zBar2:RegisterBar(zXPBar)

function zXPBar:Init()
	zXPBar:SetID(15)
	zXPBar:SetMovable(true)
	zXPBar:SetClampedToScreen(true)
	zXPBar:SetFrameStrata("BACKGROUND")
	zXPBar:SetWidth(512); zXPBar:SetHeight(XPHeight)
	
	-- drag
--~ 	zXPBar:EnableMouse(true)
--~ 	zXPBar:RegisterForDrag("LeftButton")
--~ 	zXPBar:SetScript("OnDragStart", function() this:StartMoving() end)
--~ 	zXPBar:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

	-- XP Bar
	MainMenuExpBar:SetParent(zXPBar)
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("CENTER")
	MainMenuExpBar:SetWidth(512) MainMenuExpBar:SetHeight(XPHeight)
	-- drag
--~ 	MainMenuExpBar:RegisterForDrag("LeftButton")
--~ 	MainMenuExpBar:SetScript("OnDragStart",function() if IsControlKeyDown() then zXPBar:StartMoving() end end)
--~ 	MainMenuExpBar:SetScript("OnDragStop",function() zXPBar:StopMovingOrSizing() end)

	-- textures
	MainMenuXPBarTexture1:Hide()
	MainMenuXPBarTexture2:Hide()
	MainMenuXPBarTexture0:SetHeight(XPHeight)
	MainMenuXPBarTexture0:ClearAllPoints()
	MainMenuXPBarTexture0:SetPoint("LEFT")
	MainMenuXPBarTexture3:SetHeight(XPHeight)
	MainMenuXPBarTexture3:ClearAllPoints()
	MainMenuXPBarTexture3:SetPoint("RIGHT")
	-- text
	MainMenuBarExpText:SetPoint("CENTER",MainMenuExpBar,0,0)
	--MainMenuBarExpText:SetTextHeight(XPHeight)
	MainMenuBarExpText:SetFontObject(NumberFontNormalHuge)
	-- ExhaustionTick
	ExhaustionTick:SetParent(MainMenuExpBar)
	ExhaustionTickNormal:SetPoint("BOTTOM",0,-4)
	ExhaustionTickNormal:SetPoint("TOP",0,-4)
	ExhaustionTickHighlight:SetPoint("BOTTOM",0,-4)
	ExhaustionTickHighlight:SetPoint("TOP",0,-4)

	-- max level bar
	MainMenuBarMaxLevelBar:SetParent(zXPBar)
	MainMenuBarMaxLevelBar:EnableMouse(false)
	MainMenuBarMaxLevelBar:SetWidth(512)
	MainMenuBarMaxLevelBar:ClearAllPoints()
	MainMenuBarMaxLevelBar:SetPoint("CENTER",MainMenuExpBar)
	-- textures
	MainMenuMaxLevelBar1:Hide()
	MainMenuMaxLevelBar2:Hide()
	MainMenuMaxLevelBar0:SetHeight(XPHeight)
	MainMenuMaxLevelBar0:ClearAllPoints()
	MainMenuMaxLevelBar0:SetPoint("LEFT")
	MainMenuMaxLevelBar3:SetHeight(XPHeight)
	MainMenuMaxLevelBar3:ClearAllPoints()
	MainMenuMaxLevelBar3:SetPoint("RIGHT")

	-- Reputation bar
	ReputationWatchBar:SetParent(zXPBar)
	ReputationWatchBar:ClearAllPoints()
	ReputationWatchBar:SetPoint("BOTTOM",MainMenuExpBar,"TOP",0,0)
	ReputationWatchBar:SetWidth(512) ReputationWatchBar:SetHeight(XPHeight)
	
	-- drag
--~ 	ReputationWatchBar:RegisterForDrag("LeftButton")
--~ 	ReputationWatchBar:SetScript("OnDragStart",function() if IsControlKeyDown() then zXPBar:StartMoving() end end)
--~ 	ReputationWatchBar:SetScript("OnDragStop",function() zXPBar:StopMovingOrSizing() end)

	ReputationWatchStatusBar:SetWidth(512)
--~ 	ReputationWatchStatusBar:SetHeight(XPHeight)

	ReputationWatchBarTexture1:SetParent(MainMenuBar)
	ReputationWatchBarTexture2:SetParent(MainMenuBar)
	ReputationWatchBarTexture3:SetPoint("LEFT", ReputationWatchBarTexture0, "RIGHT")

	ReputationXPBarTexture1:SetParent(MainMenuBar)
	ReputationXPBarTexture2:SetParent(MainMenuBar)
	ReputationXPBarTexture3:SetPoint("LEFT", ReputationXPBarTexture0, "RIGHT")

	-- text
	RaiseFrameLevel(ReputationWatchBarOverlayFrame)
	ReputationWatchStatusBarText:SetFontObject(NumberFontNormalHuge)

	self:Hook()
end

local function Noop() end

function zXPBar:Hook()
	ReputationWatchBar.zSetPoint = ReputationWatchBar.SetPoint
	ReputationWatchBar.SetPoint = Noop
	--[[
		Override when ReputationWatchBar Updates
	--]]
	hooksecurefunc("ReputationWatchBar_Update", function(newLevel)
		if ( not newLevel ) then
			newLevel = UnitLevel("player");
		end
		if newLevel < MAX_PLAYER_LEVEL then
			ReputationWatchBar:zSetPoint("BOTTOM",MainMenuExpBar,"TOP",0,-2)
		else
			ReputationWatchBar:zSetPoint("BOTTOM",MainMenuExpBar,"BOTTOM",0,0)

			ReputationWatchStatusBar:SetHeight(XPHeight)

			ReputationXPBarTexture0:SetHeight(XPHeight)
			ReputationXPBarTexture3:SetHeight(XPHeight)

			ReputationWatchStatusBarText:SetPoint("CENTER", ReputationWatchBarOverlayFrame, "CENTER", 0, 0)
		end
	end)
end
