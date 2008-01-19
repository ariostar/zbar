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
--~ 	bar:SetAttribute("unit2","player")
	bar:SetAttribute("actionpage", page)
	
	bar.GetButton = self.GetButton
	bar.UpdateLayouts = self.UpdateLayouts
	
	if prefix == "zShadow" then
		bar:SetID(-id)
		bar.isShadow = true
	else
		bar:SetID(id)
		bar.UpdateButtons = self.UpdateButtons
		local button
		for i = 1, 12 do
			button =bar:GetButton(i)
			button:SetID(i)
			bar:SetAttribute("addchild", button)
			zBar2.buttons["zExBar"..id..i] = button:GetName()
		end
		bar:GetButton(1):ClearAllPoints()
		bar:GetButton(1):SetPoint("CENTER")
	end
	
	return bar
end

function zExBars:Init()
	-- create buttons
	local button
	for id = 1, NUM_ZEXBAR_BUTTONS do
		button = CreateFrame("CheckButton", "zExButton"..id,UIParent,"SecureFrameTemplate,ActionBarButtonTemplate")
		_G[button:GetName().."NormalTexture"]:SetWidth(60)
		_G[button:GetName().."NormalTexture"]:SetHeight(60)
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
		bar = self:New("zExBar", id, page)
		-- create shadow bar
		bar = self:New("zShadow", id, page)
	end
	
	self:Hook()
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		self:UpdateGrid(1)
	end
end

function zExBars:GetButton(i)
	if self.isShadow then return _G[zBar2.buttons[self:GetName()..i]] end
	return _G["zExButton"..i + (self:GetID()-1)*NUM_ACTIONBAR_BUTTONS]
end

--[[ override functions ]]
function zExBars:UpdateButtons()
	local button
	local value = zBar2Saves[self:GetName()]
	local id = math.abs(self:GetID())
	for i = 12, 1, -1 do
		button = self:GetButton(i)
		if i <= (value.num or 1) then
			-- back to mine
			if button:GetParent() ~= self then
				button:SetParent(self)
				zBar2.buttons[self:GetName()..i] = button:GetName()
				zBar2.buttons["zShadow"..id..zBar2Saves["zShadow"..id].max] = nil
				zBar2Saves["zShadow"..id].max = 12- zBar2Saves[self:GetName()].num
				if zBar2Saves["zShadow"..id].num > zBar2Saves["zShadow"..id].max then
					zBar2Saves["zShadow"..id].num = zBar2Saves["zShadow"..id].max
				end
				
				_G["zShadow"..id]:UpdateLayouts()
			end
			if (button.showgrid > 0 or HasAction(button.action)) then
				button:Show()
			end
			button:SetAttribute("showstates", nil)
			button:SetAttribute("statehidden", nil)
		elseif button:GetParent() ~= _G["zShadow"..id] then
			-- move it to shadow bar
			button:Hide()
			button:SetAttribute("showstates", "!*")
			button:SetAttribute("statehidden", true)
			zBar2.buttons["zExBar"..id..i] = nil
			zBar2Saves["zShadow"..id].max = 13 - i
			zBar2.buttons["zShadow"..id..zBar2Saves["zShadow"..id].max] = button:GetName()
			button:SetParent("zShadow"..id)
			if zBar2Saves["zShadow"..id].num == 0 or zBar2Saves["zShadow"..id].linenum == 0 then
				zBar2Saves["zShadow"..id].num = 1
				zBar2Saves["zShadow"..id].linenum = 1
				_G["zShadow"..id]:UpdateLayouts()
			end
		end
	end
end

function zExBars:UpdateLayouts()
	if self.isShadow then
		if zBar2Saves[self:GetName()].num == 0 then return end
		local button = self:GetButton(1)
		if button and select(2, button:GetPoint("CENTER")) ~= self then
			if (button.showgrid > 0 or HasAction(button.action)) then
				button:Show()
			end
			button:SetAttribute("showstates", nil)
			button:SetAttribute("statehidden", nil)
			button:ClearAllPoints()
			button:SetPoint("CENTER")
		end
	end
	zBarT.UpdateLayouts(self)
end

--[[ Hooks ]]
function zExBars:Hook()
	hooksecurefunc("MultiActionBar_ShowAllGrids",function() zExBars:UpdateGrid(1) end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function() zExBars:UpdateGrid() end)
end

function zExBars:UpdateGrid(show)
	-- in combat we can't let it be shown or hidden
	if InCombatLockdown() then return end
	for i=1, NUM_ZEXBAR_BUTTONS do
		local button = _G["zExButton"..i]
		if show then
			if ( not button:GetAttribute("statehidden") ) then
				button:Show();
			end
		else
			if ( button.showgrid == 0 and not HasAction(button.action) ) then
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