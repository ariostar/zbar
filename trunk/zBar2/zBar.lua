
local _G = getfenv(0)

--[[ Create ]]
CreateFrame("Frame", "zBar2", UIParent, "SecureFrameTemplate")
zBar2:RegisterEvent("VARIABLES_LOADED")
zBar2:RegisterEvent("PLAYER_LOGIN")

--[[ Tables ]]
zBar2Saves		= {}
zBar2.plugins	= {}
zBar2.bars		= {}
zBar2.buttons	= {}

--[[ Lite mode state ]]
zBar2.lite = select(4, GetAddOnInfo("zBar2Lite"))

--[[ Common functions ]]
function zBar2:print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end
-- function that does nothing
function zBar2:NOOP() end

--[[ Event ]]
function zBar2:OnEvent()
	if event == "VARIABLES_LOADED" then
		for k,v in ipairs(self.plugins) do
			if v.Init then v:Init() end
		end
		self:Init()
	elseif event == "PLAYER_LOGIN" then
		self:print("zBar2 v"..self.version.." Loaded :: Author - "..self.author.. " :: type /zbar",0.0,1.0,0.0)
	end
end
zBar2:SetScript("OnEvent", zBar2.OnEvent)

--[[ Register Sub Addon ]]
-- the order of registeration will also effect when Initialize !
function zBar2:RegisterPlugin(obj, afterWho)
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
function zBar2:RegisterBar(bar)
	self.bars[bar:GetName()] = bar
	
	-- inherit functions
	setmetatable(bar, {__index = zBarT})

end

--[[ Addon Init ]]
function zBar2:Init()
	self.version = GetAddOnMetadata("zBar2", "Version")
	self.author = GetAddOnMetadata("zBar2", "Author")

	if self.version ~= zBar2Saves.version then
		zBar2Saves = {}
		zBar2Saves.version = self.version
		self.firstime = true
	end
	
	for name, bar in pairs(self.bars) do
		bar:Reset()
	end
	
	self:Hook()
end

function zBar2:Hook()
	for name, bar in pairs(self.bars) do
		if bar:GetID() <= 10 then 
			for id = 1, NUM_ACTIONBAR_BUTTONS do
				button = _G[self.buttons[bar:GetName()..id]]
				if button then
					-- set button scripts
					button:SetScript("OnEnter",function()
						this:GetParent():SetAlpha(1)
						if zBar2Saves.hideTip then return end
						ActionButton_SetTooltip(this)
					end)
					button:SetScript("OnLeave",function()
						local bar = this:GetParent()
						bar:SetAlpha(zBar2Saves[bar:GetName()].alpha)
						if zBar2Saves.hideTip then return end
						GameTooltip:Hide()
					end)
				end
			end
		end
	end
end