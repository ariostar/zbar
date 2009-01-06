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
		self:Init()
		-- plugins init
		for k,v in ipairs(self.plugins) do
			if v.Load then v:Load() end
		end
		-- bars init
		for name, bar in pairs(self.bars) do
			bar:Reset()
		end
		-- hooks
		self:Hook()
		-- welcome message
		self:print("zBar3 v"..self.version.." Loaded :: Author - "..self.author.. " :: type /zbar",0.0,1.0,0.0)
	else
		self:Update(event)
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

	-- init grid signal
	self.showgrid = 0
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

	-- add events for grid, must after bars initial
	self:RegisterEvent("ACTIONBAR_SHOWGRID")
	self:RegisterEvent("ACTIONBAR_HIDEGRID")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- hooks for grid
	hooksecurefunc("MultiActionBar_ShowAllGrids",function()
		zBar3:IncGrid()
		zBar3:Update()
	end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function()
		zBar3:DecGrid()
		zBar3:Update()
	end)
end

zBar3.gridUpdaters = {}
function zBar3:RegisterGridUpdater(func)
	table.insert(self.gridUpdaters, func)
end

function zBar3:IncGrid()
	self.showgrid = self.showgrid + 1
end

function zBar3:DecGrid()
	if self.showgrid > 0 then
		self.showgrid = self.showgrid - 1
	end
end

function zBar3:Update(event)
	-- event stuff
	if event == "ACTIONBAR_SHOWGRID" then
		self:IncGrid()
	elseif event == "ACTIONBAR_HIDEGRID" then
		self:DecGrid()
	end
	-- some other updates
	for i, func in ipairs(self.gridUpdaters) do
		if func then func() end
	end
end