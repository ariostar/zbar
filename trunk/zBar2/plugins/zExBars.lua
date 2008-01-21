local _G = getfenv(0)

NUM_ZEXBAR_BAR = 2
NUM_ZEXBAR_BUTTONS = 24

zExBars = {}
function zExBars:GetName() return "zExBars" end
zBar2:RegisterPlugin(zExBars)

function zExBars:New(prefix,id,page)
	local bar = CreateFrame("Frame", prefix..id, UIParent, "SecureStateHeaderTemplate")
	zBar2:RegisterBar(bar)
	
	bar:SetFrameStrata("MEDIUM")
	bar:SetClampedToScreen(true)
	bar:SetWidth(36); bar:SetHeight(36);
	bar:SetAttribute("actionpage", page)
	
	bar.GetButton = self.GetButton
	
	if prefix == "zShadow" then
		bar:SetID(-id)
		bar.isShadow = true
		rawset(bar, "UpdateButtons", zExBars.UpdateShadowButtons)
	else
		bar:SetID(id)
		rawset(bar, "UpdateButtons", zExBars.UpdateExBarButtons)
		local button
		for i = 1, 12 do
			button =bar:GetButton(i)
			button:SetID(i)
			button:SetParent(bar)
		end
		bar:GetButton(1):ClearAllPoints()
		bar:GetButton(1):SetPoint("CENTER")
	end
	
	return bar
end

function zExBars:Init()
	zExBars.showgrid = 0
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		zExBars.showgrid = 1
	end
	-- create buttons
	local button
	for id = 1, NUM_ZEXBAR_BUTTONS do
		button = CreateFrame("CheckButton", "zExButton"..id,UIParent,"SecureFrameTemplate,ActionBarButtonTemplate")
		_G["zExButton"..id.."NormalTexture"]:SetWidth(60)
		_G["zExButton"..id.."NormalTexture"]:SetHeight(60)
		_G["zExButton"..id.."NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0, 0.5)
		button.buttonType = "ZEXBUTTON"
	end
	
	-- create bars
	local bar, page
	local class = select(2, UnitClass("player"))
	for id = 1, NUM_ZEXBAR_BAR do
		page = 11 - id
		if id == 2 then
			if class == "DRUID" then page = 8 end
			if class == "WARRIOR" then page = 1 end
		end
		-- create normal bar
		self:New("zExBar", id, page)
		-- create shadow bar
		self:New("zShadow", id, page)
		
		self:UpdateShadows(id)
	end
	
	self:Hook()
end

function zExBars:GetButton(i)
	if self.isShadow then return _G[zBar2.buttons[self:GetName()..i]] end
	return _G["zExButton"..i + (self:GetID()-1)*NUM_ACTIONBAR_BUTTONS]
end

--[[ override functions ]]
function zExBars:UpdateExBarButtons() -- for ex bars
	local bar = self
	zBarT.UpdateButtons(bar)
	zExBars:UpdateShadows(bar:GetID())
	zExBars:UpdateGrid(bar)
end
function zExBars:UpdateShadowButtons()
	local bar = self
	zBarT.UpdateButtons(bar)
	zExBars:UpdateGrid(bar)
end

function zExBars:UpdateShadows(index)
	local id = math.abs(index)
	local num = zBar2Saves["zExBar"..id].num
	local bar = _G["zExBar"..id]
	local shadow = _G["zShadow"..id]
	for i = 1, 12 do
		local button = _G["zExButton"..i + (id-1)*NUM_ACTIONBAR_BUTTONS]
		if i > 1 then button:ClearAllPoints() end
		if i <= num then
			button:SetParent(bar)
			zBar2.buttons["zExBar"..id..i] = button:GetName()
			zBar2.buttons["zShadow"..id..13-i] = nil
		else
			button:SetParent(shadow)
			zBar2.buttons["zExBar"..id..i] = nil
			zBar2.buttons["zShadow"..id..13-i] = button:GetName()
		end
		_G[button:GetName().."Cooldown"]:SetFrameLevel(button:GetFrameLevel())
	end
	zBar2Saves["zShadow"..id].max = 12 - num
	if zBar2Saves["zShadow"..id].num > 12 - num then
		zBar2Saves["zShadow"..id].num = 12 - num
	elseif zBar2Saves["zShadow"..id].num == 0 then
		zBar2Saves["zShadow"..id].num = 12 - num
	end
	if zBar2Saves["zShadow"..id].linenum > 12 - num then
		zBar2Saves["zShadow"..id].linenum = 12 - num
	end
	button = shadow:GetButton(1)
	if button then
		button:ClearAllPoints()
		button:SetPoint("CENTER")
		shadow:UpdateLayouts()
	end
	shadow:UpdateButtons()
end

--[[ Hooks ]]
function zExBars:Hook()
	-- All those hooks is for extra buttons grid show or hide
	hooksecurefunc("MultiActionBar_ShowAllGrids",function()
		zExBars.showgrid = zExBars.showgrid + 1
		zExBars:UpdateGrid()
	end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function()
		zExBars.showgrid = zExBars.showgrid - 1
		zExBars:UpdateGrid()
	end)
	hooksecurefunc("ActionButton_HideGrid", function()
		if this == zExButton24 then
			zExBars:UpdateGrid()
		end
	end)
	-- hook events on zExBar1
	zExBar1:RegisterEvent("ACTIONBAR_SHOWGRID")
	zExBar1:RegisterEvent("ACTIONBAR_HIDEGRID")
	zExBar1:RegisterEvent("PLAYER_ENTERING_WORLD")
	zExBar1:SetScript("OnEvent", function()
		if event == "ACTIONBAR_SHOWGRID" then
			zExBars.showgrid = zExBars.showgrid + 1
			zExBars:UpdateGrid()
		elseif event == "ACTIONBAR_HIDEGRID" then
			zExBars.showgrid = zExBars.showgrid - 1
			zExBars:UpdateGrid()
		elseif event == "PLAYER_ENTERING_WORLD" then
			if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
				zExBars:UpdateGrid()
			end
		end
	end)
end

function zExBars:UpdateGrid(bar)
	-- in combat we can't let it be shown or hidden
	if InCombatLockdown() then return end
	
	if bar then
		for i=1, zBar2Saves[bar:GetName()].num do
			if zExBars.showgrid > 0 then
				bar:GetButton(i):Show()
			end
		end
		return
	end
	
	local show = (zExBars.showgrid > 0)
	for i=1, NUM_ZEXBAR_BUTTONS do
		local button = _G["zExButton"..i]
		if show then
			if not button:GetAttribute("statehidden") then
				button:Show();
			end
		else
			if not HasAction(button.action) then
				button:Hide();
			end
		end
	end
end

--[[ bindings ]]
function zExBars:OnBindingKey(id)
	local button = _G["zExButton"..id]
	if ( keystate == "down" ) then
		if ( button:GetButtonState() == "NORMAL" ) then
			button:SetButtonState("PUSHED");
		end
	else
		if ( button:GetButtonState() == "PUSHED" ) then
			button:SetButtonState("NORMAL");
			SecureActionButton_OnClick(button, "LeftButton");
			ActionButton_UpdateState(button);
		end
	end
end