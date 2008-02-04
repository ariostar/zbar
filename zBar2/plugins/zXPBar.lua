if zBar2.lite then return end
local _G = getfenv(0)
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

	--[[ XP Bar ]]
	MainMenuExpBar:SetParent(zXPBar)
	MainMenuExpBar:ClearAllPoints()
	MainMenuExpBar:SetPoint("CENTER")
	MainMenuExpBar:SetWidth(512) MainMenuExpBar:SetHeight(XPHeight)

	-- text
	MainMenuBarExpText:SetPoint("CENTER",MainMenuExpBar,0,0)
	MainMenuBarExpText:SetFontObject(NumberFontNormalHuge)
	-- ExhaustionTick
	ExhaustionTick:SetParent(MainMenuExpBar)
	ExhaustionTickNormal:SetPoint("BOTTOM",0,-4)
	ExhaustionTickNormal:SetPoint("TOP",0,-4)
	ExhaustionTickHighlight:SetPoint("BOTTOM",0,-4)
	ExhaustionTickHighlight:SetPoint("TOP",0,-4)

	--[[ Max Level Bar ]]
	MainMenuBarMaxLevelBar:SetParent(zXPBar)
	MainMenuBarMaxLevelBar:EnableMouse(false)
	MainMenuBarMaxLevelBar:SetWidth(512)
	MainMenuBarMaxLevelBar:ClearAllPoints()
	MainMenuBarMaxLevelBar:SetPoint("CENTER",MainMenuExpBar)

	--[[ Reputation Bar ]]
	ReputationWatchBar:SetParent(zXPBar)
	ReputationWatchBar:ClearAllPoints()
	ReputationWatchBar:SetPoint("BOTTOM",MainMenuExpBar,"TOP",0,0)
	ReputationWatchBar:SetWidth(512) ReputationWatchBar:SetHeight(XPHeight)

	ReputationWatchStatusBar:SetWidth(512)

	-- text
	RaiseFrameLevel(ReputationWatchBarOverlayFrame)
	ReputationWatchStatusBarText:SetFontObject(NumberFontNormalHuge)

	--[[ Textures ]]
	local list = {
		"MainMenuXPBarTexture",
		"MainMenuMaxLevelBar",
		"ReputationWatchBarTexture",
		"ReputationXPBarTexture",
	}
	for id, name in ipairs(list) do
		for i = 0, 3 do
			if name ~= "ReputationWatchBarTexture" then
				_G[name..i]:SetHeight(XPHeight)
			end
			_G[name..i]:ClearAllPoints()
		end
		_G[name.."0"]:SetPoint("LEFT")
		_G[name.."1"]:SetPoint("LEFT", name.."0","RIGHT")
		_G[name.."2"]:SetPoint("RIGHT", name.."3","LEFT")
		_G[name.."3"]:SetPoint("RIGHT")
	end

	self:Hook()
end

local function OnEnter()
	zXPBar:SetAlpha(1)
	if this == ReputationWatchBar then
		GameTooltip:SetOwner(this,"ANCHOR_CURSOR")
		GameTooltip:SetText(ReputationWatchStatusBarText:GetText())
		GameTooltip:Show()
	end
end
local function OnLeave()
	zXPBar:SetAlpha(zBar2Saves["zXPBar"].alpha)
	GameTooltip:Hide()
end
function zXPBar:Hook()
	MainMenuExpBar:HookScript("OnEnter", OnEnter)
	MainMenuExpBar:HookScript("OnLeave", OnLeave)
	ReputationWatchBar:HookScript("OnEnter", OnEnter)
	ReputationWatchBar:HookScript("OnLeave", OnLeave)

	--[[ Override when ReputationWatchBar Updates ]]
	ReputationWatchBar.zSetPoint = ReputationWatchBar.SetPoint
	ReputationWatchBar.SetPoint = zBar2.NOOP
	hooksecurefunc("ReputationWatchBar_Update", function(newLevel)
		local name, reaction = GetWatchedFactionInfo()
		if ( not newLevel ) then
			newLevel = UnitLevel("player");
		end
		if name then
			if newLevel < MAX_PLAYER_LEVEL then
				local r,g,b = 0,0,0
				if reaction < 5 then r = 1 end
				if reaction == 3 then g = 0.5 end
				if reaction > 3 then g = 1 end
				ReputationWatchStatusBar:SetStatusBarColor(r, g, b);
				ReputationWatchBar:zSetPoint("BOTTOM",MainMenuExpBar,"TOP",0,-2)
			else
				ReputationWatchBar:zSetPoint("BOTTOM",MainMenuExpBar,"BOTTOM",0,0)
				ReputationWatchStatusBar:SetHeight(XPHeight)
			end
		end
	end)
end

function zXPBar:UpdateButtons()
	local value = zBar2Saves[self:GetName()]
	if not value.num or value.num < 1 then value.num = 1 end
	local width = 512 + 256*(value.num-1)
	MainMenuExpBar:SetWidth(width)
	MainMenuBarMaxLevelBar:SetWidth(width)
	ReputationWatchBar:SetWidth(width)
	ReputationWatchStatusBar:SetWidth(width)

	for i = 1, 2 do
		local alpha = 0
		if i < value.num then alpha = 1 end
		_G["MainMenuXPBarTexture"..i]:SetAlpha(alpha)
		_G["MainMenuMaxLevelBar"..i]:SetAlpha(alpha)
		_G["ReputationWatchBarTexture"..i]:SetAlpha(alpha)
		_G["ReputationXPBarTexture"..i]:SetAlpha(alpha)
	end
end

function zXPBar:UpdateLayouts()
end

function zXPBar:Test()
	if self.sig then
		ReputationWatchBar_Update(MAX_PLAYER_LEVEL)
		self.sig = nil
	else
		ReputationWatchBar_Update(UnitLevel("player"))
		self.sig = 1
	end
end