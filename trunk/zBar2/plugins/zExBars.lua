local _G = getfenv(0)
NUM_ZEXBAR_BUTTONS = 24
NUM_ZEXBAR_BAR = 2

zExBars = {}
function zExBars:GetName() return "zExBars" end
zBar2:RegisterPlugin(zExBars)

function zExBars:New(prefix,id,page)
	local bar = CreateFrame("Frame", prefix..id, UIParent, "SecureStateHeaderTemplate")
	zBar2:RegisterBar(bar)
	
	bar:SetID(id)
	bar:SetFrameStrata("MEDIUM")
	bar:SetClampedToScreen(true)
	bar:SetWidth(36); bar:SetHeight(36);
	bar:SetAttribute("unit2","player")
	bar:SetAttribute("actionpage", page)
	
	return bar
end

function zExBars:Init()
	local button
	for id = 1, NUM_ZEXBAR_BUTTONS do
		button = CreateFrame("CheckButton", "zExButton"..id,UIParent,"ActionBarButtonTemplate")
		if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
			ActionButton_ShowGrid(button)
		else
			ActionButton_HideGrid(button)
		end
		_G[button:GetName().."NormalTexture"]:SetWidth(60)
		_G[button:GetName().."NormalTexture"]:SetHeight(60)
	end
	
	local bar, page
	local class = select(2, UnitClass("player"))
	for id = 1, NUM_ZEXBAR_BAR do
		page = 11 - id
		if id == 2 then
			if class == "DRUID" then page = 8 end
			if class == "WARRIOR" then page = 1 end
		end
		bar = self:New("zExBar", id, page)
		for i = 1, 12 do
			bar:SetAttribute("addchild", self:GetButton(bar, i))
			zBar2.buttons["zExBar"..id..i] = self:GetButton(bar, i):GetName()
			self:GetButton(bar, i):SetScript("OnAttributeChanged", zExButton.AttributeChanged)
		end
		self:GetButton(bar, 1):ClearAllPoints()
		self:GetButton(bar, 1):SetPoint("CENTER")
		
		bar = self:New("zShadow", id, page)
	end
end

function zExBars:UpdateButtons()
	local button
	local value = zBar2Saves[self:GetName()]

	for i = 1, value.max or NUM_ACTIONBAR_BUTTONS do
		button = _G[zBar2.buttons[self:GetName()..i]]
		if i <= (value.num or 1) then
			if HasAction(button.action) then
				button:Show()
			end
			button:SetAttribute("showstates", nil)
			button:SetAttribute("statehidden", nil)
		else
			button:Hide()
			button:SetAttribute("showstates", "!*")
			button:SetAttribute("statehidden", true)
		end
	end
end

function zExBars:GetButton(bar, id)
	local button = _G["zExButton"..id+(bar:GetID()-1)*12]
	if button then return button end
	
	button = CreateFrame("CheckButton", "zExButton"..id+(bar:GetID()-1)*12,bar,"ActionBarButtonTemplate")
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		ActionButton_ShowGrid(button)
	else
		ActionButton_HideGrid(button)
	end
	_G[button:GetName().."NormalTexture"]:SetWidth(60)
	_G[button:GetName().."NormalTexture"]:SetHeight(60)
	
--~ 	button:SetScript("OnDragStart", zExButton.DragStart)
--~ 	button:SetScript("OnDragStop", zExButton.DragStop)
	
	return button
end

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

function zExBars:Hook()
	hooksecurefunc("MultiActionBar_ShowAllGrids",function() zExBars:UpdateGrid(1) end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function() zExBars:UpdateGrid() end)
end
function zExBars:UpdateGrid(show)
	-- in combat we can't let it be shown or hidden
	if InCombatLockdown() then return end
	for i=1, NUM_ZEXBAR_BUTTONS do
		if ( show ) then
			ActionButton_ShowGrid(_G["zExButton"..i])
		else
			ActionButton_HideGrid(_G["zExButton"..i])
		end
	end
end

--[[ Button Functions ]]
zExButton = {}
-- 
function zExButton:AttributeChanged(name, value)
	if name == "statehidden" then
	
	end
end

-- drag, change position when ctrl down,
-- the position is relative to prev button
function zExButton:DragStart()
	if IsControlKeyDown() then
		this:StartMoving()
		
	elseif LOCK_ACTIONBAR ~= "1" or IsModifiedClick("PICKUPACTION") then
		PickupAction(this.action);
		ActionButton_UpdateState();
		ActionButton_UpdateFlash();
	end
end

function zExButton:DragStop()
	if this.moving then
		this.moving = nil
		
		
		this:StopMovingOrSizing()
	end
end