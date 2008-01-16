local _G = getfenv(0)

CreateFrame("Frame", "zMainBar", UIParent, "SecureStateHeaderTemplate")
zBar2:RegisterPlugin(zMainBar)
zBar2:RegisterBar(zMainBar)

--[[
	functional
--]]
function zMainBar:Init()
	self:SetID(10)
	self:SetFrameStrata("HIGH")
	self:SetClampedToScreen(true)
	self:SetWidth(36) self:SetHeight(36)
	
--~ 	self:SetAttribute("unit2","player")
	self:SetAttribute("statemap-state", "$input")
	self:SetAttribute("statebutton", "1:p1;2:p2;3:p3;4:p4;5:p5;6:p6;7:p7;8:p8;9:p9;10:p10;")
--~ 	self:SetAttribute("statebutton2", "RightButton")
	self:UpdateStateHeader()
	
	SetModifiedClick("SELFCAST", "ALT") 

	for id=1,12 do
		self:RegisterButton(_G["ActionButton"..id], id)
		zBar2.buttons["zMainBar"..id] = "ActionButton"..id
		_G["ActionButton"..id.."NormalTexture"]:SetWidth(60)
		_G["ActionButton"..id.."NormalTexture"]:SetHeight(60)
	end
	ActionButton1:ClearAllPoints()
	ActionButton1:SetPoint("CENTER")
	
	BonusActionBarFrame:Hide()
	BonusActionBarFrame:UnregisterAllEvents()
	BonusActionBarFrame:SetScript("OnShow",BonusActionBarFrame.Hide)

	self:Hook()
	if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1) then
		self:UpdateGrid(1)
	end
	
	MainMenuBar:Hide()
	
end

--[[
	Privates
--]]

--[[ Hooks ]]
function zMainBar:Hook()
	hooksecurefunc("ActionButton_UpdateHotkeys", zMainBar.UpdateHotkey)
	
	hooksecurefunc("MultiActionBar_ShowAllGrids",function() zMainBar:UpdateGrid(1) end)
	hooksecurefunc("MultiActionBar_HideAllGrids",function() zMainBar:UpdateGrid() end)
end

function zMainBar:UpdateHotkey()
	if this:GetParent() == zMainBar then
		local hotkey = _G[this:GetName().."HotKey"]
		local key = GetBindingText(GetBindingKey(this:GetName()), "KEY_", 1)
		if ( key == "" ) then
			hotkey:SetText(RANGE_INDICATOR)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -12, -2);
			hotkey:Hide()
		else
			hotkey:SetText(key)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -2, -2)
			hotkey:Show()
		end
	end
end

function zMainBar:UpdateGrid(show)
	-- in combat we can't let it be shown or hidden
--~ 	if InCombatLockdown() then return end
	for i=1, NUM_MULTIBAR_BUTTONS do
		if ( show ) then
			ActionButton_ShowGrid(_G[zBar2.buttons["zMainBar"..i]])
		else
			ActionButton_HideGrid(_G[zBar2.buttons["zMainBar"..i]])
		end
	end
end

--[[ Page Mapping. partly reference to PM2 ]]
local triggers = {
	[1] = "[modifier:alt]2",
	[2] = "[help]2",
}
local stances = {
    ["PRIEST"] = { [1] = 7, [2] = 8, },
    ["ROGUE"] = { [1] = 7 },
    ["DRUID"] = { [1] = 9, [3] = 7, [5] = 8 },	-- moonkin/tree-of-life
    ["WARRIOR"] = { [1] = 7, [2] = 8, [3] = 9 },
}

local reverse = {
	["DRUID"] = { [3] = {"stealth", 8} },
}

function zMainBar:UpdateStateHeader()
    UnregisterStateDriver(zMainBar, "state")
	
	local class = select(2, UnitClass("player"))
    local header, state = "", ""
	
	if zBar2Saves["pageTrigger"] then
		for k,v in pairs(triggers) do
			state = v .. ";"
			header = header .. state
		end
	end
	
--~ 	if reverse[class] then
--~ 		for k,v in pairs(reverse[class]) do
--~ 			state = format("[actionbar:1,stance:%d,%s]%d;", k, v[1], v[2])
--~ 			header = header .. state
--~ 		end
--~ 	end
	
    if stances[class] then
        for k,v in pairs(stances[class]) do
            state = format("[actionbar:1,stance:%d]%d;", k, v)
			header = header .. state
        end
    end

    for i=1,6 do
		state = format("[actionbar:%d]%d;", i, i)
		header = header .. state
	end
	
--[[
"[modifier:alt]2; [help]2; [actionbar:1, stance:1]9; [actionbar:1, stance:3]7; [actionbar:1, stance:5]8;
[actionbar:1]1; [actionbar:2]2; [actionbar:3]3; [actionbar:4]4; [actionbar:5]5; [actionbar:6]6; 0"
--]]
--~ 		DEFAULT_CHAT_FRAME:AddMessage(header.."0")
	RegisterStateDriver(zMainBar, "state", header .. "0")
end

function zMainBar:RegisterButton(button, id)
	self:SetAttribute("addchild", button)
	
	button:SetID(-id)
	button:SetAttribute("stateheader", zMainBar)
    button:SetAttribute("useparent-statebutton", true)
	
	for p=1,10 do
        button:SetAttribute("*action-p"..p, id + (p-1)*12 )
    end
	button:Show()
	button.Show = function(self) self:SetAlpha(1) end
	button.Hide = function(self) self:SetAlpha(0) end
end

function zMainBar:StateChanged(newstate)
	local button
	for i = 1,12 do
		button = _G["ActionButton"..i]
		button.action = i + (tonumber(newstate)-1)*12
		_this = this
		this = button
		securecall(ActionButton_Update)
		this = _this
	end
end
