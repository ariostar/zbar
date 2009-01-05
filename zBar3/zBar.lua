--[[ Create ]]
zBar3 = CreateFrame("Frame",nil,UIParent)
zBar3:RegisterEvent("PLAYER_LOGIN")

--[[ Tables ]]
zBar3.plugins = {}
zBar3.bars    = {}
zBar3.buttons = {}

--[[ Common functions ]]
function zBar3:print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

--[[ Event ]]
function zBar3:OnEvent()
	if event == "PLAYER_LOGIN" then
		-- self init
		zBar3:Init()
		-- plugins init
		for k,v in ipairs(zBar3.plugins) do
			if v.Load then v:Load() end
		end
		-- bars init
		for name, bar in pairs(zBar3.bars) do
			bar:Reset()
		end
		-- hooks
		zBar3:Hook()
		-- welcome message
		zBar3:print("zBar3 v"..zBar3.version.." Loaded :: Author - "..zBar3.author.. " :: type /zbar",0.0,1.0,0.0)
	end
end
zBar3:SetScript("OnEvent", zBar3.OnEvent)

--[[ Register Sub Addon ]]
-- the order of registeration will also effect when Initialize !
function zBar3:AddPlugin(obj, afterWho)
	-- insert behine the afterWho
	if afterWho then
		for k,v in ipairs(self.plugins) do
			if v == afterWho then
				table.insert(self.plugins, k, obj)
				return
			end
		end
	end
	-- otherwise just append it
	table.insert(self.plugins, obj)
end

--[[ Register a Bar ]]
function zBar3:AddBar(bar)
	self.bars[bar:GetName()] = bar

	-- inherit functions
	setmetatable(bar, {__index = zBarT})

end

--[[ Addon Init ]]
function zBar3:Init()
	-- version
	self.version = GetAddOnMetadata("zBar3", "Version")
	self.author  = GetAddOnMetadata("zBar3", "Author")

	-- data
	zBar3Data = zBar3Data or { version = zBar3.version,}

	-- Lite mode state
	self.lite = select(4, GetAddOnInfo("zBar3Lite"))

	-- function that does nothing
	self.NOOP = function() end

	-- hidden frame
	self.hiddenFrame = CreateFrame("Frame")
	self.hiddenFrame:Hide()

	-- class
	self.class = select(2, UnitClass("player"))
end

function zBar3:Hook()
	-- remove that '?' thing
	for id, name in pairs(self.buttons) do
		local hotkey = _G[name.."HotKey"]
		if hotkey and hotkey:GetText() == RANGE_INDICATOR then
			hotkey:SetText("  ")
		end
	end
	RANGE_INDICATOR = "  "

	-- hook scripts for all action buttons
	local name, bar, button
	for name, bar in pairs(self.bars) do
		if bar:GetID() <= 10 then
			for id = 1, NUM_ACTIONBAR_BUTTONS do
				button = _G[self.buttons[bar:GetName()..id]]
				if button then
					button:SetMovable(true)
					-- set button scripts
					button:SetScript("OnEnter",function(self)
						if zTab:FreeOnEnter(self) then return end
						self:GetParent():SetAlpha(1)
						if zBar3Data.hideTip then return end
						ActionButton_SetTooltip(self)
					end)
					button:SetScript("OnLeave",function(self)
						local bar = self:GetParent()
						bar:SetAlpha(zBar3Data[bar:GetName()].alpha)
						if zBar3Data.hideTip then return end
						GameTooltip:Hide()
					end)
				end
			end
		end
	end
end