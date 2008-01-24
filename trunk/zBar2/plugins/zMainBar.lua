if zBar2.lite then return end
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
	self:SetAttribute("statemap-actionpage", "$input")
	self:SetAttribute("statebutton", "1:p1;2:p2;3:p3;4:p4;5:p5;6:p6;7:p7;8:p8;9:p9;10:p10;11:p11")
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
	BonusActionBarFrame.Show = BonusActionBarFrame.Hide
	
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
	
	-- hook stance rescan for priest or druid
	if zBar2.class == "PRIEST" or zBar2.class == "DRUID" then
		hooksecurefunc("ShapeshiftBar_UpdateState", zMainBar.UpdateStanceMap)
	end
end

function zMainBar:UpdateHotkey()
	if this:GetParent() == zMainBar then
		local hotkey = _G[this:GetName().."HotKey"]
		local text = GetBindingText(GetBindingKey(this:GetName()), "KEY_", 1)
		if ( text == "" ) then
			hotkey:SetText(RANGE_INDICATOR)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -12, -2);
			hotkey:Hide()
		else
			hotkey:SetText(text)
			hotkey:SetPoint("TOPLEFT", this, "TOPLEFT", -2, -2)
			hotkey:Show()
		end
	end
end

function zMainBar:UpdateGrid(show)
	-- in combat we can't let it be shown or hidden
--~ 	if InCombatLockdown() then return end
	for i=1, 12 do
		if ( show ) then
			ActionButton_ShowGrid(_G["ActionButton"..i])
		else
			ActionButton_HideGrid(_G["ActionButton"..i])
		end
	end
end

--[[ Page Mapping. partly reference to PM2 ]]
local triggers = {
	[1] = "[modifier:alt]2",
	[2] = "[help]2",
}
local stances = {
    ["ROGUE"] = { [1] = 7 },
    ["WARRIOR"] = { [1] = 7, [2] = 8, [3] = 9 },
}
local stanceTextureMap = {
	["PRIEST"] = {
		["Shadowform"] = 7,
	},
	["DRUID"] = {
		["BearForm"] = 9,
		["CatForm"] = 7,
		["TreeofLife"] = 8,
		["ForceOfNature"] = 8,	-- moonkin
	},
}

--[[
	rescan stances for Priest or Druid
--]]
zMainBar.numForms = 0
function zMainBar:UpdateStanceMap()
	local numForms = GetNumShapeshiftForms()
	-- return if no changes
	if numForms == zMainBar.numForms then return end
	zMainBar.numForms = numForms
	-- rescan stance map
	stances[zBar2.class] = {} -- clear stances
	for i = 1, numForms do
		local texture, name, isActive = GetShapeshiftFormInfo(i)
		if isActive then
			local j = 1
			local buffName, rank, buffTexture = UnitBuff("player", j)
			while buffName do
				if buffName == name then
					texture = buffTexture
				end
				j = j + 1
				buffName, rank, buffTexture = UnitBuff("player", j)
			end
		end
		for str, page in pairs(stanceTextureMap[zBar2.class]) do
			if string.find(string.lower(texture), string.lower(str)) then
				stances[zBar2.class][i] = page
			end
		end
	end
	-- update
	if not InCombatLockdown() then -- for secure
		zMainBar:UpdateStateHeader()
		zBar2:print("zBar2 - Detecting Stances for "..UnitClass("player"), 1,1,0)
	else
		zMainBar.numForms = 0 -- rescan on next stance change
	end
end

function zMainBar:UpdateStateHeader()
    UnregisterStateDriver(zMainBar, "actionpage")
	
    local header, state = "", ""
	
	if zBar2Saves["pageTrigger"] then
		for k,v in pairs(triggers) do
			state = v .. ";"
			header = header .. state
		end
	end
	
    if stances[zBar2.class] then
        for k,v in pairs(stances[zBar2.class]) do
            state = format("[actionbar:1,stance:%d]%d;", k, v)
			header = header .. state
        end
    end

    for i=1,6 do
		state = format("[actionbar:%d]%d;", i, i)
		header = header .. state
	end
	
	RegisterStateDriver(zMainBar, "actionpage", header .. "0")
end

function zMainBar:RegisterButton(button, id)
	self:SetAttribute("addchild", button)
	
	button:SetID(-id)
	button:SetAttribute("stateheader", self)
    button:SetAttribute("useparent-statebutton", true)

	for p=1,11 do
        button:SetAttribute("*action-p"..p, id + (p-1)*12 )
    end
	button:Show()
	button.Hide = function(self) self:SetAlpha(0) end
	button.Show = function(self) self:SetAlpha(1) end
end
