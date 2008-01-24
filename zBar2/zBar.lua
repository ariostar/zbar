
local _G = getfenv(0)

--[[ Create ]]
CreateFrame("Frame", "zBar2", UIParent, "SecureFrameTemplate")
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
	if event == "PLAYER_LOGIN" then
		-- self init
		zBar2:Init()
		-- plugins init
		for k,v in ipairs(zBar2.plugins) do
			if v.Init then v:Init() end
		end
		-- bars init
		for name, bar in pairs(zBar2.bars) do
			bar:Reset()
		end
		-- hooks
		zBar2:Hook()
		-- welcome message
		zBar2:print("zBar2 v"..zBar2.version.." Loaded :: Author - "..zBar2.author.. " :: type /zbar",0.0,1.0,0.0)
	else
		zBar2:Update(event)
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
	zBar2.version = GetAddOnMetadata("zBar2", "Version")
	zBar2.author = GetAddOnMetadata("zBar2", "Author")

	zBar2Saves = zBar2Saves or { version = zBar2.version,}
	if zBar2Saves.version ~= zBar2.version then
		zBar2Saves.version = zBar2.version
	end

	zBar2.class = select(2, UnitClass("player"))

	-- init grid signal
	self.showgrid = 0
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		self.showgrid = 1
	end
end

function zBar2:Hook()
	-- hook scripts for all action buttons
	local name, bar, button
	for name, bar in pairs(self.bars) do
		if bar:GetID() <= 10 then
			for id = 1, NUM_ACTIONBAR_BUTTONS do
				button = _G[self.buttons[bar:GetName()..id]]
				if button then
					button:SetMovable(true)
					button:SetResizable(true)
					-- set button scripts
					button:SetScript("OnEnter",function()
						if zTab:FreeOnEnter() then return end
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
	-- add events for grid, must after bars initial
	self:RegisterEvent("ACTIONBAR_SHOWGRID")
	self:RegisterEvent("ACTIONBAR_HIDEGRID")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- hooks for grid
	hooksecurefunc("MultiActionBar_ShowAllGrids",function()
		zBar2.showgrid = zBar2.showgrid + 1
		zBar2:Update()
	end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function()
		zBar2.showgrid = zBar2.showgrid - 1
		zBar2:Update()
	end)
end

zBar2.gridUpdaters = {}
function zBar2:RegisterGridUpdater(func)
	table.insert(self.gridUpdaters, func)
end

function zBar2:Update(event)
	-- event stuff
	if event == "ACTIONBAR_SHOWGRID" then
		self.showgrid = self.showgrid + 1
	elseif event == "ACTIONBAR_HIDEGRID" then
		self.showgrid = self.showgrid - 1
	end
	-- some other updates
	for i, func in ipairs(zBar2.gridUpdaters) do
		if func then func() end
	end
end